---
tipo: decision
id: D-071c
fecha: 2026-11-22
autor: ciervo
estado: vigente
tema: gui
---
# D-071c · Tutorial en pantalla la primera vez
- Ciervo decidió (2026-11-22): agregar un tutorial básico en pantalla sobre las mecánicas, las resorteras y los peces, al estilo de sus referencias (mano que señala, fondo oscurecido, letrero grande).
- porqué: un jugador nuevo no sabe qué hacer.
- Claude eligió (sin aprobar): sale una sola vez por jugador (se guarda `tutorialDone` en el perfil; remoto `TutorialFinished`) y se puede saltar. 8 pasos:
  1. Bienvenida (¡VAMOS!).
  2. Peces: resalta el contador; los ganas con el regalo diario, la ruleta, el Modo Avalancha y la nevada de peces.
  3. Resorteras: resalta el botón; se compran con peces y lanzan más lejos.
  4. ¡A volar!: mano sobre ¡LANZAR!; sigue al subirte a la resortera.
  5. Tensa la resortera: mano que arrastra hacia atrás; sigue al salir volando.
  6. Muévete: A / D o flechas, cada choque quita vida (sigue al girar o a los 8 s).
  7. En la pista: rampas, botiquines y huevos (7 s).
  8. ¡Listo! (4 s).
  Los pasos del lobby oscurecen todo menos lo que señalan; los de la carrera van en una tarjeta a la izquierda sin oscurecer. Si mueres a mitad, se da por terminado. Mano con emoji, animación suave (sin parpadeos, D-070c).
- probado en Play: los 8 pasos, se guarda y no vuelve a salir al entrar otra vez. A la cuenta de ciervo ya le salió y quedó marcada.
- dónde vive: `Client.TutorialClient` (presentador), `Client.Tutorial.TutorialSteps` (pasos), `Client.Tutorial.TutorialView` (vista), `Services.TutorialService`, `Data.PlayerProfile` (`tutorialDone`), `PlayerDataService.snapshot`, `Shared.EconomyRemotes`, `LobbyHud` (nombres `LaunchButton`, `SlingshotTile`, `FishCounter`) → [[juego]].
