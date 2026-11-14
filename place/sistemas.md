---
tipo: sistemas
verificado: 2026-11-14 (Studio; § Modo Avalancha escrito y probado en Play el 14 por ciervo; ChristmasTrack y ChristmasRunService leídos enteros y RacingMode por encima el 14 por ciervo; ProgressService y RaceService releídos el 13; cada sistema dice si su código se leyó entero, por encima, o si viene del vault v1)
---
# Sistemas de la place

Qué hace cada sistema y qué scripts lo forman. Firmas, dependencias, etiquetas y atributos por script: [[mapa-place]]. Números: [[valores]]. Toda nota de aquí describe el código; si no coincide con Studio, gana Studio.

Rutas base: `Shared` = `ReplicatedStorage.Shared` · `Services` = `ServerScriptService.Server.Services` · `Client` = `StarterPlayer.StarterPlayerScripts.Client`.

## Arranque
- Servidor: `Server.Main` inicia LevelService, RunStateService, SlingshotService, RaceService, PoseService, ReturnService, LevelFlowService, ChristmasRunService y AvalancheModeService. `EconomyMain` (script aparte) inicia PlayerDataService, SkinService, FishService, WheelService, RewardService, ProgressService, LeaderboardService.
- Cliente: `Client.Main` arma el HUD de carrera, la presentación, la decoración y el `RunController` con sus 4 modos. `LobbyMain` (script aparte) inicia ProfileStore, LeaderboardStore, Feedback, LobbyHud, FishPickupController, WorldWheelController, WorldBoardController, StepAssist, AvalancheCinematic, AvalancheModeClient, RunEvents, IconText, WindowBreaker, LobbyLighting. `CuteDecorIdle` y `ChristmasRunClient` son LocalScripts sueltos que arrancan solos.
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
- `LevelFlowService`: al entrar a Finished espera `GameConfig.Race.AutoAdvanceSeconds` y monta al jugador en la resortera del siguiente nivel (`SlingshotService.mountAtLevel`); si no puede, lo manda a la meseta. El portal adelanta el avance (D-016). Desde el 14 solo existe N1 (su portal lleva a N1): se vuelve a montar en la misma resortera, y `LevelsPanel` solo lista "GRAN BAJADA NAVIDEÑA".
- `ProgressService`: al terminar guarda `finishes` y `bestTimes` del nivel y suma `weekRuns`. `isUnlocked`: el nivel 1 siempre; el N si terminó el N-1. Atiende `LevelTravelRequested` (panel de niveles) y `LaunchPadRequested` (botón ¡LANZAR!: monta al jugador en la resortera de su nivel con `SlingshotService.mountAtLevel`; si está ocupada lo deja al lado en Idle) (D-021c).
- Para agregar un nivel: Folder con `LevelId`, y dentro `PlateauSpawn`, `Slingshot` (con `SeatPosition`, `DismountPosition`, `LaunchForward`), `FinishLine` y `ReturnPortal`; poner `DestinationLevel` en el portal del nivel anterior; agregarlo a `LEVELS` en `LevelsPanel`; al final, texturizar el suelo con `require(ServerStorage.DevTools.GroundTexturer:Clone())(nivel, semilla)` (obligatorio, D-025c).

## Resortera (servidor por encima; cliente del vault v1)
- `Shared.SlingshotGeometry` encuentra la resortera de un nivel y su asiento. `Shared.LaunchMath` calcula dirección, velocidad y trayectoria (lo usan servidor y cliente).
- `SlingshotService`: una estación por modelo con etiqueta `Slingshot`. Un ocupante a la vez. Subirse por ProximityPrompt (valida `MountValidationDistance`), lanzar por `LaunchRequested` (valida números y `LaunchValidationDistance`), bajarse por `DismountRequested`. Si no lanza en `AimTimeoutSeconds`, lo baja. Publica la puntería del ocupante en los atributos `AimYaw`, `AimPitch`, `AimPull` de la resortera (llegan por `AimChanged`) para que todos vean la liga.
- Cliente (`Client.Aim`): `AimModel` (estado), `AimInput` (mouse y arrastre), `AimCamera`, `TrajectoryPreview`, `SlingshotBandController` + `SlingshotBandView` (liga). Lo coordina `AimingMode`.

## Carrera (servidor leído entero; cliente del vault v1)
- La física corre en el cliente, dueño de su personaje. `RacingMode` coordina vuelo y deslizamiento con `SlideMotor` (velocidad, giro, salto, impulso), `GroundProbe`, `MoveInput`, `CrashSensor`, `BoostRampSensor`, `BodyMover` (control del cuerpo y ragdoll), `PenguinOrientation`. `RaceModel` lleva tiempo y velocidad para el HUD. `LocalCharacter` da acceso al personaje.
- `RaceService` (servidor): al entrar a Racing guarda la hora y el avance de meta del nivel. Cada `TrackerIntervalSeconds` revisa a cada corredor: si su avance sobre `TrackForward` pasa el de la `FinishLine` → Finished con el tiempo (o reinicio si tardó menos de `MinimumPlausibleSeconds`); si está bajo la altura mínima o sobre una parte `Hazard` → eliminado. La altura mínima es el atributo `KillHeight` del folder del nivel si lo tiene (N1: -220, D-023c), o `GameConfig.Race.KillHeight`.
- Eliminación: avisa por `RaceNotice` ("Eliminated", con `hazardKind`) y, tras `Crash.RagdollSeconds`, hace `LoadCharacter`. Tipos: `Fall`, `Crash`, o el `HazardKind` de la parte (`Pit`, `Water`).
- Choques: los detecta el cliente y los reporta por `CrashReported`; el servidor no valida el choque, solo limita la frecuencia.
- En la pista navideña (desde el 14, `RacingMode` leído por encima): al aterrizar del lanzamiento hay 1 s de invulnerabilidad (D-030c). Un choque no elimina; el cliente tumba al pingüino y lo endereza sobre la pista tras ~1 s (`_recoverAt`, se hace a un lado si hay algo enfrente), con invulnerabilidad breve. Las partes con atributo `Bumper` lo hacen rebotar (`_bounceOff`). `_assistSteer` gira la velocidad hacia `ChristmasTrack.guideDirection` (calle o atajo), más débil si el jugador está girando. Si se queda casi quieto más de ~1.3 s, lo endereza. `RaceService` pregunta a `ChristmasRunService` antes de eliminar por choque o `Hazard`.
- Ajustes por nivel y rampas (D-026c): `SlideMotor` toma `Slide.LevelTuning[nivel]` si existe. Hay valores para N1 (pista navideña, puestos el 14 sin registro) y para N5 (en respaldo, sin uso). Una cuña con atributo `KeepSpeed` no frena (sin arrastre; conserva y repone la velocidad al aterrizar); con `JumpDistance` además calcula el salto para caer a esa distancia.
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

## Pista navideña (ChristmasTrack y ChristmasRunService leídos enteros; ChristmasRunClient por encima; D-027c)
- `Shared.ChristmasTrack`: una sola definición de la pista que usan el constructor, el servidor y el cliente. Zonas (`Zones`: nombre, ícono, inicio, pendiente, color, premio), caídas (`Drops`), curvas (`xAt`), altura (`heightAt`), ancho (`widthAt`), marco y normal, progreso, zona en una Z, punto de rescate (`rescueFrame`) y atajos (`Shortcuts`, calculados al cargar el módulo donde cortan curva y ahorran distancia). Vida y daños: `MaxHealth`, `CrashDamage`, `FallDamage`, `ZoneHeal`, `FinishReward`.
- `ChristmasRunService` (servidor): al entrar a Racing crea la carrera con vida llena; no resta vida ni rescata hasta que el pingüino llega a la pista (≤ 8 studs sobre ella, o 8 s) y da 1 s más de gracia (D-030c); cada 0.1 s mira la Z del jugador para dar premio de peces y curar al entrar a una zona, y si cae más de 45 studs bajo la pista lo rescata (resta vida y manda `RaceNotice` "Rescue" con el punto). Publica `PenguinHealth`, `PenguinMaxHealth` y `RunZone` en el jugador. Al terminar da `FinishReward` más la mitad de la vida. `absorbCrash` y `absorbHazard` los llama `RaceService`.
- `ChristmasRunClient` (LocalScript suelto): HUD de la pista (zona, tiempo, progreso, velocidad, vida, avisos de premio) y efectos de tráfico y patrulla. Escucha `RaceNotice` (Zone, Damage, Rescue, FinishReward, OutOfHealth).
- `FishService` ahora usa `ChristmasTrack`: los peces de los carriles (`EconomyConfig.Fish.Lanes`) siguen las curvas y cada atajo lleva una fila de peces (cambio leído por encima).
- Constructores (no corren): `ServerStorage.ClaudeBuild.ChristmasKit`, `ChristmasBuild`, `ChristmasBuild2`, y `ChristmasObstacles` (D-031c: `build()` borra y rehace `ChristmasRun.ObstaculosPista`; reparte `Plan` por zona con la separación de `Spacing`, busca huecos libres con `ChristmasTrack` (y, si no, barre la zona) y revisa que no haya nada sólido en la calle; para correrlo hay que clonarlo dentro de `ClaudeBuild`, porque usa `script.Parent.ChristmasKit`).
- Obstáculos: cada uno tiene una caja `Hitbox` invisible y sólida sin `Bumper`, así que `RacingMode` lo trata como choque (quita vida); los montículos son cuñas que se suben sin chocar.

## Eventos (D-032c; EventService y RunEvents leídos enteros)
- `Shared.EventConfig`: todos los números de los eventos. `Shared.EventRemotes`: `EventPickupRequested` (cliente pide cobrar un regalo o el trineo dorado) y `RaceJoinRequested` (inscribirse o salir de la carrera programada).
- `Services.EventService` (en `EconomyMain`): reloj de eventos del servidor con la rotación `EventConfig.Server.Rotation` (desde D-033c solo `FishRain`; el código de `Avalanche` sigue ahí pero no sale) y los publica como atributos de `ReplicatedStorage` (`ServerEvent`, `ServerEventEndsAt`, `NextServerEvent`, `NextServerEventAt`). `fishMultiplier(jugador)` lo usan `FishService` y `ChristmasRunService`: x2 en la Nevada; x2 en la carrera de quien se lanzó durante la Avalancha (atributo del jugador `AvalancheEventRun`). Por carrera, cada 0.1 s: al llegar a la zona de Santa sortea regalos en carriles libres de obstáculos y avisa `SantaDrop`; si a la carrera le tocó trineo dorado (`GoldenSleigh`), lo lanza al entrar a su zona; en el Garaje manda a los duendes (`ElvesChase`/`ElvesCaught`/`ElvesEnd`) y calcula si te alcanzan. Carrera programada: `NextRaceAt` y `RaceEntrants`; a la hora pasa a los inscritos a Aiming y Racing con `RunStateService` desde el asiento de la resortera, en carriles; al llegar avisa `RaceResult` con lugar y premio. Avisos por `RaceNotice`; los premios mandan `EventReward` y el trineo `TurboReward`.
- `Client.RunEvents` (en `LobbyMain`): letreros y avisos de todos los eventos, y lo que se ve: trineo de Santa, regalos con sombra, trineo dorado, duendes, tormenta (sube la densidad de `Atmosphere`, nieve en la cámara y resalta los obstáculos de la zona), desfile de soldados (posiciones calculadas sin obstáculos cerca; cajas de choque locales que se mueven) y lluvia de peces. Todo vive en `Workspace.EventosLocales`.
- `RacingMode` aplica `TurboReward` con `SlideMotor.boost`. `AvalancheCinematic`: con `AvalancheEventRun` la ola no se queda atrás en toda la bajada. `LobbyHud`: el botón de arriba es el Modo Avalancha (§ Modo Avalancha); la tarjeta "Próxima carrera" muestra cuánto falta e inscritos, y N inscribe o saca.

## Avalancha (por encima; D-029c)
- `AvalancheCinematic` (cliente, en `LobbyMain`), en el nivel 1 y en el Modo Avalancha (nivel 2). Al entrar a Aiming reproduce una cinemática (se rompe la cornisa, cámara desde `ShotCamera`, letrero); en Racing una ola de nieve persigue al jugador; en Finished un cierre; en Idle limpia todo. Es visual: no elimina ni cambia la carrera.
- Mundo: `AvalancheMountain` (Folder con etiqueta, marcadores `WaveStart`, `WaveEnd`, `ShotCamera`, `Cornice`, `WatchTower`) y `AvalancheSiren`.
- Desde el 2026-11-14 (D-029c) la ola sigue `ChristmasTrack` (centro y tangente de la pista) en vez de ir recto en -Z. Tras `CHASE_SECONDS` se queda atrás (`FALL_BEHIND_SPEED`) y se desvanece en `FADE_SECONDS`; el cierre de la meta la vuelve a mostrar.

## Modo Avalancha (D-033c; escrito y probado en Play el 2026-11-14)
- `Shared.AvalancheTrack`: geometría del mapa (`LevelId` 2, recta en -Z con pendiente `Grade`, zonas, rampa y campo); `frameAtDistance`, `heightAtDistance`, `lipPosition`, `fieldTopY`. `Shared.AvalancheModeConfig`: números del modo y atributos `AvalancheModeReadyAt` y `AvalancheGap`.
- `Services.AvalancheModeService` (en `Server.Main`): remote `AvalancheModeRequested` (en `EventRemotes`). Revisa Idle o Finished y el turno de 12 h (`lastAvalancheMode` del perfil), te sube con `SlingshotService.mountAtLevel(2)` y guarda la hora. En Racing lleva la distancia de la avalancha cada 0.1 s (crece sola, baja si vas lento) y la publica en `AvalancheGap`; pide streaming adelante (`RequestStreamAroundAsync` solo sirve en el servidor). `absorbCrash` (lo llama `RaceService`): primer choque deja la distancia en `HitGap` y avisa `AvalancheHit`; otro con la distancia bajo `SecondHitGap` avisa `AvalancheCaught` y termina. Pasando el borde de la rampa avisa `AvalancheJump`; al tocar el campo calcula la marca, paga y avisa `AvalancheLanding`. Al volver a Idle desde el modo te manda al nivel 1.
- `RacingMode`: en el nivel 2 un choque con algo de `AvalancheMode.Obstacles` frena, apaga la colisión de esa parte en el cliente por `HitPassThroughSeconds` y reporta `CrashReported`; sin voltereta. Otros choques del nivel se ignoran.
- `Client.AvalancheModeClient` (presentador, en `LobbyMain`) con `AvalancheMode.AvalancheModeModel` y `AvalancheModeView` (MVP): HUD (km/h, recorrido, barra de la avalancha, peces ganados), tormenta (sube la densidad de `Atmosphere` y nieve), aura (`Highlight`) en los obstáculos cercanos y letreros de los avisos.
- `AvalancheCinematic` en el modo: la ola sigue recto a la distancia `AvalancheGap` y el temblor se multiplica por `ShakeMultiplier`. `ChristmasRunClient` no se muestra en el nivel 2. `ProgressService` no deja viajar al nivel 2. `FishService` usa `EconomyConfig.Fish.LevelOverrides`, termina en la parte `FishEnd` y valida con margen por velocidad.
- Lección: a 450 km/h el borde fino de una `WedgePart` deja pasar al pingüino por debajo; la rampa es un bloque grueso enterrado en la calle. Los obstáculos y el final son `Persistent` para que estén cargados al llegar.
- Constructor: `ClaudeBuild.AvalancheModeBuild` (→ [[nivel-2]] § Reconstrucción).

## Ventanas de N5 (por encima; sin decisión de Angel → Q-25)
- N5 está en respaldo desde el 2026-11-14: `WindowBreaker` sigue en el cliente pero no encuentra ventanas. `WindowBreaker` (cliente, solo nivel 5): durante Racing rompe los modelos `BreakableWindow` que el pingüino atraviesa (astillas, sonido, letrero "¡CRASH!"), lleva un contador contra el atributo `WindowCount` del nivel y vuelve casi transparentes las partes `HouseShell` de la casa que se está cruzando (cada casa tiene `HouseIndex`, `DisplayName`, `WorldZMin`, `WorldZMax`). Al volver a Idle o Aiming restaura las ventanas. No usa remotes: no da peces ni cuenta en el servidor.

## Ayudas
- `StepAssist` (leído entero): mientras camina (Idle o Finished) levanta al pingüino en escalones bajos, porque sus patas cortas no los suben.

## Restos en ServerStorage (no corren en el juego → Q-14)
- `ClaudeBuild.BuildLobby`, `ClaudeBuild.BuildLevel2Festival`, `BuildStalls`, `BuildAvalancheMountains`: constructores de mapa de un solo uso. `ClaudeBuild.ChristmasKit`, `ChristmasBuild` y `ChristmasBuild2` construyeron la pista navideña (§ Pista navideña).
- `Respaldo_MapaViejo` (desde el 2026-11-14): N2–N5 (`Niveles2a5`), la pista vieja de N1 (`Nivel1_Bajada`, `Nivel1_Bajada_Terrain`), la decoración festiva quitada (`Nivel1_Festive_*`), y `ChristmasTrack_v1_old` (primera versión del módulo de la pista). Todo descartado (D-027c); se puede borrar. La avalancha ya no está aquí: volvió al juego (D-029c).
- `ClaudeScriptDump`: volcado de texto de scripts del cliente, de una versión anterior.
- `PluginCurves`: carpeta vacía.
- `MountainLookBackup`, `CuteReplacedBackup`, `LobbyDecorBackup`, `LobbyQuitado`: respaldos de piezas reemplazadas o quitadas del lobby el 2026-11-13 (Q-14). `CuteModels`: modelos fuente de la decoración "cute" y de Blender.
- `DevTools.PlaceMap`: generador de [[mapa-place]] y [[valores]]. Se queda.
- `DevTools.GroundTexturer`: pone parches de tonos de blanco o azul hielo, sin colisión, en el suelo de la pista de un nivel (carpeta `GroundTexture`, franja de ±100 alrededor de la resortera). Se queda; se usa en cada nivel nuevo (D-025c).
- En Workspace, fuera de los niveles: `Baseplate` y un `SpawnLocation` desactivado.
