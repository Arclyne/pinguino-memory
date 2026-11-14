---
tipo: tarea
id: T-13c
fecha: 2026-11-14
autor: ciervo
estado: pendiente
grupo: construir
---
# T-13c · Texturizar el suelo de la pista navideña (D-025c)
La pista navideña (`ChristmasRun`) no tiene carpeta `GroundTexture`: su ladera (`Ground.SnowSlope`, 939 partes) y su calle son lisas, aunque D-025c pide textura en todo nivel nuevo. `DevTools.GroundTexturer` busca solo ±100 studs alrededor de la X de la resortera, y esta pista se curva hasta ±230: hay que ampliar la franja o seguir `ChristmasTrack.xAt`.
- hecho cuando: la ladera tenga parches en tonos de blanco a lo largo de toda la pista, sin bajar mucho el rendimiento (ya son ~90,500 instancias).
- bloqueada por: Q-26c (confirmar que la pista se queda).
