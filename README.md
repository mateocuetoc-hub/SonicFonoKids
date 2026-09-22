# Sonic FonoKids

**Sonic FonoKids** es un mod educativo experimental para **Sonic Robo Blast 2 (SRB2)** que transforma actividades de conciencia fonológica y vocabulario en interacciones simples dentro del juego.

El proyecto combina programación y Fonoaudiología para construir una experiencia infantil clara, positiva y fácil de probar. Actualmente permite presentar pictogramas, escoger entre dos alternativas, registrar por separado la selección visual y la producción oral observada, y generar reportes descriptivos de la sesión.

> [!IMPORTANT]
> Sonic FonoKids no diagnostica, no reemplaza una evaluación fonoaudiológica y no entrega conclusiones clínicas. Los resultados describen únicamente lo ocurrido dentro del videojuego y deben ser interpretados por una persona formada en el área.

## Estado actual

Versión del mod: **v0.0.10 experimental**<br>
Última actualización del README: **22 de septiembre de 2026**

| Área | Estado | Avance disponible |
|---|---:|---|
| Carga del mod | ✅ Probado | PK3 cargable en SRB2 mediante Flatpak |
| Actividades fonológicas | ✅ Funcional | Sílabas iniciales `MA`, `PA` y `BA` |
| Elección entre pares | ✅ Funcional | Dos pictogramas simultáneos con alternancia de lado correcto |
| Vocabulario | ✅ Funcional | Categorías animales, comidas y transportes |
| HUD y feedback | ✅ Funcional | Objetivo, alternativas, progreso y guía de evaluación oral `1–5` |
| Pictogramas | ✅ Integrados | 18 palabras con sprites propios que aparecen automáticamente al entrar a cada etapa |
| Reportes | ✅ Funcional | Reporte en consola, detalle por par y salida tipo JSON |
| Evaluación descriptiva oral | ✅ Flujo guiado | Pausa tras cada elección y registro manual con teclado o comandos `1–5` |
| Herramienta externa | ✅ Funcional | Generador de reporte `.txt` en Python |
| Mapa propio | 🧪 Bosquejo jugable | Empaquetado como `MAPA0`, con seis zonas y cinco pasillos, sin enemigos ni precipicios |
| Aventura guiada | ✅ Funcional | Encadena las seis actividades, conserva sus resultados y reinicia el circuito después del premio |
| Progresión por checkpoints | ✅ Implementada | Cinco Star Posts visibles marcan los pasillos, guardan el respawn y desbloquean la zona siguiente |
| Juego libre | ✅ Funcional | Premio de cinco minutos que continúa entre los actos de Greenflower Zone con temporizador HUD |
| Demostración académica | ✅ Preparada | Recorrido completo: actividades, observación oral, juego libre y resumen final |
| Integración automática al mapa | 🧪 Parcial | `fonoaventura` automatiza el recorrido; el inicio todavía se realiza desde consola |

## Qué demuestra la versión v0.0.10

El modo recomendado inicia una aventura de seis etapas: sílabas iniciales `MA`, `PA` y `BA`, animales, comidas y transportes. Los objetos educativos aparecen automáticamente al iniciar cada etapa, anclados en una posición fija y centrada de su sala. En cada ejercicio se presentan dos pictogramas, se registra cuál fue tocado y el juego se detiene para que una persona adulta clasifique la producción oral con las teclas `1` a `5`.

Al completar una actividad —sin exigir respuestas perfectas— se habilita el Star Post que conduce a la siguiente sección. Los intentos de cruzarlo antes de tiempo devuelven a Sonic a una posición segura. Al tocarlo, funciona además como punto de reaparición al estilo de los actos de Sonic. Un muro sólido adicional bloquea físicamente la línea de meta y desaparece únicamente después de completar transportes. Alcanzar la meta inicia un periodo configurable de juego libre en Greenflower Zone. Si Sonic termina Act 1 antes de que venza el reloj, avanza normalmente a Act 2 y conserva el tiempo restante. Al agotarse el temporizador, vuelve a `MAPA0`, muestra el resumen anterior y comienza automáticamente un nuevo circuito desde la actividad `MA`.

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

`Maps/MAP01.wad` contiene el archivo fuente del primer bosquejo original y jugable. Al compilar, su marcador interno se cambia automáticamente a `MAPA0` para que no sustituya el `MAP01` original de SRB2, Greenflower Zone Act 1.

El mapa educativo incluye:

- una zona inicial para `MA`;
- dos zonas fonológicas para `PA` y `BA`;
- tres zonas de vocabulario para animales, comidas y transportes;
- cinco pasillos con Star Posts visibles que funcionan como checkpoints y puntos de reaparición;
- una meta cerrada por un muro sólido hasta completar las seis etapas;
- inicio de jugador y nodos BSP válidos;
- piso plano, espacios amplios, sin enemigos y sin precipicios.

El diseño está pensado como base editable. La geometría ya fue probada dentro de SRB2 y la lógica asigna automáticamente cada actividad a su zona. La decoración y la señalética física siguen pendientes.

## Tecnologías

- **Sonic Robo Blast 2 2.2.x** como motor del juego;
- **Lua** para la lógica, comandos, actividades, HUD y registro de datos;
- **SOC** para definiciones compatibles con SRB2;
- **PNG / sprites `FONI*`** para los pictogramas;
- **WAD** para el mapa educativo `MAPA0` y el nivel original `MAP01` como premio;
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
2. genera una copia temporal del mapa cuyo marcador cambia de `MAP01` a `MAPA0`;
3. empaqueta `Lua/`, `SOC/`, `Sprites/`, `Sounds/`, `Music/` y `Maps/MAPA0.wad`;
4. genera `~/SRB2Mods/SonicFonoKids.pk3`;
5. copia el PK3 a la carpeta de addons de SRB2 Flatpak.

Para confirmar que el mapa quedó dentro del paquete:

```bash
unzip -l "$HOME/.var/app/org.srb2.SRB2/.srb2/addons/SonicFonoKids.pk3" | grep -i MAPA0
```

## Abrir el juego en OpenGL y cargar el mapa educativo

```bash
./run-opengl.sh
```

El lanzador solicita explícitamente el renderizador OpenGL, necesario para usar
modelos poligonales cuando el paquete de modelos está instalado. Si OpenGL no
inicia, ejecuta `flatpak update` y comprueba los controladores disponibles con
`flatpak --gl-drivers`.

Cuando el mod se inicia con `-file`, no se debe cargar el mismo PK3 nuevamente desde el menú **Addons**.

Abre la consola de SRB2 con la tecla situada debajo de `Esc` y ejecuta:

```text
devmode 1
map MAPA0
```

## Demo rápida recomendada

La demostración completa dura aproximadamente entre ocho y doce minutos, incluyendo cinco minutos de juego libre. Una persona controla a Sonic y toca los pictogramas; una persona adulta observa la producción oral y la registra con el teclado.

### 1. Iniciar la aventura con una sesión anónima

```text
map MAPA0
fonoaventura Demo_001 5a0m
```

`Demo_001` es un identificador ficticio y `5a0m` representa una edad de cinco años y cero meses. No se deben utilizar nombres reales.

### 2. Completar las seis etapas

Las actividades se activan automáticamente al entrar a cada zona: `MA`, `PA`, `BA`, animales, comidas y transportes. Los pictogramas ya aparecen en una posición fija y centrada dentro de la sala. Después de tocar una opción, el juego retira ambos pictogramas y espera el registro de la producción oral.

Con la consola cerrada, la evaluadora presiona una tecla del `1` al `5`. También puede utilizar `fonoproduccion <1-5>` desde la consola. El siguiente par sólo aparece después de completar este paso.

Al finalizar todos los pares de una etapa, el HUD indica que el checkpoint está disponible. Sonic debe avanzar y tocar el Star Post del pasillo para guardar su punto de reaparición y desbloquear la zona siguiente. Si intenta cruzarlo antes de completar la actividad, vuelve a la última posición segura.

### 3. Jugar el premio

Al registrar la última producción de transportes se desbloquea la meta educativa. Cuando Sonic llega a ella, el juego carga Greenflower Zone Act 1 y comienza el temporizador de cinco minutos. Terminar el acto no interrumpe el premio: Sonic avanza a Act 2 y el reloj continúa desde el tiempo restante.

El premio se obtiene por **completar el recorrido**, no por acertar todas las respuestas. Solo al agotarse el tiempo se regresa automáticamente a `MAPA0`; allí se reconstruyen los checkpoints, el muro de la meta y las actividades para comenzar otra vez desde la etapa 1. El tiempo puede ajustarse antes de iniciar:

```text
fonotiempo 3
```

La persona adulta puede terminar antes con:

```text
fonofinjuego
```

Al agotarse el tiempo, Sonic vuelve a `MAPA0`, se muestra el resumen del recorrido anterior y comienza automáticamente una nueva ronda educativa. El comando `fonofinjuego` permite volver antes y cerrar la sesión sin iniciar otra ronda.

> [!TIP]
> Para comprobar sólo el cambio de mapa y el HUD sin realizar todas las actividades, usa `fonojuegotest 30`. Este comando de desarrollo inicia 30 segundos de juego libre.

### Recuperación rápida durante una demostración

Si quedan objetos activos o se necesita repetir la prueba:

```text
fonosalalimpia
fonoreset
fonoaventura Demo_001 5a0m
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
| `fonoaventura <código> <edad>` | Inicia el recorrido completo recomendado |
| `fonoaventuraayuda` | Explica el flujo de aventura y juego libre |
| `fonoetapa` | Muestra la etapa, actividad y checkpoints superados |
| `fonotiempo <minutos>` | Configura el premio entre 1 y 10 minutos |
| `fonofinjuego` | Permite que la persona adulta termine el juego libre antes |
| `fonoresumen` | Muestra el resumen conjunto de la aventura |
| `fonojuegotest <segundos>` | Prueba técnica rápida del cambio de mapa y temporizador |

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
Segunda actividad y conservación de ambos resultados
              ↓
Juego libre temporizado a través de los actos de Greenflower Zone
              ↓
Resumen conjunto de la aventura y reinicio de las actividades
              ↓
Salida estructurada individual con fonojson
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
- conflicto entre el mapa educativo y Greenflower por compartir `MAP01`;
- conservación de resultados al encadenar las seis actividades;
- asignación automática de una actividad a cada sección del mapa;
- checkpoints bloqueados hasta completar la etapa correspondiente;
- meta educativa bloqueada hasta finalizar transportes;
- transición automática al juego libre y regreso seguro a `MAPA0`;
- temporizador HUD con aviso de 30 segundos y cierre anticipado por un adulto.

## Próximos pasos

- decorar `MAPA0` y diferenciar visualmente cada sala;
- agregar señalética física para cada checkpoint dentro del escenario;
- iniciar la aventura desde un objeto o zona del mapa, sin depender de la consola;
- validar en SRB2 las posiciones y límites de las seis zonas;
- validar con la profesora la duración y el diseño del periodo de juego libre;
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
