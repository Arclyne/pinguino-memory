---
tipo: nivel
nivel: 2
nombre: Aldea Nevada
folder: ServerStorage.Respaldo_MapaViejo.Niveles2a5
origen_x: 6000
base_y: 600
verificado: 2026-11-14 (el folder del nivel está en ServerStorage.Respaldo_MapaViejo.Niveles2a5; lo demás es como estaba en el juego)
---
# Nivel 2 · Aldea Nevada

**Descartado (D-027c):** desde el 2026-11-14 el juego solo tiene la pista navideña. El folder sigue guardado en `ServerStorage.Respaldo_MapaViejo.Niveles2a5`. Esta ficha describe cómo era.

Coordenadas reales: `grep -n "N2" place/mapa-place.md`. Las X del diseño son relativas al nivel (sumar 6000).

## Angel decidió
- Inspirado en una foto de aldea nevada: casas de madera con techos de nieve gruesa, faroles rojos, postes con "hongo" de nieve.
- La aldea es solo visual: el pingüino no interactúa con las casas. Todo con textura stud.
- Misma lógica: resortera, bajada con obstáculos, zona plana y portal (D-010).

## Zonas (Claude eligió)
Prototipo v0.1: https://claude.ai/artifact/6z7kcVWzGs71pw1BT4y2ed

⚠️ La tabla es de la v0.1. Se construyó la v0.2 (30 % más larga, más obstáculos): la meta real está en Z 1800 y el portal en Z 1879. Las Z de abajo sirven para el orden de las zonas, no para ubicar cosas.

| # | Zona | Z (v0.1) | Pendiente | Obstáculos |
|---|---|---|---|---|
| 1 | Meseta y entrada | -140–0 | 0° | puerta "ALDEA NEVADA", resortera, fila |
| 2 | Caída | 0–20 | caída de 40 | — |
| 3 | Llegada a la aldea | 20–180 | 14° | ninguno |
| 4 | Calle de los postes nevados | 180–520 | 17° | postes con hongo de nieve, cercas bajas, leña |
| 5 | Pabellón de los faroles | 520–640 | 12° | 3 kioscos; pilares en X ±20 dividen 3 carriles |
| 6 | Mercado nevado | 640–900 | 18° | carretas, barriles, trineos, faroles, bolas de nieve, muñeco |
| 7 | Arroyo congelado | 900–1000 | 3° | hielo, trozos de hielo, puente-rampa (rampa de impulso) |
| 8 | Bosque de la aldea | 1000–1300 | 20° | pinos, postes, tronco de lado a lado, leña |
| 9 | Puerta de salida y meta | 1300–1420 | 8° | puerta roja "¡META!" |
| 10 | Zona plana y portal | 1420–1490 | 0° | portal de hielo |

- Casas fuera de los bancos de nieve (|X| ≥ 92).
- **No tiene ninguna parte `Hazard`**: aquí solo se muere por choque o por caer bajo `KillHeight` → Q-06.

## Decoración "Festival de Faroles" (D-019)
- Artefacto aprobado: https://claude.ai/artifact/6UzmRzQXgsgLc2GiZK9nQL · código: `archivo/artefactos/Nivel2Decoracion_artefacto_v01.html`
- En Studio: `FestivalDecoration` con HouseDetails, Lanterns, Market, IceRink, Forest, Finale, Crowd, DistantLights. Script que lo construyó: `ServerStorage.ClaudeBuild.BuildLevel2Festival`.
- Contenido aprobado: campana y faroles en la entrada, puesto de té, aldeanos; humo, coronas, tendederos, gatos; faroles flotando sobre el pabellón, linternas que suben, dragón de tela; puestos de mercado, carrusel de trineos, acordeón; pistas de patinaje a los lados del arroyo; faroles en los pinos, búhos, cabaña del leñador; tambores, gong y estatua de hielo en la meta; pagoda, molino y pueblo a lo lejos.
- Reglas: todo fuera de la pista (entre los bancos en X ±62 y las casas) o muy por encima; lo que quede sobre la pista va sin colisión.
- No comparado pieza por pieza contra el artefacto → Q-01.

## Sin definir
Si el hielo del arroyo cambia la física · estilo propio para el portal.

## Reconstrucción
`archivo/construccion/BuildLevel2_v02.lua`, luego `ServerStorage.ClaudeBuild.BuildLevel2Festival` y `InstallBoostRamps_v01.lua`.

## Suelo (D-025c)
`GroundTexture`: parches sin colisión en tonos de blanco o azul hielo sobre la franja de la pista, hechos con `DevTools.GroundTexturer`.
