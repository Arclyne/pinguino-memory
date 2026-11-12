---
tipo: decision
id: D-003
fecha: 2026-11-11
estado: aceptada
---
# D-003 Nivel 2 y portal entre niveles #decidido

## Decisión
- El nivel 2 (Aldea Nevada) vive en el mismo place, lejos del nivel 1 (X +6000) para que no se vea.
- Al entrar al portal del nivel 1 el jugador pasa al spawn del nivel 2.

## Cómo quedó (técnico)
- Cada nivel es un Folder en Workspace con atributo `LevelId` (1 = `PenguinSlingshotMap_v01`, 2 = `PenguinSlingshotMap_Level2`).
- El jugador guarda su nivel actual en el atributo `LevelId`.
- Nuevo `ReplicatedStorage.Shared.LevelRegistry`: nivel de una instancia, nivel del jugador, primer tag por nivel y punto de llegada.
- Nuevo `ServerScriptService.Server.Services.LevelService`: pone `LevelId = 1` al entrar y, al reaparecer, lleva al jugador al spawn de su nivel.
- `SlingshotService`: maneja una estación por cada resortera con tag `Slingshot`.
- `RaceService`: una meta (`FinishLine`) por nivel.
- `ReturnService`: el portal usa el atributo `DestinationLevel` (el del nivel 1 = 2); sin atributo regresa al inicio de su propio nivel. Pide streaming alrededor del destino antes de teletransportar.
- `SlingshotGeometry.find(levelId)`; `AimingMode` y `SlingshotBandController` buscan la resortera del nivel del jugador.
- Scripts: `05 Técnico/BuildLevel2_v02.lua` y `05 Técnico/UpdateScripts_Levels.lua`.

## Probado
- Portal del nivel 1 → spawn del nivel 2 (`LevelId 2`, Idle).
- Morir en el nivel 2 → reaparece en el nivel 2.

## Relacionado
[[Nivel 2 - Aldea Nevada]] · [[Arquitectura]] · [[Mapa]]
