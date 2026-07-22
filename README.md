# Sonic FonoKids

**Sonic FonoKids** es un mod educativo experimental para **Sonic Robo Blast 2 (SRB2)** que transforma actividades de conciencia fonológica y vocabulario en interacciones simples dentro del juego.

El proyecto combina programación y Fonoaudiología para construir una experiencia infantil clara, positiva y fácil de probar. Actualmente permite presentar pictogramas, escoger entre dos alternativas, registrar respuestas y generar reportes descriptivos de la sesión.

> [!IMPORTANT]
> Sonic FonoKids no diagnostica, no reemplaza una evaluación fonoaudiológica y no entrega conclusiones clínicas. Los resultados describen únicamente lo ocurrido dentro del videojuego y deben ser interpretados por una persona formada en el área.

## Estado actual

Versión del mod: **v0.0.3 experimental**  
Última actualización del README: **22 de julio de 2026**

| Área | Estado | Avance disponible |
|---|---:|---|
| Carga del mod | ✅ Probado | PK3 cargable en SRB2 mediante Flatpak |
| Actividades fonológicas | ✅ Funcional | Sílabas iniciales `MA`, `PA` y `BA` |
| Elección entre pares | ✅ Funcional | Dos pictogramas simultáneos con alternancia de lado correcto |
| Vocabulario | ✅ Funcional | Categorías animales, comidas y transportes |
| HUD y feedback | ✅ Funcional | Objetivo, alternativas, aciertos, errores e intentos |
| Pictogramas | ✅ Integrados | 18 palabras con sprites propios |
| Reportes | ✅ Funcional | Reporte en consola, detalle por par y salida tipo JSON |
| Herramienta externa | ✅ Funcional | Generador de reporte `.txt` en Python |
| Mapa propio | 🧪 Bosquejo jugable | `MAP01.wad` con cuatro salas y tres pasillos, sin enemigos ni precipicios |
| Integración automática al mapa | ⏳ Pendiente | Las actividades todavía se inician mediante comandos de consola |

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

Para probar el bosquejo jugable de `MAP01` antes de que llegue a `main`:

```bash
git fetch origin
git switch --track origin/feature/bosquejo-map01
```

Si la rama ya existe localmente:

```bash
git switch feature/bosquejo-map01
git pull --ff-only origin feature/bosquejo-map01
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

## Prueba rápida recomendada

Ya dentro de `MAP01`, limpia cualquier objeto anterior e inicia una actividad:

```text
fonosalalimpia
fonoma2
```

Después puedes probar vocabulario y revisar los datos:

```text
fonosalalimpia
fonovocab2
fonoparesdetalle
fonoreporte
fonojson
```

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

El feedback usa mensajes breves y positivos. No aplica castigos fuertes ni presenta conclusiones clínicas; indica si la palabra coincide con la sílaba o categoría trabajada y prepara el siguiente par después de una pausa corta.

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

## Flujo de datos

```text
Actividad en SRB2
      ↓
Registro de intentos, aciertos, errores y ayudas
      ↓
fonoreporte / fonoparesdetalle
      ↓
fonojson
      ↓
Tools/generar_reporte.py
      ↓
Revisión por una persona del área fonoaudiológica
```

## Ramas de trabajo

| Rama | Uso actual |
|---|---|
| `main` | Base estable del proyecto |
| `feature/mapa-fonokids` | Integración inicial de mapas al PK3 y documentación de diseño |
| `feature/bosquejo-map01` | Bosquejo jugable actual de cuatro salas |

No se recomienda hacer cambios experimentales directamente en `main`. El mapa debe seguir probándose en su rama antes de integrarlo a la base estable.

## Problemas resueltos durante el desarrollo

- comandos duplicados por respaldos `.lua` dentro de `Lua/`;
- objetos invisibles por offsets incorrectos en los PNG;
- asignación de sprites y estados por palabra;
- separación lateral y altura de los pares de pictogramas;
- limpieza de objetos entre actividades;
- pausa antes de mostrar el siguiente par;
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
- preparar una versión de demostración académica.

## Privacidad y uso responsable

- Utilizar identificadores anónimos como `Nino_001`.
- No guardar nombres reales ni datos personales sensibles de niños.
- No interpretar el porcentaje de logro como diagnóstico.
- Revisar los resultados con una persona formada en Fonoaudiología.
- Mantener las actividades como apoyo educativo y no como sustituto de atención profesional.

---

Proyecto estudiantil en desarrollo activo. El objetivo actual es convertir el bosquejo técnico en una demostración educativa clara, segura y presentable.
