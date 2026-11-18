---
tipo: decision
id: D-062c
fecha: 2026-11-18
autor: ciervo
estado: vigente
tema: economia
---
# D-062c · Nueve resorteras que lanzan más lejos
- Ciervo decidió (2026-11-18): 9 resorteras mejoradas, cada una más potente que la anterior; las últimas te hacen saltar biomas completos. Los precios los pone Claude según la economía actual.
- porqué: dar en qué gastar los peces y una forma de llegar más lejos.
- Claude eligió (sin aprobar):
  - Madera 1,000 (+400 m) · Bronce 3,000 (+900) · Plata 8,000 (+1,600) · Oro 20,000 (+2,600) · Diamante 45,000 (+4,000) · Turbo 90,000 (+5,500, salta 1 bioma) · Relámpago 180,000 (+11,000, salta 2) · Cósmica 350,000 (+17,000, salta 3) · Arcoíris legendaria 700,000 (+28,000, salta 5). En peces, pensados contra los huevos de la tienda (300 a 250,000).
  - Se compran en orden en la TIENDA (tarjetas arriba de todo); la recién comprada queda puesta y se puede volver a usar una más baja. Se guarda en el perfil (`slingshotTier`, `slingshotEquipped`).
  - Cómo lanza más lejos: 0.7 s después de salir, el servidor te pasa al punto de la bajada que queda esos metros adelante, 70 studs arriba de la pista, con destello, letrero "¡SUPER RESORTERA!" y estela. Los biomas saltados no dan huevos.
  - El servidor acepta el aterrizaje solo hasta 4,000 m más allá del punto del salto (o del inicio si no hay resortera mejorada).
- sin decidir: si los metros extra deben ser vuelo de verdad en vez de un salto; si la resortera del lobby cambia de aspecto según cuál tienes; cómo convive con el frío (prendido, saltar a biomas lejanos daña mucho más rápido).
- dónde vive: `Shared.SlingshotCatalog`, `Services.SlingshotUpgradeService`, `EndlessRunService` (`warp`), `Run.Modes.RacingMode` (aviso `SlingshotWarp`), `Effects.SlingshotWarpFx`, `Panels.ShopPanel` → [[lobby-economia]], [[nivel-1]].
