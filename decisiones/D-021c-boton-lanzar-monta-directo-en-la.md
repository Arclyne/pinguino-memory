---
tipo: decision
id: D-021c
fecha: 2026-11-13
autor: ciervo
estado: vigente
tema: lobby,resortera
---
# D-021c · Botón ¡LANZAR! monta directo en la resortera
- Ciervo decidió: al presionar ¡LANZAR! el jugador queda sentado en la resortera de su nivel, listo para apuntar (antes solo lo llevaba al lado y había que presionar E).
- porqué: el botón no hacía lo que dice; un paso de más antes de jugar.
- Claude eligió (sin aprobar): reusar `SlingshotService.mountAtLevel` (igual que D-016); si la resortera está ocupada, se mantiene el comportamiento anterior (lo deja al lado en Idle) con el aviso "La resortera está ocupada"; el aviso de éxito cambió a "¡Apunta y lanza!".
- descartado: nada.
- dónde vive: `ProgressService.onLaunchPadRequested`, `LobbyHud.launch` → [[sistemas]].
