---
tipo: diseno
estado: borrador
version: v0.1
actualizado: 2026-11-11
---
# Nivel 2 · Aldea Nevada

Prototipo 3D v0.1: https://claude.ai/artifact/6z7kcVWzGs71pw1BT4y2ed

## Lo decidido #decidido
- Inspirado en una foto de aldea nevada: casas de madera con techos de nieve gruesa, faroles rojos y postes con "hongo" de nieve.
- La aldea es solo visual: el pingüino no interactúa con las casas.
- Todo con textura stud.
- Misma lógica del juego: resortera, bajada con obstáculos, zona plana y portal.

## Propuesta de Claude #idea
| # | Zona | Z | Pendiente | Obstáculos |
|---|---|---|---|---|
| 1 | Meseta y entrada | -140–0 | 0° | puerta "ALDEA NEVADA", resortera, fila |
| 2 | Caída | 0–20 | caída de 40 | — |
| 3 | Llegada a la aldea | 20–180 | 14° | ninguno |
| 4 | Calle de los postes nevados | 180–520 | 17° | postes con hongo de nieve, cercas bajas, leña |
| 5 | Pabellón de los faroles | 520–640 | 12° | 3 kioscos con techo de nieve sobre la pista; pilares interiores en X ±20 dividen 3 carriles |
| 6 | Mercado nevado | 640–900 | 18° | carretas, barriles, trineos, faroles, bolas de nieve, muñeco; cuerdas de faroles muy arriba |
| 7 | Arroyo congelado | 900–1000 | 3° | hielo resbaloso, trozos de hielo, puente-rampa |
| 8 | Bosque de la aldea | 1000–1300 | 20° | pinos, postes, tronco de lado a lado, leña |
| 9 | Puerta de salida y meta | 1300–1420 | 8° | puerta roja "¡META!" en Z 1380 |
| 10 | Zona plana y portal | 1420–1490 | 0° | portal de hielo en Z 1460 |

- Regla de alturas igual que el nivel 1: ≤ 4 se salta, ≥ 9 se esquiva.
- Casas a los lados fuera de los bancos (|X| ≥ 92), con mazorcas, leña, chimeneas, ventanas encendidas y faroles.

## Por definir #pendiente
- Qué tan largo debe ser el nivel 2 comparado con el 1
- Si el hielo del arroyo cambia la física (más resbaloso)
- Estilo del portal del nivel 2 (igual al del nivel 1 o con toque de aldea)

Relacionado: [[Mapa]] · [[Obstáculos]]
