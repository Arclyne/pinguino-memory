---
tipo: decision
id: D-031c
fecha: 2026-11-14
autor: ciervo
estado: vigente
tema: obstaculos
---
# D-031c · Muchos más obstáculos y recta final en slalom
- Ciervo decidió: muchos más obstáculos por todo el mapa, sobre todo en la recta final, pero que sea jugable. Reemplaza los números de D-028c.
- porqué: no lo dijo.
- Claude eligió (sin aprobar): 66 obstáculos (antes 31). Separación mínima 150 studs (~0.9 s a 165), 220 en la Colina y 115 en el Puente. En la recta final (Puente del Puerto) un slalom de 13: filas de 3 cajas de carga que tapan media calle alternando lado, postes en las dos orillas, vallas, un quitanieves y cajas. Márgenes: 120 del inicio de zona, 80 de un atajo, 30 de una caída. Se revisó la geometría de los 65 grupos: el paso más angosto es de 18 studs y entre cada obstáculo y el siguiente siempre hay una línea libre (no exige giros imposibles). Siguen fijos y con caja `Hitbox`.
- descartado: llenar los atajos.
- dónde vive: `ChristmasRun.ObstaculosPista`, constructor `ClaudeBuild.ChristmasObstacles` (`Plan` y `Spacing`) → [[nivel-1]].
