---
tipo: decision
id: D-035a
fecha: 2026-11-14
autor: angel
estado: vigente
tema: carrera
---
# D-035a · Más velocidad en las bajadas y cámara que se aleja
- Ciervo decidió (2026-11-12): en las bajadas el pingüino va bastante más rápido, sin dejar de ser pasable; la cámara se aleja con la velocidad, con efectos que acompañen; después, la cámara subió porque iba muy pegada al suelo y no dejaba ver los obstáculos.
- porqué: no lo dijo.
- Claude eligió (sin aprobar): un empujón proporcional a la pendiente solo en el suelo y de bajada (`GameConfig.Slide.DownhillBoost`, `DownhillMinimumSlope`, `Slide.MaxSpeed`); en plano, subida y aire no cambia. La pista navideña y el Modo Avalancha usan sus propios valores (`Slide.LevelTuning`). Distancia y altura de la cámara en `ChaseCamera`.
- descartado: nada.
- dónde vive: `Client.Race.SlideMotor`, `ChaseCamera`, `SpeedEffects` → [[sistemas]] § Cámara y sensación. Los efectos quedaron en D-018.
- origen: Rescatada del vault viejo (D-011, D-009 y D-010 de la otra computadora, 2026-11-12), que no pasó al nuevo al sincronizar. Angel confirmó el 2026-11-14 que la pidió ciervo.
