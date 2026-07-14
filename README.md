# Sonic FonoKids

**Sonic FonoKids** es un mod educativo experimental para **Sonic Robo Blast 2**, orientado a actividades lúdicas de apoyo fonoaudiológico infantil.

El proyecto busca unir **videojuegos, programación, educación, datos e ideas de Fonoaudiología** mediante actividades simples dentro de SRB2, principalmente enfocadas en conciencia fonológica y reconocimiento de sílabas iniciales.

> Este proyecto **no diagnostica**, **no reemplaza a una fonoaudióloga** y **no entrega conclusiones clínicas**.  
> Los reportes solo organizan datos del juego para que una persona del área fonoaudiológica pueda revisarlos e interpretarlos.

---

## Objetivo del proyecto

Crear una experiencia educativa en Sonic Robo Blast 2 donde niños puedan practicar habilidades relacionadas con:

- conciencia fonológica;
- identificación de sílabas iniciales;
- discriminación de palabras;
- vocabulario;
- seguimiento de instrucciones simples;
- atención a estímulos visuales y auditivos.

El juego registra datos básicos de desempeño, como:

- intentos totales;
- respuestas correctas;
- errores;
- tipo de error;
- ayudas utilizadas;
- porcentaje de logro;
- actividad completada o no.

Luego esos datos pueden usarse para generar reportes descriptivos no clínicos.

---

## Estado actual del proyecto

Actualmente Sonic FonoKids incluye:

- addon cargable en Sonic Robo Blast 2;
- script `build.sh` para generar automáticamente el archivo `.pk3`;
- banco de palabras;
- objetos educativos tocables dentro del juego;
- nivel automático;
- nivel secuencial;
- niveles por sílaba: `MA`, `PA` y `BA`;
- HUD visual dentro del juego;
- feedback infantil;
- reporte descriptivo dentro de SRB2;
- salida tipo JSON para IA;
- generador externo de reportes en Python;
- plantilla de prompt para generar reportes con IA.

---

## Tecnologías usadas

- Sonic Robo Blast 2
- Lua
- PK3
- Linux Mint
- Git / GitHub
- Python 3

---

## Estructura del proyecto

```text
SonicFonoKids/
├── Lua/
│   └── main.lua
├── SOC/
├── Sprites/
├── Sounds/
├── Reports/
│   ├── prompt_reporte_ia.md
│   └── sesion_demo.json
├── Tools/
│   └── generar_reporte.py
├── build.sh
├── README.md
└── .gitignore
```

---

## Instalación en Linux Mint

### 1. Instalar dependencias básicas

```bash
sudo apt update
sudo apt install git gh zip unzip flatpak python3
```

### 2. Instalar Sonic Robo Blast 2

```bash
flatpak install flathub org.srb2.SRB2
```

### 3. Clonar el proyecto

```bash
mkdir -p ~/SRB2Mods
cd ~/SRB2Mods
git clone https://github.com/mateocuetoc-hub/SonicFonoKids.git
cd SonicFonoKids
```

### 4. Dar permisos al script de build

```bash
chmod +x build.sh
```

---

## Generar el mod PK3

Desde la carpeta del proyecto:

```bash
cd ~/SRB2Mods/SonicFonoKids
./build.sh
```

El build comprueba que `Lua/` contenga únicamente `main.lua`. Si encuentra
otro archivo `.lua`, se detiene para evitar que SRB2 cargue comandos duplicados.

El script genera el archivo:

```text
~/SRB2Mods/SonicFonoKids.pk3
```

y lo copia automáticamente a la carpeta de addons de SRB2 Flatpak:

```text
~/.var/app/org.srb2.SRB2/.srb2/addons/
```

---

## Abrir Sonic Robo Blast 2

```bash
flatpak run org.srb2.SRB2 -file "$HOME/.var/app/org.srb2.SRB2/.srb2/addons/SonicFonoKids.pk3"
```

Cuando se inicia con `-file`, no se debe cargar el mismo PK3 nuevamente desde
el menú **Addons**, porque SRB2 intentaría agregar el mod dos veces.

---

## Flujo rápido para probar el mod

Desde la terminal:

```bash
cd ~/SRB2Mods/SonicFonoKids
git pull
./build.sh
flatpak run org.srb2.SRB2 -file "$HOME/.var/app/org.srb2.SRB2/.srb2/addons/SonicFonoKids.pk3"
```

Dentro del juego:

```text
Addons
↓
addons/
↓
SonicFonoKids.pk3
↓
Enter
↓
Single Player
↓
Entrar a un nivel
```

Abrir la consola del juego con la tecla ubicada debajo de `Esc`, a la izquierda del número `1`.

Luego ejecutar:

```text
fonoma
```

Tocar los objetos que aparecen.

Al finalizar, el juego mostrará automáticamente un reporte descriptivo.

---

## Comandos principales dentro del juego

### Comandos generales

```text
fonokids
```

Muestra instrucciones generales e inicia una actividad guiada.

```text
fonolista
```

Muestra el banco de palabras disponible.

```text
fonoreset
```

Reinicia la sesión actual.

```text
fonoprogreso
```

Muestra el progreso actual de la actividad.

```text
fonoreporte
```

Muestra un reporte descriptivo no clínico dentro del juego.

```text
fonoia
```

Muestra datos descriptivos ordenados para uso con IA.

```text
fonojson
```

Muestra los datos de la sesión en formato tipo JSON.

```text
fonocopia
```

Indica cómo copiar los datos del comando `fonojson`.

---

## Actividades por sílaba

```text
fonoma
```

Inicia una actividad con la sílaba inicial `MA`.

```text
fonopa
```

Inicia una actividad con la sílaba inicial `PA`.

```text
fonoba
```

Inicia una actividad con la sílaba inicial `BA`.

```text
fononiveles
```

Muestra los niveles disponibles.

---

## Niveles automáticos y secuenciales

```text
fononivel1auto
```

Crea una actividad automática con objetos educativos.  
Al tocar todos los objetos, el reporte aparece automáticamente.

```text
fononivel1seq
```

Crea una actividad secuencial donde aparece un objeto a la vez.  
Esto ayuda a que el jugador se concentre en una palabra por turno.

---

## Objetos educativos

```text
fonoobj mano
```

Crea un objeto educativo asociado a la palabra `mano`.

```text
fonoobj pato
```

Crea un objeto educativo asociado a la palabra `pato`.

```text
fonoobjetosdemo
```

Crea una demo con objetos:

```text
mano
mapa
pato
bala
```

---

## Quiz

```text
fonoquiz
```

Inicia un quiz de sílaba inicial.

```text
fonoquizsi
```

Responde “sí” en el quiz.

```text
fonoquizno
```

Responde “no” en el quiz.

```text
fonoquizpregunta
```

Muestra nuevamente la pregunta actual.

---

## Ejemplo de actividad: sílaba MA

Actividad:

```text
Identificar palabras que comienzan con MA.
```

Palabras objetivo:

```text
mano
mapa
```

Distractores:

```text
pato
bala
```

Resultado esperado:

```text
mano → correcto
mapa → correcto
pato → error / distractor fonológico
bala → error / distractor fonológico
```

Reporte esperado:

```text
Intentos: 4
Correctos: 2
Errores: 2
Logro: 50%
Errores observados:
- pato / distractor_fonologico
- bala / distractor_fonologico
```

---

## HUD visual

El mod muestra un HUD propio con información como:

```text
SONIC FONOKIDS
OK: 0  ERR: 0
INT: 0/4
OBJETO: MANO
OBJETIVO: MA
```

El HUD permite visualizar:

- respuestas correctas;
- errores;
- intentos;
- palabra actual;
- objetivo de la actividad;
- feedback infantil.

---

## Feedback infantil

El mod evita mensajes técnicos y usa mensajes más amigables, por ejemplo:

```text
¡Muy bien! MANO empieza con MA.
¡Sigue así!
```

o:

```text
Buen intento. PATO no empieza con MA.
Busquemos una palabra que suene con MA.
```

La idea es mantener una experiencia positiva, sin castigos fuertes y con retroalimentación clara.

---

## Reportes dentro del juego

### Reporte descriptivo

Comando:

```text
fonoreporte
```

Muestra un reporte como:

```text
REPORTE DESCRIPTIVO NO CLÍNICO
Sesión: Nino_001
Actividad: sílaba inicial MA
Intentos: 4
Correctos: 2
Errores: 2
Logro: 50%
Resultado descriptivo: desempeño intermedio dentro de la actividad
```

### Datos para IA

Comando:

```text
fonoia
```

Muestra datos ordenados para generar un reporte externo.

### JSON para IA

Comando:

```text
fonojson
```

Muestra un bloque estructurado como:

```json
{
  "proyecto": "Sonic FonoKids",
  "tipo_reporte": "descriptivo_no_clinico",
  "jugador_anonimo": "Nino_001",
  "actividad": "conciencia_fonologica_silaba_inicial_MA",
  "objetivo": "MA",
  "intentos_totales": 4,
  "respuestas_correctas": 2,
  "errores": 2,
  "ayudas_usadas": 0,
  "porcentaje_logro": 50,
  "completado": true,
  "errores_detalle": [
    { "palabra": "pato", "tipo": "distractor_fonologico" },
    { "palabra": "bala", "tipo": "distractor_fonologico" }
  ]
}
```

---

## Plantilla para IA

El proyecto incluye una plantilla en:

```text
Reports/prompt_reporte_ia.md
```

La idea es usar el comando:

```text
fonojson
```

copiar los datos generados y pegarlos junto con la plantilla para obtener un reporte descriptivo.

Reglas del reporte:

- no diagnosticar;
- no usar lenguaje clínico definitivo;
- no decir que el niño tiene un trastorno;
- no reemplazar la interpretación de una fonoaudióloga;
- usar lenguaje claro, descriptivo y profesional.

---

## Generador externo de reportes

El proyecto incluye una herramienta en Python:

```text
Tools/generar_reporte.py
```

Sirve para transformar un archivo `.json` de sesión en un reporte `.txt`.

### Uso básico

```bash
python3 Tools/generar_reporte.py Reports/sesion_demo.json
```

Esto genera:

```text
Reports/reporte_sesion_demo.txt
```

### Uso con salida personalizada

```bash
python3 Tools/generar_reporte.py Reports/sesion_demo.json -o Reports/reporte_prueba.txt
```

El reporte generado es descriptivo y no clínico.

---

## Flujo juego → datos → reporte

El flujo ideal del proyecto es:

```text
1. El niño juega una actividad en SRB2.
2. El mod registra intentos, aciertos, errores y porcentaje de logro.
3. Se usa fonojson para obtener datos estructurados.
4. Los datos se copian a un archivo JSON.
5. Python genera un reporte descriptivo.
6. Una persona del área fonoaudiológica interpreta el resultado.
```

Ejemplo:

```bash
python3 Tools/generar_reporte.py Reports/sesion_demo.json
cat Reports/reporte_sesion_demo.txt
```

---

## Advertencia ética

Sonic FonoKids no entrega diagnósticos.

Los datos obtenidos dentro del juego deben ser interpretados por una persona formada en el área fonoaudiológica.

No se recomienda guardar nombres reales de niños ni datos personales sensibles.

Para pruebas se deben usar identificadores anónimos como:

```text
Nino_001
Nino_002
```

---

## Flujo de trabajo con Git

Antes de trabajar:

```bash
git pull
```

Después de modificar y probar:

```bash
git status
git add .
git commit -m "Descripcion del cambio"
git push
```

---

## Roadmap

Próximas mejoras posibles:

- reemplazar los sprites provisionales por ilustraciones infantiles;
- agregar más sílabas;
- agregar actividades de rimas;
- mejorar la interfaz visual;
- generar reportes más completos;
- exportar datos de sesión de forma más automática;
- crear mapas educativos propios;
- agregar sonidos o instrucciones grabadas;
- crear una versión más presentable para demostración académica.

---

## Estado del proyecto

Proyecto en desarrollo experimental.

Versión actual aproximada:

```text
Sonic FonoKids v0.0.3 experimental
```
