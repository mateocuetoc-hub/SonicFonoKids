# Sonic FonoKids

**Sonic FonoKids** es un mod educativo experimental para **Sonic Robo Blast 2 (SRB2)** que transforma actividades de conciencia fonológica y vocabulario en interacciones simples dentro del juego.

El proyecto combina programación y Fonoaudiología para construir una experiencia infantil clara, positiva y fácil de probar. Actualmente permite presentar pictogramas, escoger entre dos alternativas, registrar por separado la selección visual y la producción oral observada, y generar reportes descriptivos de la sesión.

> [!IMPORTANT]
> Sonic FonoKids no diagnostica, no reemplaza una evaluación fonoaudiológica y no entrega conclusiones clínicas. Los resultados describen únicamente lo ocurrido dentro del videojuego y deben ser interpretados por una persona formada en el área.

## Estado actual

Versión del mod: **v0.0.4 experimental**<br>
Última actualización del README: **16 de agosto de 2026**

| Área | Estado | Avance disponible |
|---|---:|---|
| Carga del mod | ✅ Probado | PK3 cargable en SRB2 mediante Flatpak |
| Actividades fonológicas | ✅ Funcional | Sílabas iniciales `MA`, `PA` y `BA` |
| Elección entre pares | ✅ Funcional | Dos pictogramas simultáneos con alternancia de lado correcto |
| Vocabulario | ✅ Funcional | Categorías animales, comidas y transportes |
| HUD y feedback | ✅ Funcional | Objetivo, alternativas, progreso y guía de evaluación oral `1–5` |
| Pictogramas | ✅ Integrados | 18 palabras con sprites propios |
| Reportes | ✅ Funcional | Reporte en consola, detalle por par y salida tipo JSON |
| Evaluación descriptiva oral | ✅ Flujo guiado | Pausa tras cada elección y registro manual con teclado o comandos `1–5` |
| Herramienta externa | ✅ Funcional | Generador de reporte `.txt` en Python |
| Mapa propio | 🧪 Bosquejo jugable | `MAP01.wad` con cuatro salas y tres pasillos, sin enemigos ni precipicios |
| Demostración académica | ✅ Preparada | Recorrido breve con actividad, observación oral y reporte automático |
| Integración automática al mapa | ⏳ Pendiente | Las actividades todavía se inician mediante comandos de consola |

## Qué demuestra la versión v0.0.4

El modo recomendado presenta un par de pictogramas, registra cuál fue tocado y se detiene antes de avanzar. Durante esa pausa, una persona adulta observa la producción oral del participante y la clasifica con las teclas `1` a `5`. Sólo después de ese registro aparece el siguiente par.

Esto permite conservar dos datos diferentes:

- **selección visual:** qué pictograma escogió el participante y si correspondía al objetivo;
- **producción oral observada:** cómo produjo la palabra objetivo según el registro manual de la evaluadora.

El mod no escucha ni analiza la voz automáticamente. Las categorías son descriptivas, dependen de la observación humana y no constituyen un diagnóstico.

## Objetivos educativos

El proyecto está pensado para practicar de forma lúdica:

- conciencia fonológica;
- identificación de sílabas iniciales;
- discriminación entre palabra objetivo y distractor;
- reconocimiento de vocabulario por categorías;
- seguimiento de instrucciones simples;
- atención a estímulos visuales;
- elección entre dos alternativas.

Durante cada actividad se registran intentos, respuestas correctas, errores, ayudas, porcentaje de logro y detalle de las selecciones.

## Funcionalidades implementadas

### Actividades de sílaba inicial

- `fonoma2`: escoger la palabra que comienza con `MA`.
- `fonopa2`: escoger la palabra que comienza con `PA`.
- `fonoba2`: escoger la palabra que comienza con `BA`.
- `fonoma`, `fonopa` y `fonoba`: versiones secuenciales de las actividades.

En el modo de pares aparecen dos opciones al mismo tiempo. La respuesta correcta cambia de lado entre ejercicios para evitar que el jugador aprenda a elegir siempre la misma posición.

### Actividades de vocabulario

- `fonovocab2`: escoger animales.
- `fonocomida2`: escoger comidas.
- `fonotransporte2`: escoger medios de transporte.
- `fonovocab`, `fonocomida` y `fonotransporte`: versiones secuenciales.

### Pictogramas integrados

El banco visual actual incluye:

```text
mano, mapa, pato, bala, gato, mesa, auto, perro, sopa,
pan, queso, manzana, bus, tren, barco, banco, pala y papa
```

Los objetos aparecen frente al jugador, son tocables y entregan feedback inmediato. El comando `fonospritecheck` permite comprobar los sprites activos durante el desarrollo.

### Sala y mapa educativo

`Maps/MAP01.wad` contiene un primer bosquejo original y jugable con:

- una sala de inicio;
- una sala para sílabas iniciales;
- una sala para vocabulario;
- una sala final para reportes;
- tres pasillos de conexión;
- inicio de jugador y nodos BSP válidos;
- piso plano, espacios amplios, sin enemigos y sin precipicios.

El diseño está pensado como base editable. La geometría ya fue probada dentro de SRB2, pero la decoración, señalética y activación automática de actividades siguen pendientes.

## Tecnologías

- **Sonic Robo Blast 2 2.2.x** como motor del juego;
- **Lua** para la lógica, comandos, actividades, HUD y registro de datos;
- **SOC** para definiciones compatibles con SRB2;
- **PNG / sprites `FONI*`** para los pictogramas;
- **WAD** para `MAP01`;
- **PK3** como formato distribuible del mod;
- **Python 3** para generar reportes externos;
- **Bash** para automatizar la compilación;
- **Git y GitHub** para control de versiones;
- **Linux Mint**, **Flatpak**, **Wine** y **Zone Builder** en el entorno de desarrollo del mapa.

## Estructura del repositorio

```text
SonicFonoKids/
├── Docs/
│   └── mapa-fonokids.md
├── Lua/
│   └── main.lua
├── Maps/
│   └── MAP01.wad
├── Reports/
│   ├── prompt_reporte_ia.md
│   └── sesion_demo.json
├── SOC/
├── Sounds/
├── Sprites/
├── Tools/
│   └── generar_reporte.py
├── build.sh
├── README.md
└── .gitignore
```

Los respaldos locales deben guardarse fuera de `Lua/`. El script de compilación exige que esa carpeta contenga únicamente `Lua/main.lua`, evitando que SRB2 cargue comandos duplicados.

## Instalación en Linux Mint

### 1. Instalar dependencias

```bash
sudo apt update
sudo apt install git zip unzip flatpak python3
```

### 2. Instalar SRB2 con Flatpak

```bash
flatpak install flathub org.srb2.SRB2
```

### 3. Clonar el repositorio

```bash
mkdir -p ~/SRB2Mods
cd ~/SRB2Mods
git clone https://github.com/mateocuetoc-hub/SonicFonoKids.git
cd SonicFonoKids
```

Si el repositorio ya estaba clonado, actualiza la rama estable antes de compilar:

```bash
cd ~/SRB2Mods/SonicFonoKids
git pull --ff-only origin main
```

## Compilar el PK3

```bash
cd ~/SRB2Mods/SonicFonoKids
chmod +x build.sh
./build.sh
```

El script:

1. comprueba que `Lua/` sólo contenga `main.lua`;
2. empaqueta `Lua/`, `SOC/`, `Sprites/`, `Sounds/` y los mapas WAD disponibles;
3. genera `~/SRB2Mods/SonicFonoKids.pk3`;
4. copia el PK3 a la carpeta de addons de SRB2 Flatpak.

Para confirmar que el mapa quedó dentro del paquete:

```bash
unzip -l "$HOME/.var/app/org.srb2.SRB2/.srb2/addons/SonicFonoKids.pk3" | grep -i MAP01
```

## Abrir el juego y cargar MAP01

```bash
flatpak run org.srb2.SRB2 \
  -file "$HOME/.var/app/org.srb2.SRB2/.srb2/addons/SonicFonoKids.pk3"
```

Cuando el mod se inicia con `-file`, no se debe cargar el mismo PK3 nuevamente desde el menú **Addons**.

Abre la consola de SRB2 con la tecla situada debajo de `Esc` y ejecuta:

```text
devmode 1
map MAP01
```

## Demo rápida recomendada

La demostración principal dura aproximadamente entre tres y cinco minutos. Una persona controla a Sonic y toca los pictogramas; una persona adulta observa la producción oral y la registra con el teclado.

### 1. Preparar una sesión anónima

```text
fonosalalimpia
fonosesion Demo_001 5a0m
fonoma2
```

`Demo_001` es un identificador ficticio y `5a0m` representa una edad de cinco años y cero meses. No se deben utilizar nombres reales.

### 2. Realizar la actividad

El primer par es `MANO / PATO` y el segundo es `BALA / MAPA`. Después de tocar una opción, el juego retira los pictogramas y espera el registro de la producción oral.

Con la consola cerrada, la evaluadora presiona una tecla del `1` al `5`. También puede utilizar `fonoproduccion <1-5>` desde la consola. El siguiente par sólo aparece después de completar este paso.

### 3. Revisar los resultados

Al registrar la última producción aparece automáticamente el reporte descriptivo. También están disponibles:

```text
fonoparesdetalle
fonoproducciones
fonoreporte
fonojson
```

Para demostrar vocabulario en una segunda sesión:

```text
fonosesion Demo_002 5a0m
fonovocab2
```

> [!TIP]
> `fonosesion` comienza un registro nuevo y elimina los resultados actuales. Ejecuta `fonojson` y copia su salida antes de iniciar otra sesión si deseas conservar los datos.

### Recuperación rápida durante una demostración

Si quedan objetos activos o se necesita repetir la prueba:

```text
fonosalalimpia
fonoreset
fonoma2
```

### Prueba de control de actividades

Para comprobar rápidamente todos los modos de pares, estas son las respuestas objetivo en orden:

| Actividad | Comando | Palabras objetivo |
|---|---|---|
| Sílaba `MA` | `fonoma2` | `MANO` → `MAPA` |
| Sílaba `PA` | `fonopa2` | `PATO` → `PALA` → `PAPA` |
| Sílaba `BA` | `fonoba2` | `BALA` → `BARCO` → `BANCO` |
| Animales | `fonovocab2` | `GATO` → `PERRO` → `PATO` |
| Comidas | `fonocomida2` | `PAN` → `QUESO` → `MANZANA` |
| Transportes | `fonotransporte2` | `AUTO` → `BUS` → `TREN` |

## Comandos principales

### Demostración y ayuda

| Comando | Función |
|---|---|
| `fonodemo` | Presenta el proyecto y las actividades disponibles |
| `fonocomandos` | Muestra el resumen de comandos actuales |
| `fonosala` | Explica el flujo de las salas educativas |
| `fonosalademo` | Recorre la demostración guiada de salas |
| `fonosalalimpia` | Elimina objetos educativos activos y reinicia la sala de prueba |

### Actividades recomendadas

| Comando | Modo | Objetivo |
|---|---|---|
| `fonoma2` | Pares | Sílaba inicial `MA` |
| `fonopa2` | Pares | Sílaba inicial `PA` |
| `fonoba2` | Pares | Sílaba inicial `BA` |
| `fonovocab2` | Pares | Categoría animales |
| `fonocomida2` | Pares | Categoría comidas |
| `fonotransporte2` | Pares | Categoría transportes |
| `fonoma` | Secuencial | Sílaba inicial `MA` |
| `fonopa` | Secuencial | Sílaba inicial `PA` |
| `fonoba` | Secuencial | Sílaba inicial `BA` |
| `fonovocab` | Secuencial | Categoría animales |
| `fonocomida` | Secuencial | Categoría comidas |
| `fonotransporte` | Secuencial | Categoría transportes |

### Progreso, reportes y desarrollo

| Comando | Función |
|---|---|
| `fonoprogreso` | Muestra el progreso de la actividad |
| `fonoparesdetalle` | Muestra cada par, selección y resultado |
| `fonoreporte` | Genera un reporte descriptivo no clínico en la consola |
| `fonojson` | Muestra los datos de sesión en formato tipo JSON |
| `fonocopia` | Explica cómo copiar la salida de `fonojson` |
| `fonoreset` | Reinicia los datos de la sesión |
| `fonoevaluacion` | Muestra el flujo de evaluación descriptiva oral |
| `fonosesion <código> <edad>` | Reinicia y prepara una sesión con identificador anónimo y edad |
| `fonoproduccion` | Registra manualmente una producción oral con códigos del 1 al 5 |
| `fono1` a `fono5` | Alternativa por consola para registrar rápidamente cada categoría oral |
| `fonoproducciondeshacer` | Deshace el último registro oral en los modos compatibles |
| `fonoproducciones` | Muestra el resumen de producciones observadas |
| `fonosprites` | Lista las palabras con sprite |
| `fonospritecheck` | Comprueba estados y objetos visuales activos |

## HUD y feedback infantil

El HUD muestra información como:

```text
SONIC FONOKIDS
BUSCA: MA
IZQ: MANO | DER: PATO
OK: 0  ERR: 0
INT: 0/2
```

Después de seleccionar un pictograma, cambia a la etapa de producción oral:

```text
PRODUCCION: MANO
1 OK  2 OMISION  3 SUST.
4 DIST.  5 AYUDA
```

El feedback usa mensajes breves y positivos. No aplica castigos fuertes ni presenta conclusiones clínicas; indica si la palabra coincide con la sílaba o categoría trabajada y espera el registro oral antes de preparar el siguiente par.

## Reportes descriptivos

`fonoreporte` resume:

- identificador anónimo de sesión;
- actividad y objetivo;
- intentos, respuestas correctas y errores;
- ayudas utilizadas;
- porcentaje de logro;
- resultado descriptivo;
- errores observados;
- detalle de cada par cuando corresponde.

`fonojson` entrega datos estructurados que pueden copiarse a un archivo dentro de `Reports/`. Para generar un reporte de texto:

```bash
python3 Tools/generar_reporte.py Reports/sesion_demo.json
```

Con una ruta de salida personalizada:

```bash
python3 Tools/generar_reporte.py \
  Reports/sesion_demo.json \
  -o Reports/reporte_prueba.txt
```

La plantilla `Reports/prompt_reporte_ia.md` ayuda a redactar un informe externo conservando el enfoque descriptivo y no diagnóstico.

### Registro descriptivo de producción oral

Los números que aparecen después de escoger un pictograma no son una nota ni una segunda respuesta del participante. Son categorías para que una persona adulta registre manualmente cómo escuchó la palabra objetivo.

| Tecla | Categoría | Uso descriptivo | Ejemplo sencillo |
|---:|---|---|---|
| `1` | Correcta | La palabra objetivo se produce de manera adecuada para el registro de la actividad | Objetivo `MANO` → dice “mano” |
| `2` | Omisión | No produce la palabra o se omite una parte relevante | Objetivo `MANO` → no responde o deja una parte sin producir |
| `3` | Sustitución | Cambia un sonido o reemplaza la producción esperada | Objetivo `MANO` → dice “pano” |
| `4` | Distorsión | La palabra es reconocible, pero algún sonido se percibe impreciso o alterado | Intenta decir `MANO`, con una realización imprecisa |
| `5` | Con ayuda | Produce la palabra después de recibir un modelo, repetición o apoyo | La persona adulta modela “mano” y el participante la repite |

El flujo guiado funciona así:

```text
El participante toca una opción
              ↓
El juego registra la selección visual
              ↓
El HUD muestra la palabra objetivo pendiente
              ↓
La persona adulta escucha la producción oral
              ↓
Presiona 1, 2, 3, 4 o 5
              ↓
Aparece el siguiente par o el reporte final
```

La selección visual y la producción oral se guardan por separado. Por ejemplo, si el participante toca `PATO` cuando la respuesta esperada era `MANO`, el detalle de pares registra la selección incorrecta y el HUD solicita observar la producción de `MANO`.

La evaluadora prepara la sesión con un código anónimo y la edad, inicia una actividad y registra lo que escucha después de cada elección:

```text
fonosesion Nino_002 5a4m
fonoma2

fonoproduccion 1       // correcta
fonoproduccion 2       // omisión
fonoproduccion 3 bato  // sustitución; nota opcional
fonoproduccion 4       // distorsión
fonoproduccion 5       // producción con ayuda
```

Durante una evaluación pendiente también se puede presionar directamente `1`, `2`, `3`, `4` o `5` con la consola cerrada. Si el teclado no registra la pulsación, se puede abrir la consola y ejecutar `fono1`, `fono2`, `fono3`, `fono4` o `fono5`.

`fonoproducciones` muestra el resumen. Los resultados también aparecen en `fonoreporte`, `fonojson` y el reporte `.txt` generado por Python. Este registro depende de la observación humana y no constituye diagnóstico.

## Flujo de datos

```text
Elección entre dos pictogramas
              ↓
Registro de selección visual
              ↓
Observación y registro oral manual (1–5)
              ↓
Reporte descriptivo + detalle por par
              ↓
Salida estructurada con fonojson
              ↓
Reporte externo con Tools/generar_reporte.py
              ↓
Revisión responsable por una persona del área
```

## Desarrollo y versiones

La rama `main` contiene la versión estable utilizada para la demostración. Los cambios de lógica deben probarse antes de publicarse y los respaldos locales deben mantenerse fuera de `Lua/` para evitar que SRB2 cargue archivos duplicados.

## Problemas resueltos durante el desarrollo

- comandos duplicados por respaldos `.lua` dentro de `Lua/`;
- objetos invisibles por offsets incorrectos en los PNG;
- asignación de sprites y estados por palabra;
- separación lateral y altura de los pares de pictogramas;
- limpieza de objetos entre actividades;
- pausa antes de mostrar el siguiente par;
- espera obligatoria del registro oral antes de avanzar;
- registro separado de selección visual y producción oral;
- cierre de sesión sólo después de evaluar la última palabra;
- inclusión de `Maps/*.wad` dentro del PK3;
- cierre de SRB2 por un mapa sin nodos válidos;
- ejecución de Zone Builder en Linux Mint mediante Wine.

## Próximos pasos

- decorar `MAP01` y diferenciar visualmente cada sala;
- agregar señalética e instrucciones dentro del escenario;
- vincular las salas con actividades sin depender tanto de la consola;
- posicionar las actividades de acuerdo con cada zona del mapa;
- agregar sonidos o instrucciones grabadas;
- ampliar el banco de sílabas, palabras y categorías;
- mejorar la exportación automática de sesiones;
- realizar pruebas de usabilidad con supervisión fonoaudiológica;
- grabar y documentar una demostración académica breve.

## Privacidad y uso responsable

- Utilizar identificadores anónimos como `Nino_001`.
- No guardar nombres reales ni datos personales sensibles de niños.
- No interpretar el porcentaje de logro como diagnóstico.
- Revisar los resultados con una persona formada en Fonoaudiología.
- Mantener las actividades como apoyo educativo y no como sustituto de atención profesional.

---

Proyecto estudiantil en desarrollo activo. El objetivo actual es convertir el bosquejo técnico en una demostración educativa clara, segura y presentable.
