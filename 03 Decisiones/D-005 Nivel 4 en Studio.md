---
tipo: decision
id: D-005
fecha: 2026-11-12
estado: aceptada
---
# D-005 Nivel 4 en Studio y portal del nivel 3 #decidido

## Decisión
- Angel aprobó el prototipo del [[Nivel 4 - Valle del Avión]].
- El nivel 4 vive en el mismo place, lejos del nivel 3 (X +18000) para que no se vea.
- Al entrar al portal del nivel 3 el jugador pasa al spawn del nivel 4.
- No se modificó ningún script del juego.

## Cómo quedó (técnico)
- Folder `PenguinSlingshotMap_Level4` con `LevelId = 4`. Tiene las carpetas Terrain, Obstacles, PlaneWreck, Wildlife, Decoration, Gameplay, Hazards, CanyonWalls, Forest y Ridges, más la resortera, su decoración y los pingüinos en fila (clonados del nivel 1).
- **Base más alta:** la cumbre está a Y 1200 (los otros niveles, a Y 600), porque la pista baja ~1,000 studs. La meta queda a Y ~210.
  - La resortera se clonó con +600 en Y.
  - `SeatPosition` y `DismountPosition` llevan el mismo desplazamiento.
- **Grietas:** las 3 tienen una parte invisible con tag `Hazard` (`HazardKind = Pit`) a 25 studs bajo la orilla. El piso del valle (Y 0) también es `Hazard`, por si alguien se cae de la montaña.
- **Ciervos:** son modelos de partes sin script, quietos.
- **Tags:** `PlateauSpawn`, `FinishLine` (Z 3440) y `ReturnPortal`. Este último es el portal clonado en Z 3530, sin `DestinationLevel`, así que regresa al inicio del nivel 4.
- El trigger del portal del nivel 3 ahora tiene `DestinationLevel = 4`.
- **Montañas:** se corrigieron en Studio, porque las primeras salieron como torres delgadas. Ahora son macizos anchos pegados a la pista.
- Script: `05 Técnico/BuildLevel4_v01.lua`.

## Probado
- Portal del nivel 3 → spawn del nivel 4.
- Morir en el nivel 4 → reaparece en el nivel 4.
- Pendiente: lanzarse con la resortera y recorrer la pista completa.

## Relacionado
[[Nivel 4 - Valle del Avión]] · [[D-004 Nivel 3 en Studio]] · [[Arquitectura]]
