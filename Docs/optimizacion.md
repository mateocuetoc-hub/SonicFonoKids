# Optimización del juego — v0.0.13

Rama: `optimizar-juego`, creada desde `main` en el commit `35ec000` (v0.0.12). No se modifican los mapas, PNG, sonidos, música ni posiciones de las salas. Se conserva `Lua/main.lua` como único script del addon y se mantienen los nombres de los comandos.

## Cambios

- Un único inicio de pares para sílabas y categorías. Las seis actividades comparten sus definiciones entre comandos y aventura; mantienen las palabras y el orden izquierda/derecha. La variante histórica de `fonosala2` conserva su último par `SOPA / PATO`.
- Un único registro de selección correcta/incorrecta, validado antes de modificar los contadores, el detalle o la cola oral. Una actividad terminada y una espera entre pares no admiten registros adicionales.
- La creación de pictogramas aplica directamente el HUD y los sprites. Los estados visuales comparten una tabla; las propiedades constantes de visibilidad se aplican al crear el objeto y se reparan si cambia su estado, sprite o frame. Se conserva la comprobación de altura en cada tic. No se afirma una mejora de FPS sin medirla en SRB2.
- La posición segura reutiliza una tabla durante `PlayerThink`, evitando una asignación por tic. La limpieza general retira objetos y cancela ambos tipos de espera. `MobjRemoved` libera las referencias retiradas por el motor.
- Si termina la pausa entre pares mientras Sonic no tiene un objeto válido, el siguiente par sigue pendiente hasta reaparecer. El regreso y el resumen funcionan con ambos órdenes de `PlayerSpawn` y `MapLoad`.
- Recargar manualmente el mapa, preparar otra sesión o iniciar una actividad independiente limpia el estado anterior. Las actividades independientes no interrumpen un premio en curso. Los comandos de ayuda no eliminan las tarjetas.
- Volver a `fonovocab` después de comidas restaura la lista de animales. Volver a `fononivel1seq` después de PA/BA restaura su lista MA. El quiz registra toda su lista, sin terminar sus contadores al quinto acierto. `fonolista` refleja el objetivo y las respuestas actuales.
- `fonoproducciondeshacer` restaura la palabra oral pendiente durante la pausa anterior al próximo par. Después de mostrar otro par o guardar la etapa, lo rechaza con una explicación para conservar la coherencia de los resultados.
- JSON escapa comillas, barras y caracteres de control; añade `pares_detalle` sin quitar campos existentes. El resumen de aventura incluye las ayudas y la duración de una actividad terminada se conserva al cambiar de mapa. Se eliminan campos de estado que solo se escribían y nunca se consultaban.
- `build.sh` prepara y verifica el PK3 antes de reemplazarlo. Si falla la conversión del mapa, conserva el paquete anterior y el addon instalado. Usa temporales aislados y los limpia al salir.

## Inicio normal

Compilar y cargar el addon sigue igual:

```bash
./build.sh
./run-opengl.sh
```

En la consola de SRB2, uno por uno:

```text
devmode 1
map MAPA0
fonotiempo 5
fonoaventura Demo_001 5a0m
```

Tocar una tarjeta, evaluar la palabra objetivo con `1–5` y avanzar cuando se habilite el checkpoint. Completar las seis etapas desbloquea la meta y el premio; los errores no impiden completar el recorrido. Al vencer el tiempo, comienza otro ciclo educativo automáticamente.

## Comprobación en el PC

Desde una copia del repositorio sin cambios pendientes:

```bash
git fetch origin
git switch --track origin/optimizar-juego
```

Si la rama local ya existe, usar `git switch optimizar-juego` y `git pull --ff-only origin optimizar-juego`. No descartar modificaciones locales para cambiar de rama; revisarlas primero con `git status -sb`.

Después de compilar y abrir SRB2:

1. Ejecutar los cuatro comandos de inicio; deben aparecer dos pictogramas en MA y los cinco postes del recorrido.
2. Revisar visibilidad y posición izquierda/derecha de las tarjetas, el HUD debajo de RINGS y las teclas `1–5` con la consola cerrada.
3. Elegir un distractor: la producción oral pendiente debe seguir siendo la palabra objetivo, no el distractor. No debe aparecer otro par antes de evaluarla.
4. Reaparecer durante la pausa entre pares: el siguiente par debe aparecer al recuperar un jugador válido.
5. Completar las seis etapas, incluyendo algún error; comprobar cada checkpoint y el desbloqueo de la meta.
6. Pasar de Act 1 a Act 2: el reloj debe continuar. Al agotarse, comprobar regreso a MA con una sola pareja y sin duplicar postes o muro.
7. Probar `fonofinjuego`: debe volver, mostrar un resumen y permitir iniciar otra aventura.
8. Repetir `map MAPA0` y el inicio: debe bastar el flujo normal, sin `fonoreset` ni limpieza previa.

## Pruebas automatizadas

Requisitos de desarrollo: Python 3, compilador C (`cc`), `zip` y una copia del código fuente oficial de [SRB2](https://github.com/STJr/SRB2) con `src/blua/`. No son necesarios para usar el juego; Python y zip ya son dependencias de compilación del addon.

```bash
python3 Tests/run.py --engine-source /ruta/al/codigo/SRB2
```

El ejecutor compila el intérprete de SRB2 en una carpeta temporal. Adapta únicamente la carga de archivos y una constante de formato; conserva su parser, VM, operaciones de bits, división entera y comportamiento de cero. Las funciones del motor se simulan y los objetos retirados rechazan accesos inválidos.

Comprobado con el código oficial en `639b58c6d718452ef343a0bc927d043bed9e40d6`:

- Dos suites de integración Lua: recorrido de 17 pares, contadores, respuesta oral esperada, entradas inválidas/repetidas, reaparición, deshacer, cambios de modo, comandos anteriores, estados de sprites, checkpoints, premio entre actos, regreso automático y cierre anticipado.
- Tres pruebas de empaquetado: integridad y contenido del PK3; recursos idénticos a sus fuentes; conversión exacta del único marcador MAP01 a MAPA0; conservación del paquete ante un WAD inválido o un segundo script Lua.
- Comprobaciones de sintaxis de Bash, compilación de los scripts Python y `git diff --check`.

La simulación no comprueba renderizado OpenGL, colisiones, controles físicos, audio ni el orden real de todos los eventos del motor. La aceptación final requiere la prueba en SRB2 del PC.

Para pruebas de empaquetado, `FONO_PK3_PATH` y `FONO_ADDONS_DIR` permiten destinos temporales. Si no se establecen, las rutas de instalación siguen siendo las habituales.
