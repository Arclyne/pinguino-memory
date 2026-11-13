---
tipo: decision
id: D-011
fecha: 2026-11-12
estado: aceptada
---
# D-011 Nivel 3 en Studio y portal del nivel 2 #decidido

## Decisión
- Angel aprobó el prototipo de la [[Nivel 3 - Ciudad Nevada]].
- El nivel 3 vive en el mismo place, lejos de los otros dos (X +12000) para que no se vea.
- Al entrar al portal del nivel 2 el jugador pasa al spawn del nivel 3.
- No se modificó ningún script del juego.

## Cómo quedó (técnico)
- Folder `PenguinSlingshotMap_Level3` con `LevelId = 3`. Tiene las carpetas TrackBuildings, Obstacles, City, Decoration, Gameplay, Hazards e Icicles, más la resortera, su decoración y los pingüinos en fila (clonados del nivel 1).
- Techo de salida a Y 600, igual que los niveles 1 y 2. La pista baja hasta Y ~35 en el portal.
- Los huecos entre edificios y los lados de la pista tienen partes invisibles con tag `Hazard` (`HazardKind = Pit`), como las grietas del nivel 1. Los techos de los edificios de relleno también eliminan al jugador si cae en ellos.
- Tags que usa: `PlateauSpawn`, `FinishLine` (Z 2680) y `ReturnPortal`. Este último es el portal clonado en Z 2740, sin `DestinationLevel`, así que regresa al inicio del nivel 3.
- El trigger del portal del nivel 2 ahora tiene `DestinationLevel = 3`.
- Script: `05 Técnico/BuildLevel3_v01.lua`.

## Probado
- Portal del nivel 2 → spawn del nivel 3.
- Morir en el nivel 3 → reaparece en el nivel 3.
- Pendiente: recorrer la pista completa con la resortera para ajustar los saltos.

## Relacionado
[[Nivel 3 - Ciudad Nevada]] · [[D-010 Nivel 2 y portal entre niveles]] · [[Arquitectura]]
