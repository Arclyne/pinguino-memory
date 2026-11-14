---
tipo: nivel
nivel: 5
nombre: Vecindario Navideño
folder: ServerStorage.Respaldo_MapaViejo.Niveles2a5
origen_x: 24000
base_y: 1200
verificado: 2026-11-14 (el folder del nivel está en ServerStorage.Respaldo_MapaViejo.Niveles2a5; lo demás es como estaba en el juego)
---
# Nivel 5 · Vecindario Navideño

**Descartado (D-027c):** desde el 2026-11-14 el juego solo tiene la pista navideña. El folder sigue guardado en `ServerStorage.Respaldo_MapaViejo.Niveles2a5`. Esta ficha describe cómo era.

Apareció en la place el 2026-11-13 entre las 02:25 y las 06:50, sin bitácora, decisión ni artefacto en el vault → Q-25. Todo lo de abajo sale de leer la place; falta lo que Angel pidió y aprobó.

Coordenadas reales: `grep -n "N5" place/mapa-place.md`.

## Lo que hay en Studio
- Nombre en el panel de niveles: "VECINDARIO NAVIDEÑO".
- Es el nivel más grande: ~19,400 instancias. Carpetas: `Houses`, `Yards`, `Street`, `Decoration`, `Mountains`, `Terrain`, `Hazards`, `Gameplay`.
- 18 casas (modelos `HouseNN` en `Houses`), cada una con nombre visible del tipo "Casa 8/18 · Comedor, Recámara". La pista pasa por dentro de las casas.
- 36 ventanas rompibles (`BreakableWindow`): el pingüino las atraviesa y se rompen, con contador en pantalla. Es solo visual → [[sistemas]] § Ventanas de N5.
- Las paredes de la casa que se está cruzando se vuelven casi transparentes (`HouseShell`) para que se vea al pingüino.
- 26 barreras `TrackBarrier` en `Gameplay`, 6 partes `Hazard` (`Pit`), 20 partes `PulseGlow` y 2 `SpinningDecor`.
- Misma base que N4 (Y 1200). La meta está en Z 4546 y el portal en Z 4665: pista de ~4,550 studs, un 32 % más larga que la de N4.
- El portal no tiene `DestinationLevel`: el nivel se repite (Q-03). El portal de N4 ahora lleva aquí.
- Sin rampas de impulso.
- Más rápido que los demás niveles y sus rampas no frenan; las del jardín te saltan el obstáculo del centro de cada casa (D-026c). Quedan para esquivar los del segundo cuarto (tren, regalos, trineo, banco).

## Sin saber
Qué pidió ciervo, qué artefacto se aprobó, zonas y obstáculos previstos, y si las ventanas deben dar peces o puntos.

## Sin probar
Bajada completa jugada a mano (solo hubo bajadas de prueba sin girar, D-026c).

## Suelo (D-025c)
`GroundTexture`: parches sin colisión en tonos de blanco o azul hielo sobre la franja de la pista, hechos con `DevTools.GroundTexturer`.
