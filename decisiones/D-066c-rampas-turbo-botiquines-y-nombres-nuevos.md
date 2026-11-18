---
tipo: decision
id: D-066c
fecha: 2026-11-18
autor: ciervo
estado: vigente
tema: nivel-1
---
# D-066c · Rampas turbo, botiquines y nombres nuevos de resorteras
- Ciervo decidió (2026-11-18): muchas rampas por bioma, en todo el mapa, que impulsen mucho y lleven una flecha verde que parpadea; 2 botiquines por bioma; nombres más creativos para las resorteras. Los botiquines curan, así que cambia D-048a (sin curación) en eso.
- porqué: más momentos de velocidad y una forma de aguantar más lejos.
- Claude eligió (sin aprobar):
  - Rampas: cuña de 22 × 5 × 30 en carril izquierdo, centro o derecho, con orillas y postes de neón verde y 4 flechas verdes en la subida que se encienden en cadena. Es turbo (etiqueta `BoostRamp`) y salto (`KeepSpeed`, `JumpDistance` 120), igual que las rampas de la pista navideña. Salen con el generador como un obstáculo más: 22 % de lo que aparece en cada bioma (~7 por bioma); no tienen contorno de obstáculo ni te chocan.
  - Botiquines: caja blanca con cruz roja, burbuja y anillo verdes, columna de luz verde, giran y flotan. 2 por bioma, a ~1/3 y ~3/4 del bioma, en un carril al azar y lejos de los obstáculos; los mismos para todos (semilla semanal). Al pasar cerca (14 studs) se toman; el servidor revisa que estés a menos de 90 studs y cura 40 de vida sin pasar del máximo; mensaje "¡BOTIQUÍN! +N VIDA". Cada uno sirve una vez por bajada.
  - Nombres: Ramita Novata, Bronce Rebotón, Plata Saltarina, Pepita Dorada, Diamante Escarchado, Trineo Cohete, Rayo Pingüinero, Cometa Polar, Aurora Arcoíris Suprema (mismos precios y metros).
- sin decidir: si las rampas saltan bien a mano en todos los biomas (el salto no se probó jugando), y cuánto deben curar los botiquines.
- dónde vive: `ClaudeBuild.EndlessObstacleBuilder` (`RAMPS`, `RAMP_SHARE`), `Endless.ObstacleMotion` (movimiento `Blink`), `Endless.ChunkStreamer`, `Shared.MedkitField`, `Shared.EndlessConfig.Medkit`, `EndlessRunService` (remoto `MedkitPickupRequested`), `Endless.MedkitView`, `Shared.SlingshotCatalog` → [[nivel-1]].
