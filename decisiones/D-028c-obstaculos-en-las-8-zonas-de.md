---
tipo: decision
id: D-028c
fecha: 2026-11-14
autor: ciervo
estado: reemplazada por D-031c
tema: obstaculos
---
# D-028c · Obstáculos en las 8 zonas de la pista navideña
- Ciervo decidió: agregar obstáculos coherentes con cada zona por toda la pista navideña (la tenía casi vacía: 9 pilas de regalos), a partir de una lista que propuso Claude.
- porqué: no lo dijo.
- Claude eligió (sin aprobar): 31 obstáculos con piezas del kit de la pista y una caja de choque invisible cada uno (`Hitbox`, sin `Bumper`: chocar quita vida). Lo bajo (≤ 4) se salta y lo alto (≥ 9) se esquiva, y siempre queda un paso libre de 18 studs o más. Ninguno a menos de 160 del inicio de una zona, 110 de la entrada o salida de un atajo, 50 de una caída, ni encima de turbos, rampas o regalos que ya había; al menos 220 entre uno y otro. Por zona: Colina 2 (montículo para saltar, muñeco de nieve), Bosque 4 (bastones caídos, esferas gigantes), Pueblo 4 (puestos, trineos estacionados, cajas), Centro 5 (vallas de obra, árboles de glorieta, bancas), Garaje 3 (trineos en fila, conos, rampa de salto), Taller 4 (soldados de juguete, cubos, banda cruzada), Autopista 5 (quitanieves, trineo descompuesto, cajas), Puente 2 (caja de carga, postes). En 3 sitios no cupo el que tocaba (zonas llenas).
- descartado: los que se mueven (esfera rodando, banda que empuja, cajas que caen): se hicieron fijos.
- dónde vive: `ChristmasRun.ObstaculosPista` (una carpeta por zona; cada obstáculo con `TrackDistance`), constructor `ServerStorage.ClaudeBuild.ChristmasObstacles` → [[nivel-1]].
