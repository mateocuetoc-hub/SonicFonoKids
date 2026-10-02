#!/usr/bin/env python3
"""Run integration tests with SRB2's integer Lua VM and simulated engine APIs."""
import argparse
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def build_vm(engine, destination):
    source = engine / "src" / "blua"
    if not (source / "lvm.c").is_file():
        raise SystemExit("Se necesita el codigo fuente de SRB2 con src/blua/.")
    vm = destination / "blua"
    shutil.copytree(source, vm)
    # Only host file loading and the fixed-point string-format constant need
    # adapters. The lexer, parser, VM and integer arithmetic remain unchanged.
    base = (vm / "lbaselib.c").read_text()
    base = re.sub(r'^#include "\.\./[^\n]+\n', '', base, flags=re.M)
    start = base.index('// Edited to load PK3 entries instead')
    end = base.index('static int luaB_assert', start)
    base = base[:start] + '''static int luaB_dofile(lua_State *L) {
  const char *name = luaL_checkstring(L, 1);
  int n = lua_gettop(L);
  if (luaL_loadfile(L, name)) return lua_error(L);
  lua_call(L, 0, LUA_MULTRET);
  return lua_gettop(L) - n;
}
static int luaB_loadfile(lua_State *L) {
  if (luaL_loadfile(L, luaL_checkstring(L, 1))) return lua_error(L);
  return 1;
}
''' + base[end:]
    (vm / "lbaselib.c").write_text(base)
    strings = (vm / "lstrlib.c").read_text()
    strings = strings.replace('#include "../m_fixed.h"', '#define FRACUNIT 65536')
    (vm / "lstrlib.c").write_text(strings)
    runner = destination / "runner.c"
    runner.write_text('''#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
int main(int argc, char **argv) {
  lua_State *L = luaL_newstate();
  if (!L) return 2;
  luaopen_base(L); lua_settop(L, 0);
  luaopen_table(L); lua_settop(L, 0);
  luaopen_string(L); lua_settop(L, 0);
  for (int i = 1; i < argc; ++i) {
    if (luaL_loadfile(L, argv[i]) || lua_pcall(L, 0, 0, 0)) {
      fprintf(stderr, "%s\\n", lua_tostring(L, -1));
      lua_close(L); return 1;
    }
  }
  lua_close(L); return 0;
}
''')
    sources = sorted(p for p in vm.glob('*.c') if p.name not in ('liolib.c', 'linit.c', 'loslib.c'))
    executable = destination / "srb2-lua-test"
    subprocess.run(['cc', '-O2', '-I', str(vm), str(runner),
                    *map(str, sources), '-lm', '-o', str(executable)], check=True)
    return executable


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--engine-source', type=Path, required=True)
    parser.add_argument('--game-source', type=Path, default=ROOT / 'Lua/main.lua',
                        help='Optional baseline for checking regression coverage')
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix='fonokids-tests-') as folder:
        vm = build_vm(args.engine_source.resolve(), Path(folder))
        tests = sorted((ROOT / 'Tests').glob('test_*.lua'))
        for test in tests:
            print(f'Running {test.name}', flush=True)
            result = subprocess.run([str(vm), str(ROOT / 'Tests/engine_stub.lua'),
                                     str(args.game_source.resolve()), str(test)], cwd=ROOT,
                                    text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            output = result.stdout
            for report in re.findall(r'BEGIN_JSON\n(.*?)\nEND_JSON', output, re.S):
                data = json.loads(report)
                assert isinstance(data.get('pares_detalle'), list)
            print(re.sub(r'BEGIN_JSON\n.*?\nEND_JSON\n?', '', output, flags=re.S), end='')
            result.check_returncode()
    subprocess.run(['python3', str(ROOT / 'Tests/test_package.py')], cwd=ROOT, check=True)


if __name__ == '__main__':
    main()
