#!/usr/bin/env python3
"""Copia un WAD y cambia de forma segura el nombre de su marcador de mapa."""

from __future__ import annotations

import argparse
import struct
from pathlib import Path


def normalizar_nombre(nombre: str) -> bytes:
    nombre_bytes = nombre.upper().encode("ascii")

    if not 1 <= len(nombre_bytes) <= 8:
        raise ValueError("El nombre del lump debe contener entre 1 y 8 caracteres ASCII")

    return nombre_bytes.ljust(8, b"\0")


def renombrar_marcador(origen: Path, destino: Path, anterior: str, nuevo: str) -> None:
    datos = bytearray(origen.read_bytes())

    if len(datos) < 12 or datos[:4] not in (b"IWAD", b"PWAD"):
        raise ValueError(f"{origen} no es un archivo WAD valido")

    cantidad_lumps, offset_directorio = struct.unpack_from("<II", datos, 4)
    nombre_anterior = normalizar_nombre(anterior)
    nombre_nuevo = normalizar_nombre(nuevo)
    reemplazos = 0

    for indice in range(cantidad_lumps):
        posicion_nombre = offset_directorio + indice * 16 + 8

        if posicion_nombre + 8 > len(datos):
            raise ValueError("El directorio del WAD esta incompleto")

        if datos[posicion_nombre : posicion_nombre + 8] == nombre_anterior:
            datos[posicion_nombre : posicion_nombre + 8] = nombre_nuevo
            reemplazos += 1

    if reemplazos != 1:
        raise ValueError(
            f"Se esperaba un marcador {anterior} y se encontraron {reemplazos}"
        )

    destino.parent.mkdir(parents=True, exist_ok=True)
    destino.write_bytes(datos)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("origen", type=Path)
    parser.add_argument("destino", type=Path)
    parser.add_argument("anterior")
    parser.add_argument("nuevo")
    argumentos = parser.parse_args()

    renombrar_marcador(
        argumentos.origen,
        argumentos.destino,
        argumentos.anterior,
        argumentos.nuevo,
    )


if __name__ == "__main__":
    main()
