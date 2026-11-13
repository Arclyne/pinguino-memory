---
tipo: sistemas
verificado: 2026-11-13 (Studio; cada sistema dice si su código se leyó entero, por encima, o si viene del vault v1)
---
# Sistemas de la place

Qué hace cada sistema y qué scripts lo forman. Firmas, dependencias, etiquetas y atributos por script: [[mapa-place]]. Números: [[valores]]. Toda nota de aquí describe el código; si no coincide con Studio, gana Studio.

Rutas base: `Shared` = `ReplicatedStorage.Shared` · `Services` = `ServerScriptService.Server.Services` · `Client` = `StarterPlayer.StarterPlayerScripts.Client`.

## Arranque
- Servidor: `Server.Main` inicia en orden LevelService, RunStateService, SlingshotService, RaceService, PoseService, ReturnService, LevelFlowService. `EconomyMain` (script aparte) inicia PlayerDataService, SkinService, FishService, WheelService, RewardService, ProgressService, LeaderboardService.
- Cliente: `Client.Main` arma el HUD de carrera, la presentación, la decoración y el `RunController` con sus 4 modos. `LobbyMain` (script aparte) inicia ProfileStore, LeaderboardStore, Feedback, LobbyHud, FishPickupController, WorldWheelController, WorldBoardController, StepAssist, AvalancheCinematic, IconText, WindowBreaker, LobbyLighting. `CuteDecorIdle` es un LocalScript suelto que arranca solo.
- Dos puntos de entrada por lado: lo de carrera y lo de economía/lobby se inician por separado. Un servicio nuevo hay que agregarlo a la lista correcta.
- Utilidades compartidas: `Signal`, `Cleaner`.

## Estados (leído entero)
- `Shared.RunState`: Idle, Aiming, Racing, Finished. Lo decide el servidor (`RunStateService`) y lo publica en el atributo `RunState` del jugador y por el remote `RunStateChanged`.
- Transiciones permitidas: Idle→Aiming · Aiming→Racing, Idle · Racing→Finished, Idle · Finished→Idle, Aiming. `reset` fuerza Idle. Cada personaje nuevo reinicia a Idle.
- `RunStateService.Changed` (señal del servidor) es de donde cuelgan carrera, peces, progreso y avance de nivel.
- Cliente: `RunController` cambia entre `IdleMode`, `AimingMode`, `RacingMode`, `FinishedMode`. Varios scripts del lobby leen el atributo `RunState` directamente.

## Niveles (leído entero)
- Un nivel = Folder en Workspace con atributo `LevelId`. El jugador lleva su nivel en el atributo `LevelId`. `Shared.LevelRegistry` resuelve: nivel de una instancia (sube por los ancestros), primer objeto con una etiqueta en un nivel, punto de llegada (5 studs sobre `PlateauSpawn`) y siguiente nivel (`DestinationLevel` del `ReturnPortal`, o el mismo).
- `LevelService`: pone `LevelId = 1` al entrar; al reaparecer en otro nivel pide streaming y mueve al personaje a su meseta.
- `ReturnService`: al tocar un `ReturnPortal`, si el jugador está en Finished dispara `PortalEnteredAfterFinish`; si no, lo manda al destino del portal. `sendToLevel` solo actúa en Idle o Finished.
- `LevelFlowService`: al entrar a Finished espera `GameConfig.Race.AutoAdvanceSeconds` y monta al jugador en la resortera del siguiente nivel (`SlingshotService.mountAtLevel`); si no puede, lo manda a la meseta. El portal adelanta el avance (D-016).
- `ProgressService`: al terminar guarda `finishes` y `bestTimes` del nivel y suma `weekRuns`. `isUnlocked`: el nivel 1 siempre; el N si terminó el N-1. Atiende `LevelTravelRequested` (panel de niveles) y `LaunchPadRequested` (botón ¡LANZAR!).
- Para agregar un nivel: Folder con `LevelId`, y dentro `PlateauSpawn`, `Slingshot` (con `SeatPosition`, `DismountPosition`, `LaunchForward`), `FinishLine` y `ReturnPortal`; poner `DestinationLevel` en el portal del nivel anterior; agregarlo a `LEVELS` en `LevelsPanel`.

## Resortera (servidor por encima; cliente del vault v1)
- `Shared.SlingshotGeometry` encuentra la resortera de un nivel y su asiento. `Shared.LaunchMath` calcula dirección, velocidad y trayectoria (lo usan servidor y cliente).
- `SlingshotService`: una estación por modelo con etiqueta `Slingshot`. Un ocupante a la vez. Subirse por ProximityPrompt (valida `MountValidationDistance`), lanzar por `LaunchRequested` (valida números y `LaunchValidationDistance`), bajarse por `DismountRequested`. Si no lanza en `AimTimeoutSeconds`, lo baja. Publica la puntería del ocupante en los atributos `AimYaw`, `AimPitch`, `AimPull` de la resortera (llegan por `AimChanged`) para que todos vean la liga.
- Cliente (`Client.Aim`): `AimModel` (estado), `AimInput` (mouse y arrastre), `AimCamera`, `TrajectoryPreview`, `SlingshotBandController` + `SlingshotBandView` (liga). Lo coordina `AimingMode`.

## Carrera (servidor leído entero; cliente del vault v1)
- La física corre en el cliente, dueño de su personaje. `RacingMode` coordina vuelo y deslizamiento con `SlideMotor` (velocidad, giro, salto, impulso), `GroundProbe`, `MoveInput`, `CrashSensor`, `BoostRampSensor`, `BodyMover` (control del cuerpo y ragdoll), `PenguinOrientation`. `RaceModel` lleva tiempo y velocidad para el HUD. `LocalCharacter` da acceso al personaje.
- `RaceService` (servidor): al entrar a Racing guarda la hora y el avance de meta del nivel. Cada `TrackerIntervalSeconds` revisa a cada corredor: si su avance sobre `TrackForward` pasa el de la `FinishLine` → Finished con el tiempo (o reinicio si tardó menos de `MinimumPlausibleSeconds`); si está bajo `KillHeight` o sobre una parte `Hazard` → eliminado.
- Eliminación: avisa por `RaceNotice` ("Eliminated", con `hazardKind`) y, tras `Crash.RagdollSeconds`, hace `LoadCharacter`. Tipos: `Fall`, `Crash`, o el `HazardKind` de la parte (`Pit`, `Water`).
- Choques: los detecta el cliente y los reporta por `CrashReported`; el servidor no valida el choque, solo limita la frecuencia.
- Rampas de impulso: `BoostRampSensor` lanza un rayo hacia abajo; si pisa una parte `BoostRamp`, `SlideMotor.boost()` sube velocidad y tope según `GameConfig.Boost` (D-017).
- La etiqueta `LandingZone` existe en N1 pero ningún script la lee.

## Cámara y sensación (del vault v1; código no releído)
- `ChaseCamera` sigue al pingüino; `CameraOcclusion` la acerca si un techo u objeto grande tapa la vista (ignora piezas casi transparentes y props chicos); `CameraFeel` suma temblor, inclinación y FOV. `AimCamera` y `DefaultCamera` cubren las otras fases.
- `Client.Race.Feel`: `RaceFeel` mide la aceleración y alimenta con un `MotionSample` a `BrakeEffects`, `CarveEffects`, `TopSpeedRumble` (temblor y vibración del control) y `BoostEffects`; `ParticleFactory` crea las partículas. `SpeedEffects`: líneas, spray, estela, rachas y modo impulso. Umbrales en `GameConfig.Feel` (D-018).

## Presentación del pingüino (del vault v1; código no releído)
- `Shared.Pose` lista las poses. `LocalPose` publica la pose local; `PoseService` la valida y replica (remote `PoseChanged`, atributo `Pose`).
- `PresentationController` crea una `CharacterPresentation` por personaje: `PenguinAnimator` (animación por código), `PenguinEffects` (partículas), `PenguinSounds`. Sonidos sueltos con `FeedbackSounds`; IDs en `SoundCatalog`. `WorldEffects`: salpicadura al caer al agua.

## HUD de carrera (MVP, D-006)
- `StarterGui.GameHud` con `AimBar`, `RaceReadout`, `FinishReadout`. Modelos `AimModel` y `RaceModel`; vistas `AimHudView`, `RaceHudView`, `FinishView`; presentadores `AimHudPresenter`, `RaceHudPresenter`, `FinishPresenter`; `TimeFormatter`.

## Datos (por encima)
- `ServerStorage.Packages.DataKit`: paquete de Angel (D-015). `Server.Data.PlayerProfile`: nombre del store, plantilla del perfil, reinicio semanal y `sanitize`. Campos en [[valores]] § PlayerProfile.
- `PlayerDataService`: un store por jugador. API `get`, `update`, `addFish`, `spendFish`, `snapshot`, `currentWeek`; señales `Changed` y `Loaded`. Si la carga falla o pasa de 60 s, o si otro servidor toma la sesión → `Kick`. `BindToClose` espera los guardados en curso. Publica cambios al cliente por `ProfileChanged`; el cliente los guarda en `ProfileStore`.
- DataStore `PenguinPlayer`, clave = UserId. Las tablas usan OrderedDataStore aparte (ver Economía).

## Economía (servidor leído entero)
Reglas de juego en [[lobby-economia]]. Todo remote pasa por `Server.Util.RateLimiter` (cubeta por jugador; el número es peticiones por segundo).

| Servicio | Remotes | Límite | Valida |
|---|---|---|---|
| `FishService` | `FishCollectRequested` | 25 | estado Racing, pez no cobrado en esta carrera, distancia ≤ `Fish.ValidationRadius` |
| `RewardService` | `BoostPurchaseRequested`, `DailyGiftClaimRequested` | 3 | peces suficientes; tiempo desde el último regalo |
| `WheelService` | `WheelSpinRequested` · `WheelSpinPurchaseRequested` | 1 · 3 | giro gratis disponible o giros extra; peces suficientes |
| `SkinService` | `SkinPurchaseRequested`, `SkinEquipRequested` | 4 | skin existe, no la tiene, peces suficientes; para equipar, que la tenga |
| `ProgressService` | `LevelTravelRequested`, `LaunchPadRequested` | 1 | nivel existe y desbloqueado; estado Idle o Finished |
| `LeaderboardService` | `LeaderboardRequested` | — | solo lectura |

- `FishService` crea los peces al arrancar el servidor en `Workspace.FishPickups` (etiqueta `FishPickup`, atributo `PickupId`); no existen en modo edición. El cliente (`FishPickupController`) los anima, detecta el contacto y pide el cobro.
- `WheelService` avisa a todos con `WheelSpun` y entrega el premio al terminar `Wheel.SpinSeconds`. Catálogo: `Shared.WheelCatalog`.
- `SkinService` viste al personaje con `Shared.SkinAppearance` (catálogo `Shared.SkinCatalog`); la skin puesta queda en el atributo `SkinId` del personaje.
- `LeaderboardService`: cada `Leaderboard.RefreshSeconds` escribe a los jugadores conectados en tres OrderedDataStore (`LB_fish_w<semana>`, `LB_runs_w<semana>`, `LB_time_level1`) y publica el top por `LeaderboardChanged`. Si el DataStore falla, usa solo los conectados.
- Constantes y remotes: `Shared.EconomyConfig`, `Shared.EconomyRemotes` (los de carrera están en `Shared.Remotes`; todos viven en `ReplicatedStorage.Remotes`).

## Lobby: GUI (LobbyHud leído entero; lo demás por encima)
- No usa StarterGui: `LobbyHud` crea por código los ScreenGui `LobbyHud` y `LobbyPanels`. Se oculta fuera de Idle y Finished. Registra teclas y abre paneles; los ProximityPrompt con atributo `OpensPanel` abren el panel de ese nombre.
- `PanelHost` muestra un panel a la vez. `Client.Panels`: `SkinsPanel`, `ShopPanel`, `WheelPanel`, `LevelsPanel`, `LeaderboardPanel`, e `InfoPanel` (plantilla para custom, boost, invite, starter, vip, gift, rebirth, friend, race, event).
- Piezas de interfaz: `UiKit` (botones, etiquetas, paletas), `HudIcons` e `IconText` (iconos dibujados en vez de emoji), `HudLife` (brillos y vida de los botones), `Feedback` (avisos y confeti), `PenguinViewport` (pingüino 3D en paneles).
- Datos en cliente: `ProfileStore` (perfil) y `LeaderboardStore` (tablas).

## Lobby: mundo
- `WorldWheelController` gira la ruleta 3D (`LobbyWheel`) cuando llega `WheelSpun`. `WorldBoardController` llena la tabla (`LobbyLeaderboard`) y viste los maniquíes del podio (`PodiumMannequin`, atributo `Rank`).
- `LobbyLighting` (por encima): cuando el jugador está dentro de la caja del lobby baja la exposición y cambia el bloom; al salir los restaura.
- `CuteDecorIdle` (por encima): anima los modelos con etiqueta `CutePenguin`, `CuteIgloo` y `CuteArch` (atributo `Role` por pieza) cuando la cámara está cerca.
- Carpetas y posiciones: [[lobby-economia]].

## Decoración animada (del vault v1 más etiquetas comprobadas)
Solo cliente. `DecorationController` inicia un módulo por etiqueta; para animar algo nuevo basta etiquetarlo.

| Etiqueta | Módulo | Efecto | Atributos |
|---|---|---|---|
| `CheeringPenguin` | `CheeringCrowd` | público que salta y agita aletas; solo cerca de la cámara | `CheerMode` (cheer, drum, music, shovel, wave), `CheerPhase`, `Cheers` |
| `SpinningDecor` | `SpinningDecor` | gira | `SpinSpeed`, `SpinAxis` |
| `SwingingDecor`, `SkyLantern` | `SwingingDecor` | se mece; las linternas suben | `SwingAmplitude`, `RiseHeight`, `RiseSpeed` |
| `FlickeringFlame` | `FlameFlicker` | parpadeo de fuego | — |
| `PulseGlow` | `PulseGlow` | pulso de neón (flechas de las rampas) | — |
| `ChaseBulb` | `ChaseLights` | foquitos que corren | `ChaseIndex` |
| `ChevronArrow`, `DragonParade` | `ParadeMotion` | flechas del camino en ola; dragón que recorre una elipse | `ChevronIndex`, `PathCenter`, `PathRadiusX`, `PathRadiusZ`, `PathSpeed`, `SegmentIndex` |

## Avalancha (por encima; sin decisión de Angel → Q-02)
- `AvalancheCinematic` (cliente): solo en el nivel 1. Al entrar a Aiming reproduce una cinemática (se rompe la cornisa, cámara desde `ShotCamera`, letrero); en Racing una ola de nieve persigue al jugador; en Finished un cierre; en Idle limpia todo. Es visual: no elimina ni cambia la carrera.
- Mundo: `AvalancheMountain` (Folder con etiqueta, marcadores `WaveStart`, `WaveEnd`, `ShotCamera`, `Cornice`, `WatchTower`) y `AvalancheSiren`.

## Ventanas de N5 (por encima; sin decisión de Angel → Q-25)
- `WindowBreaker` (cliente, solo nivel 5): durante Racing rompe los modelos `BreakableWindow` que el pingüino atraviesa (astillas, sonido, letrero "¡CRASH!"), lleva un contador contra el atributo `WindowCount` del nivel y vuelve casi transparentes las partes `HouseShell` de la casa que se está cruzando (cada casa tiene `HouseIndex`, `DisplayName`, `WorldZMin`, `WorldZMax`). Al volver a Idle o Aiming restaura las ventanas. No usa remotes: no da peces ni cuenta en el servidor.

## Ayudas
- `StepAssist` (leído entero): mientras camina (Idle o Finished) levanta al pingüino en escalones bajos, porque sus patas cortas no los suben.

## Restos en ServerStorage (no corren en el juego → Q-14)
- `ClaudeBuild.BuildLobby`, `ClaudeBuild.BuildLevel2Festival`, `BuildStalls`, `BuildAvalancheMountains`: constructores de mapa de un solo uso.
- `ClaudeScriptDump`: volcado de texto de scripts del cliente, de una versión anterior.
- `PluginCurves`: carpeta vacía.
- `MountainLookBackup`, `CuteReplacedBackup`: respaldos de piezas reemplazadas el 2026-11-13. `CuteModels`: modelos fuente de la decoración "cute".
- `DevTools.PlaceMap`: generador de [[mapa-place]] y [[valores]]. Se queda.
- En Workspace, fuera de los niveles: `Baseplate` y un `SpawnLocation` desactivado.
