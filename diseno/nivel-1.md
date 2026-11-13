---
tipo: nivel
nivel: 1
nombre: Pico Pingüino
folder: Workspace.PenguinSlingshotMap_v01
origen_x: 0
base_y: 600
verificado: 2026-11-13 (existencia y coordenadas en Studio; no se jugó completo)
---
# Nivel 1 · Pico Pingüino

Coordenadas reales, etiquetas y carpetas: `grep -n "N1" place/mapa-place.md`. Z del plano = -Z del mundo.

## Angel decidió (D-009)
Meseta de spawn plana y amplia; abajo la pendiente. Piedras, troncos tirados y árboles. Un río con bloques de hielo que sobresalen. La meseta es además el lobby (D-014).

## Zonas (Claude eligió; plano v0.1)
Plano: https://claude.ai/artifact/SGTq2gWD7CCYxDYdQzFZW3 · medidas en studs · X negativa = A, X positiva = D.

| Zona | Z | Pendiente | Ancho | Obstáculos |
|---|---|---|---|---|
| Meseta de spawn | -160–0 | 0° | 240 | spawn, fila, resortera al borde, lobby |
| Acantilado | 0–20 | caída de 40 | — | — |
| Aterrizaje | 20–200 | 15° | 120 | ninguno |
| Ladera de piedras | 200–520 | 18° | 120 | piedras, troncos, pinos en los bordes |
| Bosque nevado | 520–900 | 20° | 120 | pinos, troncos, tocones, arbusto, montículo (rampa de impulso) |
| Río de témpanos | 900–1000 | plano | 120 | río de 70, 3 filas de témpanos 10 × 10 |
| Cañón de hielo | 1000–1400 | 22° | 80 | rocas grandes, picos de hielo, grietas |
| Campamento abandonado | 1400–1650 | 15° | 120 | cercas rotas, barriles, trineo, muñecos de nieve |
| Meta y frenado | 1650–1800 | 5° | 120 | arco de meta en Z 1700 |
| Zona plana final (Angel decidió) | 1800–1870 | plano | 120 | portal en Z 1850; muro y cerca al final |

- Pista de ~1,780 studs en horizontal, 532 de desnivel.
- Los checkpoints del plano v0.1 se quitaron (D-008).
- Peligros: el río (`HazardKind = Water`) y 2 grietas (`Pit`).

## Resortera (modelo v0.2, se clona a los demás niveles)
- Prototipo: https://claude.ai/artifact/DZuHEQHahKa4aUhb15QQTH
- Plataforma octagonal de piedra 24×4×24, tronco 6×13×6, horquilla 12×5×7, brazos 5×16×5 inclinados 18°, altura total ≈ 41. Liga doble roja. Alrededor: escalones, cajas, farol, bandera, letrero y pingüinos en fila.
- En Studio: `Slingshot` (etiqueta y atributos de asiento), `SlingshotDecor`, `WaitingPenguins`.
- El artefacto usa otros controles y valores que el juego; mandan D-005 y `GameConfig.Slingshot`.

## Decoración festiva (D-013)
- Artefacto: https://claude.ai/artifact/YGbXEhC78CCans6p68xAeE
- `FestiveDecoration`: Entrance, Crowd, Lights, Crystals, WildlifeAndWaterfall, LivelyCamp, FinishParty, Landscape. Todo fuera de la pista o sin colisión.
- Contenido: arco "PICO PINGÜINO", iglús, puesto de chocolate, gradas con pingüinos, diana de aterrizaje, faroles, guirnaldas, pinos con foquitos, cristales, cascada congelada, focas, fogata, arco de globos, podio, fuegos artificiales, montañas, castillo de hielo, aurora.

## Portal
- Estilo Hielo: https://claude.ai/artifact/N9dQzZxestQoVsSauFWXXW · `ReturnPortalGate`, se clona a los demás niveles. Lleva a N2.

## Avalancha
- `AvalancheMountain` (montaña detrás de la meseta, con cornisa, torre y sirena) y una cinemática al subirse a la resortera. Sin decisión ni diseño en el vault → Q-02. Detalle técnico: [[sistemas]] § Avalancha.

## Lobby
Objetos y paneles: [[lobby-economia]].

## Reconstrucción
`archivo/construccion/`: `BuildMap_v01.lua` → `BuildSlingshot_v02.lua` → `BuildFinishPlaza_v01.lua` → `BuildReturnPortal_v01.lua` → `BuildLevel1Decoration_v01.lua` → `InstallBoostRamps_v01.lua`. `BuildMap` borra y reconstruye el folder: se pierden lobby, avalancha y etiquetas puestas después.
