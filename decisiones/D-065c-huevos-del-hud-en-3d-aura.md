---
tipo: decision
id: D-065c
fecha: 2026-11-18
autor: ciervo
estado: vigente
tema: nivel-1
---
# D-065c · Huevos del HUD en 3D, aura de obstáculos, resortera puesta en el lobby y música del lobby
- Ciervo decidió (2026-11-18): mejorar los cupos de huevos de la bajada (el óvalo plano se veía horrible); que la resortera que te pones se vea en el lobby; quitar los emojis "de IA" de las resorteras y usar íconos detallados como el del pez; música nostálgica en el lobby (al menos 8, una al azar cada vez que reapareces); todos los obstáculos con contorno brillante para verlos, sobre todo en biomas oscuros.
- porqué: ciervo se quedó con la pantalla congelada a 36,494 m y no se veían los obstáculos en el volcán.
- Claude eligió (sin aprobar):
  - Pantalla congelada: la pista baja ~0.25 studs por metro; a ~36,000 m pasaba `Workspace.FallenPartsDestroyHeight` (-9000) y Roblox borraba al pingüino. Se bajó al mínimo, -50000: alcanza hasta ~200,000 m. Más allá hará falta otra solución (subir el origen o reiniciar la altura).
  - Cupos de huevos: tarjeta más grande con el diseño real del huevo de esa rareza en 3D, girando y flotando, halo y borde de su color que laten, y etiqueta con la rareza; el vacío es un óvalo punteado con "?".
  - Resortera en el lobby: cada jugador ve todas las resorteras del juego con la que tiene puesta (color, material, luz y chispas desde Diamante); los demás ven la suya. El botón RESORTERAS muestra la resortera en 3D.
  - Íconos: las resorteras usan los íconos dibujados del juego (medalla, bronce, plata, oro, diamante, cohete, rayo, astronauta, arcoíris).
  - Aura: `Highlight` amarillo dorado que late en los 24 obstáculos más cercanos (a menos de 650 studs), en todos los biomas.
  - Lobby: 8 canciones nostálgicas (`MusicConfig.Lobby`), una al azar al reaparecer o volver de la bajada, sin repetir la anterior; al acabar sigue otra. Se apaga al lanzarte.
- sin decidir: si las canciones del lobby gustan (no se escucharon).
- dónde vive: `Workspace.FallenPartsDestroyHeight`, `Eggs.EggCarryView`, `Client.SlingshotSkin`, `Panels.SlingshotPanel` (`mountIcon`), `Shared.SlingshotCatalog`, `Endless.ObstacleAura`, `Endless.ChunkStreamer` (atributo `Obstacle`), `Shared.MusicConfig`, `Client.LobbyMusic` → [[nivel-1]], [[lobby-economia]].
