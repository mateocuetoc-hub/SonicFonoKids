import argparse
import json
from pathlib import Path


def cargar_json(ruta):
    with open(ruta, "r", encoding="utf-8") as archivo:
        return json.load(archivo)


def clasificar_desempeno(porcentaje):
    if porcentaje >= 80:
        return "desempeño alto dentro de la actividad"
    if porcentaje >= 50:
        return "desempeño intermedio dentro de la actividad"
    return "desempeño bajo dentro de la actividad"


def generar_observacion(porcentaje, errores):
    if errores == 0:
        return (
            "El desempeño dentro del juego muestra respuestas correctas en todos "
            "los intentos registrados."
        )

    if porcentaje >= 50:
        return (
            "El desempeño dentro del juego muestra una combinación de respuestas "
            "correctas y errores. Los errores registrados pueden orientar una revisión "
            "fonoaudiológica posterior."
        )

    return (
        "El desempeño dentro del juego muestra mayor cantidad de errores que respuestas "
        "correctas. Esto no debe interpretarse como diagnóstico, pero puede servir para "
        "revisar si la actividad requiere más apoyo, menor dificultad o repetición guiada."
    )


def generar_sugerencia(porcentaje):
    if porcentaje >= 80:
        return (
            "Se podría considerar aumentar gradualmente la dificultad, agregando más "
            "distractores, nuevas sílabas o actividades con menor apoyo visual."
        )

    if porcentaje >= 50:
        return (
            "Se podría repetir la actividad y revisar especialmente las palabras que "
            "generaron error, manteniendo apoyo visual y verbal."
        )

    return (
        "Se podría simplificar la actividad, reducir la cantidad de distractores y "
        "reforzar el objetivo con apoyo visual, repetición y modelado."
    )


def formatear_completado(valor):
    if isinstance(valor, bool):
        return "sí" if valor else "no"

    texto = str(valor).strip().lower()
    return "sí" if texto in {"true", "1", "si", "sí"} else "no"


def describir_objetivo(actividad, objetivo):
    if "vocabulario" in actividad.lower():
        return f"Categoría trabajada: {objetivo}"

    return f"Sílaba inicial trabajada: {objetivo}"


def generar_reporte(datos):
    jugador = datos.get("jugador_anonimo", "Nino_001")
    actividad = datos.get("actividad", "actividad no especificada")
    objetivo = datos.get("objetivo", "no especificado")
    nivel = datos.get("nivel", "no especificado")
    intentos = int(datos.get("intentos_totales", 0))
    correctas = int(datos.get("respuestas_correctas", 0))
    errores = int(datos.get("errores", 0))
    ayudas = int(datos.get("ayudas_usadas", 0))
    porcentaje = float(datos.get("porcentaje_logro", 0))
    completado = formatear_completado(datos.get("completado", False))
    errores_detalle = datos.get("errores_detalle", [])

    desempeno = clasificar_desempeno(porcentaje)
    observacion = generar_observacion(porcentaje, errores)
    sugerencia = generar_sugerencia(porcentaje)

    lineas = []

    lineas.append("REPORTE DESCRIPTIVO - SONIC FONOKIDS")
    lineas.append("=" * 48)
    lineas.append("")
    lineas.append("1. Identificación de la sesión")
    lineas.append(f"Jugador anónimo: {jugador}")
    lineas.append(f"Nivel: {nivel}")
    lineas.append(f"Actividad: {actividad}")
    lineas.append(describir_objetivo(actividad, objetivo))
    lineas.append(f"Actividad completada: {completado}")
    lineas.append("")

    lineas.append("2. Resultados generales")
    lineas.append(f"Intentos totales: {intentos}")
    lineas.append(f"Respuestas correctas: {correctas}")
    lineas.append(f"Errores: {errores}")
    lineas.append(f"Ayudas usadas: {ayudas}")
    lineas.append(f"Porcentaje de logro: {porcentaje}%")
    lineas.append(f"Resultado descriptivo: {desempeno}")
    lineas.append("")

    lineas.append("3. Observaciones descriptivas")
    lineas.append(observacion)
    lineas.append("")

    lineas.append("4. Detalle de errores")
    if errores_detalle:
        for i, error in enumerate(errores_detalle, start=1):
            palabra = error.get("palabra", "sin palabra")
            tipo = error.get("tipo", "sin tipo")
            lineas.append(f"{i}. Palabra: {palabra} | Tipo de error: {tipo}")
    else:
        lineas.append("No se registraron errores.")
    lineas.append("")

    lineas.append("5. Sugerencias generales para revisión")
    lineas.append(sugerencia)
    lineas.append("")

    lineas.append("6. Advertencia")
    lineas.append(
        "Este reporte es descriptivo y se basa únicamente en datos obtenidos dentro "
        "del videojuego Sonic FonoKids."
    )
    lineas.append(
        "No constituye diagnóstico fonoaudiológico ni reemplaza la interpretación "
        "de una persona formada en el área."
    )

    return "\n".join(lineas)


def obtener_ruta_salida(ruta_entrada, ruta_salida):
    if ruta_salida is not None:
        return Path(ruta_salida)

    nombre = ruta_entrada.stem
    return Path("Reports") / f"reporte_{nombre}.txt"


def main():
    parser = argparse.ArgumentParser(
        description="Genera reportes descriptivos para Sonic FonoKids."
    )

    parser.add_argument(
        "entrada",
        nargs="?",
        default="Reports/sesion_demo.json",
        help="Ruta del archivo JSON de sesión."
    )

    parser.add_argument(
        "-o",
        "--output",
        default=None,
        help="Ruta del archivo de salida TXT."
    )

    args = parser.parse_args()

    ruta_entrada = Path(args.entrada)
    ruta_salida = obtener_ruta_salida(ruta_entrada, args.output)

    if not ruta_entrada.exists():
        print(f"No se encontró el archivo de entrada: {ruta_entrada}")
        print("Crea un JSON en Reports/ o usa el comando fonojson dentro del juego.")
        return 1

    try:
        datos = cargar_json(ruta_entrada)
    except json.JSONDecodeError as error:
        print("El archivo no tiene formato JSON válido.")
        print(error)
        return 1

    if not isinstance(datos, dict):
        print("El JSON debe contener un objeto con los datos de una sesión.")
        return 1

    reporte = generar_reporte(datos)

    ruta_salida.parent.mkdir(parents=True, exist_ok=True)
    ruta_salida.write_text(reporte, encoding="utf-8")

    print("Reporte generado correctamente.")
    print(f"Entrada: {ruta_entrada}")
    print(f"Salida: {ruta_salida}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
