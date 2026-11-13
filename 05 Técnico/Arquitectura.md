---
tipo: tecnico
estado: pendiente
---
# Arquitectura

#pendiente Se define al terminar la planeación.

## Decidido
- GUIs con patrón **MVP** → [[D-006 Patrón MVP para las GUIs]]

## Estructura del prototipo v1 #idea
Scripts dentro de la place (sin Rojo por ahora):

| Lugar | Contenido |
|---|---|
| `ReplicatedStorage.Shared` | `GameConfig` (todos los valores ajustables), `RunState`, `Pose`, `Remotes`, `LaunchMath`, `PenguinOrientation`, `SlingshotGeometry`, `Signal`, `Cleaner` |
| `ServerScriptService.Server` | `Main` + `Services`: `RunStateService` (estado por jugador), `SlingshotService`, `RaceService` (meta, choques y caídas), `PoseService`, `ReturnService` |
| `StarterPlayerScripts.Client` | `Main` + `Run` (controlador y modos Idle/Aiming/Racing/Finished), `Aim`, `Race`, `Character`, `Presentation` (animaciones, partículas, sonidos), `Gui` (MVP), `Audio`, `Effects`, `Input` |
| `StarterGui.GameHud` | Lecturas mínimas: barra de fuerza, tiempo y velocidad, tiempo de meta |
| `StarterPlayer.StarterCharacter` | El pingüino |

- **Estados del jugador** (los decide el servidor): `Idle → Aiming → Racing → Finished → Idle`.
- **GUI en MVP:** `AimModel`/`RaceModel` (modelos), `*View` (solo pintan), `*Presenter` (formatean y conectan) → [[D-006 Patrón MVP para las GUIs]]
- **El mapa se conecta por etiquetas** (CollectionService): `Slingshot`, `LandingZone`, `FinishLine`, `ReturnPortal`, `PlateauSpawn`, `Hazard` (atributo `HazardKind`). Si se rehace una pieza del mapa hay que volver a etiquetarla.
- **Físicas del deslizamiento en el cliente** (dueño de su personaje); el servidor valida subirse, el lanzamiento y la meta, y es quien mata al pingüino.

Detalle de lo implementado: [[Prototipo jugable v1]]

## Temas a decidir
- Estructura client / server / shared
- Autoridad del servidor sobre el lanzamiento y el puntaje
- Física: simulación del cliente vs servidor
- Herramientas (Rojo, Wally, etc.) o solo Studio
- Guardado de datos (DataStore): Angel quiere quitar el manejador de datos hecho a mano y usar una librería probada (ProfileService o su sucesor ProfileStore). Falta revisar el código actual en Studio. #pendiente

Ver [[Convenciones]]
