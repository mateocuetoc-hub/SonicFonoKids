#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PK3_PATH="$(dirname "$ROOT_DIR")/SonicFonoKids.pk3"
ADDONS_DIR="$HOME/.var/app/org.srb2.SRB2/.srb2/addons"

cd "$ROOT_DIR"

mkdir -p Lua SOC Sprites Sounds Maps

mapfile -t LUA_FILES < <(find Lua -type f -name '*.lua' -print)

if [[ "${#LUA_FILES[@]}" -ne 1 || "${LUA_FILES[0]}" != "Lua/main.lua" ]]; then
    echo "Error: Lua/ debe contener solamente Lua/main.lua."
    echo "Mueve los respaldos a Backups/ antes de compilar."
    printf 'Archivo detectado: %s\n' "${LUA_FILES[@]:-ninguno}"
    exit 1
fi

echo "Generando SonicFonoKids.pk3..."
rm -f "$PK3_PATH"
zip -qr "$PK3_PATH" Lua SOC Sprites Sounds

if compgen -G "Maps/*.wad" > /dev/null; then
    zip -qr "$PK3_PATH" Maps/*.wad
fi

mkdir -p "$ADDONS_DIR"
cp "$PK3_PATH" "$ADDONS_DIR/SonicFonoKids.pk3"

echo "Listo."
echo "PK3 creado en: $PK3_PATH"
echo "Copiado a: $ADDONS_DIR/SonicFonoKids.pk3"
