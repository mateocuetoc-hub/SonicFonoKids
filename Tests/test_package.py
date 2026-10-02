"""Packaging integration: exact resources and preservation on failed builds."""
import os
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
import unittest
import zipfile

ROOT = Path(__file__).resolve().parents[1]


class PackageTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='fonokids-package-')
        self.folder = Path(self.temporary.name)
        self.repo = self.folder / 'repo'
        shutil.copytree(ROOT, self.repo, ignore=shutil.ignore_patterns('.git', '__pycache__'))
        self.pk3 = self.folder / 'SonicFonoKids.pk3'
        self.addons = self.folder / 'addons'
        self.addons.mkdir()
        self.env = dict(os.environ, FONO_PK3_PATH=str(self.pk3), FONO_ADDONS_DIR=str(self.addons))

    def tearDown(self):
        self.temporary.cleanup()

    def build(self):
        return subprocess.run(['bash', 'build.sh'], cwd=self.repo, env=self.env,
                              text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    def test_resources_and_map_marker(self):
        result = self.build()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(self.pk3.read_bytes(), (self.addons / self.pk3.name).read_bytes())
        with zipfile.ZipFile(self.pk3) as package:
            self.assertIsNone(package.testzip())
            self.assertEqual([n for n in package.namelist() if n.endswith('.lua')], ['Lua/main.lua'])
            for directory in ['Lua', 'SOC', 'Sprites', 'Sounds', 'Music']:
                for source in (self.repo / directory).rglob('*'):
                    if source.is_file():
                        self.assertEqual(package.read(source.relative_to(self.repo).as_posix()), source.read_bytes())
            old = (self.repo / 'Maps/MAP01.wad').read_bytes()
            new = package.read('Maps/MAPA0.wad')
            count, offset = struct.unpack_from('<II', old, 4)
            expected = bytearray(old)
            changed = 0
            for index in range(count):
                position = offset + index * 16 + 8
                if old[position:position + 8] == b'MAP01\0\0\0':
                    expected[position:position + 8] = b'MAPA0\0\0\0'
                    changed += 1
            self.assertEqual(changed, 1)
            self.assertEqual(new, expected)
            self.assertNotIn('Maps/MAP01.wad', package.namelist())
            self.assertFalse(any(n.startswith('Tests/') for n in package.namelist()))
        self.assertEqual(list(self.folder.glob('.fono-build.*')), [])
        self.assertEqual(list(self.addons.glob('.SonicFonoKids.*')), [])

    def test_failed_map_build_keeps_previous_package(self):
        self.pk3.write_bytes(b'previous-pk3')
        (self.addons / self.pk3.name).write_bytes(b'previous-addon')
        (self.repo / 'Maps/MAP01.wad').write_bytes(b'invalid-wad')
        self.assertNotEqual(self.build().returncode, 0)
        self.assertEqual(self.pk3.read_bytes(), b'previous-pk3')
        self.assertEqual((self.addons / self.pk3.name).read_bytes(), b'previous-addon')
        self.assertEqual(list(self.folder.glob('.fono-build.*')), [])

    def test_reject_duplicate_lua_without_replacing_package(self):
        self.pk3.write_bytes(b'previous-pk3')
        (self.repo / 'Lua/backup.lua').write_text('print("backup")')
        result = self.build()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('solamente Lua/main.lua', result.stdout)
        self.assertEqual(self.pk3.read_bytes(), b'previous-pk3')


if __name__ == '__main__':
    unittest.main()
