# Mapa Sonic FonoKids (`MAPA0`)

## Objetivo
Crear un mapa educativo simple para probar las actividades fonoaudiologicas del mod Sonic FonoKids.

El archivo fuente se conserva como `Maps/MAP01.wad`, pero `build.sh` cambia su
marcador interno a `MAPA0` al construir el PK3. De este modo, `MAP01` queda libre
para usar Greenflower Zone Act 1 como premio de juego temporizado.

## Estructura inicial
1. Inicio: silaba `MA`
2. Checkpoint 1 y zona de silaba `PA`
3. Checkpoint 2 y zona de silaba `BA`
4. Checkpoint 3 y zona de animales
5. Checkpoint 4 y zona de comidas
6. Checkpoint 5 y zona de transportes
7. Meta educativa y acceso al premio `MAP01`

## Reglas de diseno
- Sin enemigos.
- Sin precipicios.
- Espacios amplios.
- Caminos claros.
- Los objetos educativos deben aparecer solo cuando Sonic llegue al centro de la zona.
- Los pictogramas deben quedar anclados al centro activado, no seguir al jugador.
- Cada pasillo debe incluir un Star Post visible y actuar como checkpoint entre dos etapas.
- Cada Star Post habilitado debe guardar el punto de reaparicion de Sonic.
- Un checkpoint bloqueado debe devolver a Sonic a una posicion segura.
- La meta solo debe habilitarse despues de completar las seis actividades.
- El mapa debe servir para ninos pequenos, no para desafio de plataformas.

## Comandos a probar
- fonoma2
- fonovocab2
- fonospritecheck
- fonoreporte
- fonoaventura Demo_001 5a0m
- fonoetapa
- fonojuegotest 30

## Centros de activacion y checkpoints

| Etapa | Sector | Centro de activacion | Checkpoint |
|---|---:|---:|---:|
| MA | 100 | `(-6784, 0)` | `(-6272, 0)` |
| PA | 110 | `(-5248, 0)` | `(-4224, 192)` |
| BA | 120 | `(-2944, 512)` | `(-1920, 256)` |
| Animales | 130 | `(-640, -512)` | `(384, -384)` |
| Comidas | 140 | `(1920, 704)` o `(1920, -704)` | `(3264, 0)` |
| Transportes | 160 | `(4224, 0)` | Meta educativa |

Cada centro utiliza un radio de activacion de 144 unidades. La zona de comidas
acepta dos centros porque la sala puede recorrerse por su franja superior o
inferior; los pictogramas aparecen en la franja que Sonic alcance primero.
