---
tipo: decision
id: D-068c
fecha: 2026-11-18
autor: ciervo
estado: vigente
tema: nivel-1
---
# D-068c · Caminos que se dividen en cada bioma, piso continuo y menos efectos
- Ciervo decidió (2026-11-18): cada bioma tiene tramos donde la pista se divide en varios caminos para elegir mientras bajas (como la pista vieja). Se quitan los bordes arcoíris y los anillos blancos de alta velocidad (deja sin efecto esa parte de D-063c y D-067c). La cámara solo tiembla cerca de la velocidad máxima. El piso de todos los niveles no debe tener escalones que hagan saltar al pingüino.
- porqué: el piso con escalones hacía saltar al pingüino; los bordes y anillos estorbaban.
- Claude eligió (sin aprobar): una pieza `<Tema>Fork` por bioma (29) de 1,000 studs que el generador mezcla con las demás. La pista se ensancha a 112, una isla con borde la parte en dos: izquierda **TURBO** (2 rampas de salto) y derecha **SEGURO** (2 pads de turbo), con letrero antes. Sin obstáculos ni botiquines dentro del tramo; el rescate y el salto de resortera caen en el camino derecho. Piso: las cajas `Road` se cambiaron por una "piel" de triángulos continua (`EndlessRoadSkin`); en el navideño las cajas viejas quedan 0.45 abajo y la piel se angosta en curvas cerradas para no doblarse. Temblor: `HyperSpeedFx` ya no sacude; `TopSpeedRumble` empieza a 165 y llega al máximo a 185 (antes 132–150).
- medido: escalón máximo del piso 0.32 → 0.04 studs en los 28 biomas de constructor y 0.14 en el navideño (quiebres de pendiente de la pista original, no escalones). Las piezas pasaron de ~198,000 a ~304,000 instancias.
- dónde vive: `ClaudeBuild.EndlessBiomeBuilder` (`buildForkPiece`, `runFork`), `ClaudeBuild.EndlessRoadSkin`, `Shared.EndlessCatalog` (`fork`), `Shared.EndlessLayout.safeLateralAt`, `EndlessRunService`, `Shared.MedkitField`, `Race.HyperSpeedFx`, `GameConfig.Feel.RumbleStartSpeed` → [[nivel-1]].
