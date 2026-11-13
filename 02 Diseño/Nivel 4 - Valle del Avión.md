---
tipo: diseno
nivel: 4
version: v0.1
actualizado: 2026-11-12
---
# Nivel 4 · Valle del Avión

- Prototipo 3D v0.1: https://claude.ai/artifact/Bxwqqn5e8k3QCZm88kLtTZ
- Ciervos v0.1: https://claude.ai/artifact/2L3DA96QXd9at5psH9EU9n

## Lo que pidió Angel #decidido
- Ambientado en un choque de avión. El avión es decoración y el pingüino no interactúa con él.
- En la pista sí hay restos del avión, además de obstáculos coherentes con el lugar.
- Hay ciervos como obstáculo, con nieve en el lomo como en su referencia.
- Mide un 30 % más que el [[Nivel 3 - Ciudad Nevada]]. Cada nivel será más largo y complejo, pero pasable.

## Propuesta de Claude #idea
- Pista de ~3,540 studs (nivel 3: ~2,740, o sea +29 %). Es una ladera de montaña con 13 zonas, 2 caídas y 3 grietas que piden salto.
- El avión es genérico: fuselaje blanco con franja azul y roja, sin nombre ni logotipo. Está a la izquierda del campo de restos. La cola queda sobre una cornisa del cañón y un ala está clavada a la derecha.
- Las grietas tienen banderines rojos. La primera tiene un trozo de ala como puente a la izquierda, la tercera un puente de nieve a la derecha, y la segunda es salto obligatorio.

| # | Zona | Z | Pendiente |
|---|---|---|---|
| 1 | Cumbre de salida (spawn, letrero "VALLE DEL AVIÓN", resortera) | -140–0 | plano |
| 2 | Caída | 0–20 | -40 |
| 3 | Ladera de llegada | 20–250 | 14° |
| 4 | Campo de restos (fuselaje al lado) + grieta del ala (Z 766) | 250–790 | 16° |
| 5 | Bosque de los ciervos | 790–1320 | 18° |
| 6 | Lago congelado | 1320–1480 | 4° |
| 7 | Cañón de la cola (paredes de roca, pista más angosta) | 1480–1940 | 20° |
| 8 | Escalón de roca | 1940–1960 | -25 |
| 9 | Ladera de las rocas + segunda grieta (Z 2206) | 1960–2420 | 15° |
| 10 | Campamento de rescate | 2420–2900 | 12° |
| 11 | Valle final + tercera grieta (Z 3236) | 2900–3380 | 16° |
| 12 | Meta (arco naranja "¡META!") | 3380–3490 | 7° |
| 13 | Zona plana y portal | 3490–3560 | plano |

- **Restos del avión en la pista:**
  - Para saltar: asientos, maletas, placas y trozos de ala.
  - Para esquivar: turbinas, trenes de aterrizaje, hélices, puertas y contenedores.
- **Otros obstáculos:**
  - Para saltar: rocas bajas, troncos y trozos de hielo.
  - Para esquivar: rocas grandes y pinos.
  - En el campamento de rescate: casas de campaña, motonieves, antena y banderas para esquivar; cajas y trineos para saltar.
- **Ciervos** (todos para esquivar):

  | Ciervo | Medidas (studs) |
  |---|---|
  | Macho | 11×4×17.5 |
  | Cierva | 9.6×3.6×11.6 |
  | Cervatillo | 6.8×2.6×8.4 |

  No caminan; solo mueven la cabeza (pastan y miran), las orejas y la cola.
- Hay dos ambientes de prueba: Despejado y Nevada.
- La pista baja ~1,000 studs en total. En Studio habrá que subir la base, porque a Y 600 terminaría bajo `KillHeight`.

## En Studio #decidido
- Angel lo aprobó y se construyó en X +18000, con la base a Y 1200 → [[D-012 Nivel 4 en Studio]]

## Pendiente #pendiente
- Recorrer la pista completa con la resortera y ajustar los saltos de las grietas.
- Animar los ciervos (cabeza, orejas y cola) con un script ligero, si Angel lo quiere.
