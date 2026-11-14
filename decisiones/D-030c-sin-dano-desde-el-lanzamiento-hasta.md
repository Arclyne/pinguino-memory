---
tipo: decision
id: D-030c
fecha: 2026-11-14
autor: ciervo
estado: vigente
tema: carrera
---
# D-030c · Sin daño desde el lanzamiento hasta caer en la pista
- Ciervo decidió: desde que te lanzas hasta que tocas el suelo nada te quita vida.
- porqué: al caer de la resortera le bajaba vida. Reproducido en Play: con tiro alto y en diagonal (giro 18, elevación 45) el sensor de choques contaba un golpe 0.08 s después de tocar la calle (−25).
- Claude eligió (sin aprobar): en el cliente, `RacingMode` da 1 s de invulnerabilidad al aterrizar (`LANDING_GRACE_SECONDS`; durante ese segundo rebota en vez de chocar). En el servidor, `ChristmasRunService` no resta vida ni rescata hasta que el pingüino llega a 8 studs o menos sobre la pista (o pasan 8 s), y luego da 1 s más. Probado en Play con giro 18 y −18, elevación 45: vida 100 al aterrizar.
- dónde vive: `Client.Run.Modes.RacingMode`, `Services.ChristmasRunService` → [[sistemas]] § Pista navideña.
