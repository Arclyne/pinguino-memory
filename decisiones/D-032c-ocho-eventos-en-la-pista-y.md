---
tipo: decision
id: D-032c
fecha: 2026-11-14
autor: ciervo
estado: vigente
tema: eventos
---
# D-032c · Ocho eventos en la pista y en el servidor
- Ciervo decidió: agregar los 8 eventos que propuso Claude: Santa soltando regalos, tormenta de nieve, desfile de juguetes, duendes que persiguen, trineo dorado, evento Avalancha programado, carrera programada y nevada de peces. Con esto dejan de ser fachada los botones "Evento Avalancha" y "Próxima carrera".
- porqué: no lo dijo.
- Claude eligió (sin aprobar): todos los números de `Shared.EventConfig` (tiempos, premios, distancias, castigos). Los premios los da el servidor: Santa y el trineo dorado se cobran con `EventPickupRequested` y el servidor compara con su propia posición del regalo o del trineo (con margen por la velocidad); los duendes los calcula el servidor. Evento Avalancha y Nevada de peces se alternan para todo el servidor (x2 a todos los peces: en Avalancha solo para quien se lanza durante el evento). Carrera programada: inscripción con N, a la hora todos salen juntos desde la resortera en carriles y los 3 primeros ganan premio. Los duendes te alcanzan como máximo 3 veces por bajada, con pausa de 3 s, y te quitan pocos peces, nunca vida. Desfile y tormenta son solo del cliente; los soldados tienen caja de choque (quitan vida como un obstáculo).
- descartado: duplicar los peces que hay en la pista durante la nevada (se duplica su valor, que es lo mismo para el jugador).
- dónde vive: `Services.EventService`, `Shared.EventConfig`, `Shared.EventRemotes`, `Client.RunEvents`, y cambios en `LobbyHud`, `InfoPanel`, `AvalancheCinematic`, `RacingMode`, `FishService`, `ChristmasRunService` → [[sistemas]] § Eventos.
- cambio (2026-11-14): el evento Avalancha programado se quitó; el reloj del servidor solo tiene la Nevada de peces y el botón de arriba es el Modo Avalancha (D-033c).
