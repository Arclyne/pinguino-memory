---
tipo: nivel
nivel: 1
nombre: Pista navideña
folder: Workspace.PenguinSlingshotMap_v01
origen_x: 0
base_y: 600
verificado: 2026-11-14 (leído en Studio en modo edición: ChristmasTrack, ChristmasRunService y carpetas; no se jugó)
---
# Nivel 1 · Pista navideña

Coordenadas reales, etiquetas y carpetas: `grep -n "N1" place/mapa-place.md`. Z del plano = -Z del mundo.

Desde el 2026-11-14 el N1 es una sola bajada larga, `ChristmasRun`, hecha sin registro en el vault (Q-26c). La pista anterior "Pico Pingüino" (D-009, D-023c) está en `ServerStorage.Respaldo_MapaViejo.Nivel1_Bajada`. Nada de esta ficha está aprobado todavía.

## Lo que hay en Studio
- La meseta de spawn, el lobby (D-014), la resortera y el portal no cambiaron. La bajada empieza en Z -20 (Y 556) y la meta está en Z -16370 (Y ≈ -3569): ~16,350 studs de largo y ~4,100 de desnivel. Portal en Z -16648; lleva al mismo N1.
- La forma la define `Shared.ChristmasTrack`: pendiente por zona más 16 "caídas" más empinadas (`Drops`), curvas de dos ondas de hasta ±230 en X, calle de `ChristmasTrack.RoadWidth` con barandales suaves (la Autopista es más ancha). Detalle técnico → [[sistemas]] § Pista navideña.
- `KillHeight` del folder: -7000.

| Zona | Empieza a (studs) | Pendiente | Premio (peces) |
|---|---|---|---|
| 1 Colina Nevada | 0 | 0.22 | — |
| 2 Bosque de Bastones | 1950 | 0.26 | 20 |
| 3 Pueblo Navideño | 3750 | 0.22 | 25 |
| 4 Centro de la Ciudad | 5850 | 0.22 | 30 |
| 5 Garaje de Santa | 7950 | 0.28 | 35 |
| 6 Taller de Juguetes | 9300 | 0.24 | 40 |
| 7 Autopista Polar | 11400 | 0.24 | 45 |
| 8 Puente del Puerto | 14250 | 0.16 | 60 |
| Meta Aldea de Santa | 16350 | 0.07 | 200 + vida/2 |

- Cada zona tiene carpeta `Zona<N>_<Nombre>` con edificios, faroles, pinos, puestos, `Obstaculos` y `Gameplay` (pads de turbo `BoostRamp`). 4,527 partes con atributo `Bumper` (rebotan sin chocar).
- `Atajos`: 10 caminos rectos de 22 de ancho que cortan por dentro de las curvas (pinos, hielo, callejón, parque, juguetes, salto), algunos con turbo y rampas de salto. Ninguno en el Garaje ni en el Puente.
- Vida: 100; choque −25, caída −20 (te rescata sobre la pista), +35 al entrar a cada zona. Sin vida, eliminado.
- Peces en 5 carriles (`EconomyConfig.Fish.Lanes`).

## Suelo
Sin `GroundTexture`: la ladera `Ground` y la calle son lisas → T-13c (D-025c).

## Sin probar
Todo: no hay una bajada registrada → T-14c.

## Resortera (modelo v0.2, se clona a los demás niveles)
- Prototipo: https://claude.ai/artifact/DZuHEQHahKa4aUhb15QQTH
- Plataforma octagonal de piedra 24×4×24, tronco 6×13×6, horquilla 12×5×7, brazos 5×16×5 inclinados 18°, altura total ≈ 41. Liga doble roja. Alrededor: escalones, cajas, farol, bandera, letrero y pingüinos en fila.
- En Studio: `Slingshot` (etiqueta y atributos de asiento), `SlingshotDecor`, `WaitingPenguins`.
- El artefacto usa otros controles y valores que el juego; mandan D-005 y `GameConfig.Slingshot`.

## Decoración festiva (D-013)
- Artefacto: https://claude.ai/artifact/YGbXEhC78CCans6p68xAeE
- En `FestiveDecoration` quedan solo restos (~1,000 instancias, sobre todo en la meseta); casi todo se movió a `ServerStorage.Respaldo_MapaViejo` (`Nivel1_Festive_*`) junto con la pista vieja.

## Portal
- Estilo Hielo: https://claude.ai/artifact/N9dQzZxestQoVsSauFWXXW · `ReturnPortalGate`. Ahora está al final de la pista navideña y lleva al mismo N1.

## Avalancha
- La montaña, la sirena y la cinemática están en `ServerStorage.Respaldo_MapaViejo.Avalancha`: ya no corren (Q-02, Q-26c).

## Lobby
Objetos y paneles: [[lobby-economia]].

## Reconstrucción
- Pista navideña: `ServerStorage.ClaudeBuild.ChristmasKit` (piezas), `ChristmasBuild` (zonas 1–8 y meta) y `ChristmasBuild2` (suelo, calle, atajos, mundo). No están en el vault.
- Pista vieja: `archivo/construccion/` (`BuildMap_v01.lua` y siguientes) o el respaldo en ServerStorage.
