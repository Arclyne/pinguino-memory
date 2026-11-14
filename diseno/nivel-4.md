---
tipo: nivel
nivel: 4
nombre: Valle del Avión
folder: ServerStorage.Respaldo_MapaViejo.Niveles2a5
origen_x: 18000
base_y: 1200
verificado: 2026-11-14 (el folder del nivel está en ServerStorage.Respaldo_MapaViejo.Niveles2a5; lo demás es como estaba en el juego)
---
# Nivel 4 · Valle del Avión

**Fuera del juego desde el 2026-11-14:** el folder se movió a `ServerStorage.Respaldo_MapaViejo.Niveles2a5` cuando la pista navideña reemplazó a N1–N5 (Q-26c). Esta ficha describe cómo era.

Coordenadas reales: `grep -n "N4" place/mapa-place.md`. Prototipo v0.1: https://claude.ai/artifact/Bxwqqn5e8k3QCZm88kLtTZ · ciervos: https://claude.ai/artifact/2L3DA96QXd9at5psH9EU9n

## Angel decidió (D-012)
- Ambientado en un choque de avión. El avión es decoración; el pingüino no interactúa con él.
- En la pista sí hay restos del avión y obstáculos coherentes con el lugar.
- Hay ciervos como obstáculo, con nieve en el lomo como en su referencia.
- Un 30 % más largo que el nivel 3.

## Zonas (Claude eligió)
Pista de ~3,540 studs, baja ~1,000 (por eso la base está a Y 1200). 13 zonas, 2 caídas, 3 grietas con banderines rojos.

| # | Zona | Z | Pendiente |
|---|---|---|---|
| 1 | Cumbre de salida (spawn, letrero, resortera) | -140–0 | plano |
| 2 | Caída | 0–20 | -40 |
| 3 | Ladera de llegada | 20–250 | 14° |
| 4 | Campo de restos + grieta del ala (Z 766; puente: trozo de ala a la izquierda) | 250–790 | 16° |
| 5 | Bosque de los ciervos | 790–1320 | 18° |
| 6 | Lago congelado | 1320–1480 | 4° |
| 7 | Cañón de la cola (pista más angosta) | 1480–1940 | 20° |
| 8 | Escalón de roca | 1940–1960 | -25 |
| 9 | Ladera de las rocas + segunda grieta (Z 2206; salto obligatorio) | 1960–2420 | 15° |
| 10 | Campamento de rescate | 2420–2900 | 12° |
| 11 | Valle final + tercera grieta (Z 3236; puente de nieve a la derecha) | 2900–3380 | 16° |
| 12 | Meta (arco naranja, Z 3440) | 3380–3490 | 7° |
| 13 | Zona plana y portal (Z 3530) | 3490–3560 | plano |

- Avión genérico: fuselaje blanco con franja azul y roja, sin nombre ni logotipo.
- Restos para saltar: asientos, maletas, placas, trozos de ala. Para esquivar: turbinas, trenes de aterrizaje, hélices, puertas, contenedores.
- Otros para saltar: rocas bajas, troncos, trozos de hielo, cajas, trineos. Para esquivar: rocas grandes, pinos, casas de campaña, motonieves, antena, banderas.
- Ciervos (todos para esquivar, quietos, sin script): macho 11×4×17.5, cierva 9.6×3.6×11.6, cervatillo 6.8×2.6×8.4.
- Peligros: 7 partes `Hazard` (`Pit`): las 3 grietas y el piso del valle.
- Sin rampas de impulso (Q-04). El portal lleva a N5 (`DestinationLevel = 5`).
- Las montañas se corrigieron en Studio: las primeras salieron como torres delgadas.

## Sin probar
La pista completa y los saltos de las grietas → Q-10. Animar los ciervos → Q-11.

## Reconstrucción
`archivo/construccion/BuildLevel4_v01.lua`. La resortera se clona con +600 en Y y sus atributos de asiento llevan el mismo desplazamiento.

## Suelo (D-025c)
`GroundTexture`: parches sin colisión en tonos de blanco o azul hielo sobre la franja de la pista, hechos con `DevTools.GroundTexturer`.
