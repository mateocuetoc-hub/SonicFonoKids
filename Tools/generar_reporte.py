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


def generar_reporte(datos):
    jugador = datos.get("jugador_anonimo", "Nino_001")
    actividad = datos.get("actividad", "actividad no especificada")
    objetivo = datos.get("objetivo", "no especificado")
    intentos = datos.get("intentos_totales", 0)
    correctas = datos.get("respuestas_correctas", 0)
    errores = datos.get("errores", 0)
    ayudas = datos.get("ayudas_usadas", 0)
    porcentaje = datos.get("porcentaje_logro", 0)
    completado = datos.get("completado", "false")
    errores_detalle = datos.get("errores_detalle", [])

    desempeno = clasificar_desempeno(porcentaje)

    lineas = []

    lineas.append("REPORTE DESCRIPTIVO - SONIC FONOKIDS")
    lineas.append("=" * 45)
    lineas.append("")
    lineas.append("1. Identificación de la sesión")
    lineas.append(f"Jugador anónimo: {jugador}")
    lineas.append(f"Actividad: {actividad}")
    lineas.append(f"Objetivo trabajado: sílaba inicial {objetivo}")
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
    if intentos == 0:
        lineas.append("No se registraron intentos durante la actividad.")
    elif errores == 0:
        lineas.append(
            "El desempeño dentro del juego muestra respuestas correctas en todos los intentos registrados."
        )
    else:
        lineas.append(
            "El desempeño dentro del juego muestra una combinación de respuestas correctas y errores."
        )
        lineas.append(
            "Los errores registrados pueden servir como información para revisión fonoaudiológica posterior."
        )
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
    if porcentaje >= 80:
        lineas.append(
            "Se podría considerar aumentar gradualmente la dificultad, agregando más distractores o nuevas sílabas."
        )
    elif porcentaje >= 50:
        lineas.append(
            "Se podría repetir la actividad y revisar especialmente las palabras que generaron error."
        )
    else:
        lineas.append(
            "Se podría simplificar la actividad, reducir la cantidad de distractores y reforzar el objetivo con apoyo visual o auditivo."
        )
    lineas.append("")

    lineas.append("6. Advertencia")
    lineas.append(
        "Este reporte es descriptivo y se basa únicamente en datos obtenidos dentro del videojuego."
    )
    lineas.append(
        "No constituye diagnóstico fonoaudiológico ni reemplaza la interpretación de una persona formada en el área."
    )

    return "\n".join(lineas)


def main():
    ruta_entrada = Path("Reports/sesion_demo.json")
    ruta_salida = Path("Reports/reporte_generado.txt")

    if not ruta_entrada.exists():
        print(f"No se encontró el archivo: {ruta_entrada}")
        return

    datos = cargar_json(ruta_entrada)
    reporte = generar_reporte(datos)

    ruta_salida.write_text(reporte, encoding="utf-8")

    print("Reporte generado correctamente.")
    print(f"Archivo: {ruta_salida}")


if __name__ == "__main__":
    main()
