---
tipo: tecnico
estado: pendiente
---
# Arquitectura

#pendiente Se define al terminar la planeación.

## Decidido
- GUIs con patrón **MVP** → [[D-006 Patrón MVP para las GUIs]]
- Datos del jugador con **DataKit** → [[D-015 DataKit para los datos del jugador]]

## Datos del jugador (PINGUINO TEST)
| Pieza | Qué hace |
|---|---|
| `ServerStorage.Packages.DataKit` | El paquete de Angel (lease + fence, autosave cada 300 s) |
| `ServerScriptService.Server.Data.PlayerProfile` | Forma del perfil (`Template`), reinicio semanal y `sanitize` (tipos, skin por default, skin equipada válida) |
| `ServerScriptService.Server.Services.PlayerDataService` | Carga y cierra un store por jugador; API `get`, `update`, `addFish`, `spendFish`, `snapshot`, `currentWeek`, señales `Changed` y `Loaded` |

- DataStore `PenguinPlayer`, key `<UserId>`. Los datos viejos de `PenguinProfile_v1` eran de pruebas y no se migraron.
- `PlayerDataService` reemplaza al `ProfileService` casero con la misma API; Fish, Leaderboard, Progress, Reward, Skin y Wheel solo cambiaron el nombre del require.
- Si la carga falla o tarda más de 60 s → `Kick`. Si otro server toma la sesión → `Kick`.
- `BindToClose` espera a que terminen todos los guardados, incluidos los que empezó `PlayerRemoving`.
- Probado en Play: regalo diario (+100 peces) → cerrar → volver a abrir → los 100 peces siguen ahí.

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

Ver [[Convenciones]]
