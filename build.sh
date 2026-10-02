#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PK3_PATH="${FONO_PK3_PATH:-$(dirname "$ROOT_DIR")/SonicFonoKids.pk3}"
ADDONS_DIR="${FONO_ADDONS_DIR:-$HOME/.var/app/org.srb2.SRB2/.srb2/addons}"
BUILD_DIR=""
ADDON_TEMP=""

cleanup() {
    if [[ -n "$BUILD_DIR" ]]; then rm -rf -- "$BUILD_DIR"; fi
    if [[ -n "$ADDON_TEMP" ]]; then rm -f -- "$ADDON_TEMP"; fi
}
trap cleanup EXIT

cd "$ROOT_DIR"

for tool in python3 zip; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Error: falta $tool para compilar el addon." >&2
        exit 1
    fi
done

mapfile -t LUA_FILES < <(find Lua -type f -name '*.lua' -print)

if [[ "${#LUA_FILES[@]}" -ne 1 || "${LUA_FILES[0]}" != "Lua/main.lua" ]]; then
    echo "Error: Lua/ debe contener solamente Lua/main.lua."
    echo "Mueve los respaldos a Backups/ antes de compilar."
    printf 'Archivo detectado: %s\n' "${LUA_FILES[@]:-ninguno}"
    exit 1
fi

echo "Generando SonicFonoKids.pk3..."
# Preparar todo antes de reemplazar el ultimo paquete que funcionaba.
mkdir -p "$(dirname "$PK3_PATH")"
BUILD_DIR="$(mktemp -d "$(dirname "$PK3_PATH")/.fono-build.XXXXXX")"
mkdir -p "$BUILD_DIR/Maps"
BUILD_PK3="$BUILD_DIR/SonicFonoKids.pk3"

# El bosquejo educativo fue creado originalmente como MAP01. Durante la
# compilacion se cambia solo su marcador interno a MAPA0 para dejar libre
# Greenflower Zone Act 1, que se usa como premio de juego libre.
python3 Tools/renombrar_mapa_wad.py \
    Maps/MAP01.wad \
    "$BUILD_DIR/Maps/MAPA0.wad" \
    MAP01 \
    MAPA0

zip -qr "$BUILD_PK3" Lua SOC Sprites Sounds Music

(
    cd "$BUILD_DIR"
    zip -qr "$BUILD_PK3" Maps/MAPA0.wad
)

python3 - "$BUILD_PK3" <<'PY'
import sys
import zipfile
with zipfile.ZipFile(sys.argv[1]) as package:
    corrupt = package.testzip()
    if corrupt is not None:
        raise SystemExit("Error: archivo corrupto en el PK3: " + corrupt)
PY
mv -f -- "$BUILD_PK3" "$PK3_PATH"

mkdir -p "$ADDONS_DIR"
ADDON_TEMP="$(mktemp "$ADDONS_DIR/.SonicFonoKids.XXXXXX")"
cp -- "$PK3_PATH" "$ADDON_TEMP"
chmod 644 "$ADDON_TEMP"
mv -f -- "$ADDON_TEMP" "$ADDONS_DIR/SonicFonoKids.pk3"
ADDON_TEMP=""

echo "Listo."
echo "PK3 creado en: $PK3_PATH"
echo "Copiado a: $ADDONS_DIR/SonicFonoKids.pk3"
