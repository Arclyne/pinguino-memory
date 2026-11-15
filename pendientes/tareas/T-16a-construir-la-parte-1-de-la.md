---
tipo: tarea
id: T-16a
fecha: 2026-11-15
autor: angel
estado: pendiente
grupo: construir
---
# T-16a · Construir la parte 1 de la progresión
- hecho cuando: 
- bloqueada por: 
Orden acordado en D-044a. Parte 1, según D-038a, D-040a, D-041a, D-042a, D-045a y D-047a:
- [ ] Generador compartido con semilla semanal (`ReplicatedStorage`): devuelve por chunk las piezas, obstáculos, peces y huevos; el servidor lo usa para validar sin construir.
- [ ] Cliente que arma y borra chunks alrededor del jugador.
- [ ] Piezas de los 3 biomas: cortar la pista navideña (`Shared.ChristmasTrack`) y sacar tramos de Ciudad Nevada y Valle del Avión del respaldo.
- [ ] Arco de fin de bioma y cambio de ambiente.
- [ ] Frío: la vida baja con la distancia; quitar la curación de las zonas (D-048a).
- [ ] Huevos en el mapa (1 a 3 por bioma, rareza por distancia), cargarlos (slots), tirarlos, perderlos al morir, asegurarlos en el arco.
- [ ] Incubación por tiempo guardada en DataKit, con multiplicador de evento solo en línea.
- [ ] Tienda rotativa (huevos y resorteras con peces); resortera de premio en la ruleta y al pasar cada arco por primera vez (D-048a).
- [ ] Estadísticas del pingüino (Vida, Abrigo, Resistencia) e Impulso de la resortera.
- [ ] Gamepasses de slots e incubadora (precios configurables).
- [ ] El generador trabaja por distancia recorrida, no por posición del mundo (para resolver la precisión después).
Antes de empezar, conviene resolver lo que queda de Q-28a, Q-29a y Q-30a que afecta la parte 1.
