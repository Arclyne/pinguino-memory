---
tipo: nivel
nivel: 5
nombre: Vecindario Navideño
folder: Workspace.PenguinSlingshotMap_Level5
origen_x: 24000
base_y: 1200
verificado: 2026-11-13 (solo lo que se ve en Studio en modo edición; sin diseño ni decisión en el vault; no se jugó)
---
# Nivel 5 · Vecindario Navideño

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

## Sin saber
Qué pidió ciervo, qué artefacto se aprobó, zonas y obstáculos previstos, y si las ventanas deben dar peces o puntos.

## Sin probar
Todo: nadie ha registrado una bajada en este nivel (Q-10).
