---
tipo: tecnico
estado: en progreso
---
# Arquitectura

#pendiente Se define al terminar la planeación.

## Temas a decidir
- Estructura client / server / shared
- Autoridad del servidor sobre el lanzamiento y el puntaje
- Física: simulación del cliente vs servidor
- Herramientas (Rojo, Wally, etc.) o solo Studio
- Guardado de datos (DataStore)

Ver [[Convenciones]]

## Lo que ya existe en el juego (2026-11-13)
- **Niveles:** cada nivel es un folder en Workspace con el atributo `LevelId`. Usan los tags `PlateauSpawn`, `FinishLine`, `ReturnPortal`, `Slingshot` y `Hazard`. `LevelRegistry` (Shared) busca las cosas por nivel. Hay 5 niveles; los niveles 3, 4 y 5 están en X +12000, +18000 y +24000 (ver cada decisión).
- **Carrera (cliente):** `Client.Race` (SlideMotor, ChaseCamera, SpeedEffects…). Los modos `Client.Run.Modes` (Idle, Aiming, Racing, Finished) siguen el atributo `RunState` del jugador.
  - La cámara de la carrera busca suelo con un raycast hacia abajo. Por eso los techos del nivel 5 no tienen colisión ni raycast.
  - Los choques se detectan con raycast (`_crashInto`).
- **`LobbyMain`** (LocalScript) inicia ProfileStore, LeaderboardStore, Feedback, LobbyHud, FishPickupController, WorldWheelController, WorldBoardController, StepAssist, AvalancheCinematic, IconText y **WindowBreaker**.
- **WindowBreaker (nuevo):** solo corre en el nivel 5 mientras se juega la carrera.
  - Detecta cuando el pingüino cruza un modelo con tag `BreakableWindow` y lo esconde en el cliente con `LocalTransparencyModifier`, con esquirlas, destellos y sonido.
  - Muestra el contador y el nombre de la casa.
  - Hace transparentes las partes con tag `HouseShell` que quedan entre la cámara y el pingüino.
  - Funciona con streaming: recoge las ventanas y las paredes conforme van cargando.
- **Servidor:** `ServerScriptService.Server.Services` (ReturnService, ProgressService, RunStateService, FishService, RewardService, SkinService, WheelService…).
- **Herramientas:** solo Studio. Los cambios se meten por la barra de comandos o importando `.rbxmx` desde `05 Técnico`.
