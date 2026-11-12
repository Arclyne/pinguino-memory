---
tipo: mecanica
estado: borrador
---
# Resortera

## Lo definido #decidido
- El jugador elige **dirección** y **fuerza** y lanza al pingüino.

## Prototipo v0.2 #idea
Prototipo 3D interactivo: https://claude.ai/artifact/DZuHEQHahKa4aUhb15QQTH

- Resortera grande de bloques con studs, al borde de la meseta (Z −20 del [[Mapa]]).
- Medidas v0.2: plataforma octagonal de piedra 24×4×24 con piso de tablas · tronco 6×13×6 con cuerdas · horquilla 12×5×7 con placa metálica y tornillos · brazos 5×16×5 inclinados 18° con nieve y carámbanos en las puntas · abertura entre puntas 18 · altura total ≈ 41 · liga a ≈ 36.
- Liga doble roja y cuero cosido. Alrededor: escalones, cajas, farol, bandera, letrero "¡Lanza al pingüino!" y pingüinos esperando en fila.
- Pingüino rediseñado (3×5×3): bufanda y gorro rojos, ojos con brillo y mejillas.
- Control: arrastrar hacia abajo = fuerza; arrastrar a los lados = dirección (al revés, como una liga real); W/S = elevación.
- Trayectoria predicha con puntos y marca de aterrizaje.
- Valores iniciales: elevación 25°, velocidad máx. 140 studs/s, giro máx. 35°, tirón máx. 10, gravedad 196.2.
- Con ~60–75 % de fuerza el pingüino cae en la zona de aterrizaje (Z 40–180).
- Hay un modo "solo fuerza" (dirección fija) para comparar con el modo 2D.

## En Studio
- Modelo `Workspace.PenguinSlingshotMap_v01.Slingshot` (+ `SlingshotDecor`, `SlingshotPenguin`, `WaitingPenguins`), creado con `05 Técnico/BuildSlingshot_v02.lua`. Sin scripts.
- Si se vuelve a correr `BuildMap_v01.lua`, hay que correr después `BuildSlingshot_v02.lua`.

## Por definir #pendiente
- Elevación fija o elegida por el jugador
- Dirección libre o solo fuerza
- Controles en celular y consola
- Qué pasa si cae fuera de la pista

Siguiente: [[Vuelo]]
