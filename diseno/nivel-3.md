---
tipo: nivel
nivel: 3
nombre: Ciudad Nevada
folder: Workspace.PenguinSlingshotMap_Level3
origen_x: 12000
base_y: 600
verificado: 2026-11-13 (existencia y coordenadas en Studio; la pista completa no se ha jugado)
---
# Nivel 3 · Ciudad Nevada

Coordenadas reales: `grep -n "N3" place/mapa-place.md`. Prototipo v0.1: https://claude.ai/artifact/4ADzpxSBfM9okkTJvsVpWT

## Angel decidió (D-011)
- Una ciudad donde solo se recorren los techos, con obstáculos que tengan sentido en una ciudad.
- Que no haga falta machacar el salto. Algunos techos son más anchos para descansar.
- Todo con textura stud y con nieve que se note.
- Entre 40 y 45 % más largo que el nivel 2, y un poco más difícil.

## Zonas (Claude eligió)
Pista de ~2,740 studs. Cada edificio queda más bajo que el anterior; en la mayoría de los huecos basta la caída para cruzar. 4 huecos piden salto (franjas amarillas y negras antes del borde); dos tienen ruta alterna.

| # | Techo | Z | Pendiente | Ancho | Hueco antes |
|---|---|---|---|---|---|
| 1 | Torre de salida (spawn + resortera) | -140–0 | plano | 160 | — |
| 2 | Tejado de llegada | 30–250 | 12° | 120 | 30, con la caída |
| 3 | Azotea de ductos | 262–520 | 10° | 110 | 12, con la caída |
| 4 | Paneles solares | 540–820 | 8° | 130 | 20, salto o puente de andamio |
| 5 | Helipuerto (ancho, para respirar; rampa de impulso en Z 1048) | 834–1060 | 6° | 140 | 14, con la caída |
| 6 | Jardín en la azotea (angosto) | 1082–1330 | 10° | 100 | 22, salto obligatorio |
| 7 | Torres de agua | 1342–1600 | 12° | 120 | 12, con la caída |
| 8 | Letreros de neón (el más empinado) | 1620–1900 | 14° | 110 | 20, salto o túnel de cristal |
| 9 | Azotea en obras | 1914–2240 | 10° | 120 | 14, con la caída |
| 10 | Recta final y meta (Z 2680) | 2262–2700 | 8° | 120 | 22, salto obligatorio |
| 11 | Azotea del portal (Z 2740) | 2700–2770 | plano | 120 | — |

- Obstáculos (~100): aires acondicionados, ventilas, chimeneas, ductos, tragaluces, casetas, antenas, torres de agua, paneles solares, helicóptero, cajas, jardineras, invernadero, pinos en maceta, muñecos de nieve, bancas, conos, vigas, grúa, vallas, revolvedora, baño portátil, andamio, árbol de Navidad y regalos.
- Nieve: capa con studs en cada techo, bancos junto a los pretiles, cornisas y carámbanos (`Icicles`).
- Pórtico de neón "¡RESBALA!" en Z 1700; arco "¡META!".
- Peligros: 240 partes `Hazard` (`Pit`): huecos entre edificios, lados de la pista y techos de relleno.

## Sin probar
Los huecos de 20–22 studs con la física real → Q-10.

## Reconstrucción
`archivo/construccion/BuildLevel3_v01.lua`, luego `InstallBoostRamps_v01.lua`. Al construirlo hubo que bajar los edificios de relleno: quedaban más altos que la pista.
