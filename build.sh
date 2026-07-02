#!/bin/bash

echo "Generando SonicFonoKids.pk3..."

cd "$(dirname "$0")"

mkdir -p Lua SOC Sprites Sounds

rm -f ../SonicFonoKids.pk3

zip -r ../SonicFonoKids.pk3 Lua SOC Sprites Sounds

mkdir -p ~/.var/app/org.srb2.SRB2/.srb2/addons

cp ../SonicFonoKids.pk3 ~/.var/app/org.srb2.SRB2/.srb2/addons/

echo "Listo."
echo "PK3 creado en: ~/SRB2Mods/SonicFonoKids.pk3"
echo "Copiado a la carpeta de addons de SRB2."
