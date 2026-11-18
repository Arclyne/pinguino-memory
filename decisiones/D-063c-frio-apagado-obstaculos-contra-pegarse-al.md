---
tipo: decision
id: D-063c
fecha: 2026-11-18
autor: ciervo
estado: vigente
tema: nivel-1
---
# D-063c · Frío apagado, obstáculos contra pegarse al borde y efectos de velocidad
- Ciervo decidió (2026-11-18): el frío se apaga otra vez (como en D-058c); obstáculos más estimulantes, como meteoritos que caen, porque bastaba con pegarse a un lado de la pista para no chocar nunca; efectos en pantalla muy estimulantes cuando vas muy rápido.
- porqué: el juego se podía pasar sosteniendo izquierda o derecha.
- Claude eligió (sin aprobar):
  - 6 obstáculos nuevos en todos los biomas, que en conjunto pesan la mitad de cada bioma: meteorito a la izquierda, meteorito a la derecha, lluvia de 4 meteoritos (cubren bordes y centro), muro de neón que cruza todo el ancho con un hueco que se mueve, trampa de picos en los dos bordes y láser que barre de borde a borde.
  - Meteoritos: círculo rojo que parpadea en la pista cada vez más rápido, el meteorito cae en llamas desde ~170 studs, explota en chispas y se queda en el suelo un momento.
  - Obstáculos más seguidos (`Obstacles.Spacing` 140 → 115).
  - Efectos de velocidad desde ~95 studs/s, más fuertes hasta ~185: bordes de pantalla arcoíris que laten, anillos de túnel que salen del centro, colores más saturados con tinte que cambia, estela y chispas arcoíris en el pingüino, sacudida de cámara y más campo de visión; letreros ¡RÁPIDO! (115), ¡SUPER VELOCIDAD! (145) y ¡HIPERVELOCIDAD! (170) con destello al subir de nivel.
- sin decidir: si es demasiado difícil o demasiado efecto (falta que lo juegue una persona), sonidos para el meteorito y para los niveles de velocidad.
- dónde vive: `ClaudeBuild.EndlessObstacleBuilder` (`GLOBAL`, `GLOBAL_SHARE`), `Client.Endless.ObstacleMotion` (movimiento `Drop`), `Client.Race.HyperSpeedFx` (lo arranca `SpeedEffects`), `Shared.EndlessConfig` → [[nivel-1]].
- choca con D-061a (Angel, mismo día: el frío vuelve), que no estaba sincronizada cuando ciervo empezó → Q-37a.
