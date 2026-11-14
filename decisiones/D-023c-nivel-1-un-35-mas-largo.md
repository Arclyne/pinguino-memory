---
tipo: decision
id: D-023c
fecha: 2026-11-13
autor: ciervo
estado: reemplazada por D-027c
tema: niveles
---
# D-023c · Nivel 1 un 35 % más largo
- Ciervo decidió: alargar N1 un 35 % sin cambiar lo que ya existe; solo agregar recorrido y obstáculos coherentes.
- porqué: el nivel 1 se sentía corto.
- Claude eligió (sin aprobar): 630 studs nuevos entre el campamento y la meta, en tres zonas (Pinar, Lago congelado, Paso de rocas) con obstáculos clonados de los que ya tiene N1; la meta, la plaza, el portal, la fiesta y el castillo de hielo se movieron 630 hacia adelante y 143.5 hacia abajo. Como la pista baja de Y 0, N1 lleva el atributo `KillHeight = -220` y `RaceService` lo usa en vez de `GameConfig.Race.KillHeight` (los demás niveles siguen igual).
- descartado: nada.
- dónde vive: [[nivel-1]] § Zonas; `RaceService` → [[sistemas]].
