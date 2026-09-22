#!/usr/bin/env bash

set -euo pipefail

addon_path="$HOME/.var/app/org.srb2.SRB2/.srb2/addons/SonicFonoKids.pk3"

if [[ ! -f "$addon_path" ]]; then
    echo "No se encontro $addon_path"
    echo "Ejecuta primero: ./build.sh"
    exit 1
fi

exec flatpak run org.srb2.SRB2 \
    -opengl \
    -file "$addon_path"
