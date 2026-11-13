---
tipo: decision
id: D-016
fecha: 2026-11-13
autor: v1
estado: vigente
tema: niveles
---
# D-016 · Avance automático al siguiente nivel
- Angel decidió: al terminar un mapa empieza solo el siguiente y el jugador queda arriba de la resortera, listo para lanzarse.
- Claude eligió: espera `GameConfig.Race.AutoAdvanceSeconds` tras la meta; el siguiente nivel es el `DestinationLevel` del portal (el último nivel no tiene, así que se repite); entrar al portal antes adelanta el avance; si la resortera está ocupada, llega a la meseta en `Idle`.
- abierto: Q-03 (qué pasa al terminar el último nivel).
