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
- Objetos educativos deben aparecer frente a Sonic.
- Cada pasillo debe actuar como checkpoint entre dos etapas.
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
