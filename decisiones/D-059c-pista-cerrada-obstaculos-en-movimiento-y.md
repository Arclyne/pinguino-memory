---
tipo: decision
id: D-059c
fecha: 2026-11-17
autor: ciervo
estado: vigente
tema: niveles,huevos
---
# D-059c · Pista cerrada, obstáculos en movimiento y huevos con aura
- Ciervo decidió (2026-11-17): que en ninguna parte de la bajada se pueda salir de la pista ("me puedo salir de él").
- Ciervo decidió: obstáculos coherentes con cada bioma, unos en movimiento y otros fijos (p. ej. coches andando, camellos avanzando), en todos los biomas.
- Ciervo decidió: huevos de la bajada muy grandes y con un aura que no pase desapercibida.
- porqué: no lo dijo; salirse era un error del mapa.
- Claude eligió (sin aprobar):
  - Doble cierre: paredes invisibles que rebotan (`Bumper`, 70 de alto) pegadas al borde real de calle y rieles en las 48 piezas, medido con rayos; y un cerco en el cliente que, si aun así el pingüino pasa ese borde, lo regresa y le quita la velocidad hacia afuera. La zona ancha del aterrizaje navideño queda con su ancho.
  - 4 obstáculos nuevos por bioma (56): 46 se mueven (cruzan la calle de lado a lado, avanzan hacia el jugador, ruedan, saltan, giran o se columpian) y 10 son fijos. Ejemplos: reno y bola de nieve (Navideño), camello, escorpión y rodadora (Desierto), mono en liana y serpiente (Selva), bola de lava y golem (Volcán), autos y moto (Ciudad Neón), ovni y meteorito (La Luna).
  - Los nuevos salen más seguido que los viejos (peso por obstáculo) y hay más obstáculos (`EndlessConfig.Obstacles.Spacing` bajó).
  - Huevo de la bajada 2.5 veces más grande, flotando sobre la calle, con burbuja que late, anillo en el piso, columna de luz doble de 220 de alto, chispas, partículas que suben, luz, contorno visible a través de todo y letrero "HUEVO <RAREZA>". Todos los huevos, no solo los raros. Radio para levantarlo más grande (`EggConfig.Pickup.Radius`).
- descartado: nada.
- dónde vive: `ClaudeBuild.EndlessGuardBuilder`, `ClaudeBuild.EndlessObstacleBuilder`, `Client.Race.TrackFence`, `Client.Endless.ObstacleMotion`, `Client.Eggs.EggAura` → [[nivel-1]].
