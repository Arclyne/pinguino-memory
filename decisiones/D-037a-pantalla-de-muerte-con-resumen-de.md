---
tipo: decision
id: D-037a
fecha: 2026-11-14
autor: angel
estado: vigente
tema: carrera, gui
---
# D-037a · Pantalla de muerte con resumen de la bajada
- Angel decidió (2026-11-14): al morir el pingüino no se relanza sin más; sale una pantalla de muerte con el resumen de tu bajada.
- Claude eligió (sin aprobar): solo en la pista navideña. Título "¡TE QUEDASTE SIN VIDA!", causa (choque o caída), zona alcanzada, barra de recorrido, tiempo, peces ganados en la bajada, velocidad máxima y golpes (choques y caídas). Botones REINTENTAR (vuelve a la resortera) y LOBBY; teclas R y L, A y B en control. Aparece a los `GameConfig.Death.ScreenDelaySeconds` para que se vea el tumbo; si no eliges, vuelves al lobby a los `GameConfig.Death.AutoReturnSeconds`. El pingüino se queda tirado (anclado) detrás de la pantalla. El HUD de la pista se oculta.
- descartado: que el servidor monte en la resortera al reintentar (el cliente no alcanzaba a tener el personaje nuevo y se quedaba sin cámara de resortera); lo pide el cliente.
- dónde vive: `DeathService`, `RunStatsService`, `ChristmasRunService.closeRun`, `Client.DeathScreenClient` y `Client.DeathScreen` → [[sistemas]] § Pantalla de muerte.
- abierto: récord personal de distancia (pediría un campo nuevo en el perfil); el Modo Avalancha sigue sin pantalla de muerte.
