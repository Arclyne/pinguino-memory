---
tipo: diseno
estado: borrador
version: v0.1
actualizado: 2026-11-11
---
# Mapa

Plano interactivo v0.1 (planta, perfil y detalle del río): https://claude.ai/artifact/SGTq2gWD7CCYxDYdQzFZW3

Construido en Studio con `05 Técnico/BuildMap_v01.lua` (se puede volver a correr: borra y reconstruye `Workspace.PenguinSlingshotMap_v01`). En Studio, Z del plano = -Z del mundo, X = X, elevación = Y.

Medidas en studs (1 stud ≈ 0.28 m). **Z** = distancia de bajada desde el borde de la meseta. **X** = posición lateral (A = X negativa, D = X positiva).

## Lo decidido #decidido
Ver [[D-002 Mapa base y controles]].
- Spawn en una meseta plana y amplia; abajo, la pendiente.
- Obstáculos: piedras, troncos tirados, árboles.
- A / D para moverse de lado, Espacio para saltar.
- Un río con bloques de hielo que sobresalen.

## Propuesta de Claude #idea
| Zona | Z | Largo | Pendiente | Ancho | Obstáculos |
|---|---|---|---|---|---|
| Meseta de spawn | -160–0 | 160 | 0° | 240 | spawn, fila, resortera al borde |
| Acantilado | 0–20 | 20 | caída de 40 | — | — |
| Aterrizaje | 20–200 | 180 | 15° | 120 | ninguno (zona de 140 × 90) |
| 1 · Ladera de piedras | 200–520 | 320 | 18° | 120 | piedras, troncos, pinos en los bordes |
| 2 · Bosque nevado | 520–900 | 380 | 20° | 120 | pinos, troncos, tocones, arbusto, montículo |
| 3 · Río de témpanos | 900–1000 | 100 | plano | 120 | río de 70, 3 filas de témpanos 10 × 10, huecos de 10 |
| 4 · Cañón de hielo | 1000–1400 | 400 | 22° | 80 | rocas grandes, picos de hielo, grietas |
| 5 · Campamento abandonado | 1400–1650 | 250 | 15° | 120 | cercas rotas, barriles, trineo, muñecos de nieve, cabaña (decoración) |
| Meta y frenado | 1650–1800 | 150 | 5° | 120 | arco de meta en Z 1700, portal de regreso |

- Pista: 1,780 studs en horizontal, ~1,868 sobre la superficie, 532 de desnivel. Unos 37 s por bajada a 50 studs/s.
- Checkpoints: CP1 (Z 890), CP2 (Z 1005), CP3 (Z 1405).
- Regla de alturas: lo saltable mide ≤ 4 studs y lo que solo se esquiva mide ≥ 9 (el salto por defecto de Roblox es de 7.2).
- Pingüino supuesto de 3 × 3 × 4. Los pasillos más angostos miden 11.

## Por definir #pendiente
- Qué pasa si el pingüino cae fuera de la pista al lanzarlo.
- Velocidad mínima para cruzar el río (la terraza es plana y frena).
- Qué pasa al caer al agua.
- Duración deseada de la bajada.
- Posición del cañón (a media bajada o al final).

Relacionado: [[Resortera]] · [[Deslizamiento]] · [[Obstáculos]] · [[Core Loop]]
