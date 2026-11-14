---
tipo: decision
id: D-026c
fecha: 2026-11-13
autor: ciervo
estado: vigente
tema: niveles
---
# D-026c · Nivel 5 más rápido y rampas que no frenan
- Ciervo decidió: en N5 el pingüino va más rápido (solo ese nivel) y las rampas no le quitan velocidad. Eligió entre opciones que las rampas del jardín te hagan saltar el obstáculo del centro de cada casa.
- porqué: N5 se sentía lento. Medido en Play: antes bajaba a 55–80 studs/s y chocaba en la casa 2; ahora va a 120–165 (media 140) y la bajada completa sin obstáculos del segundo cuarto tarda 34 s.
- Claude eligió (sin aprobar): `GameConfig.Slide.LevelTuning[5]` (`MaxSpeed` 165, `DownhillBoost` 2.2, `QuadraticDrag` 0.0035, `SteerAcceleration` 200) que `SlideMotor` lee por el `LevelId` del jugador. Atributo `KeepSpeed` en las 106 cuñas de rampa de N5: sobre ellas no hay arrastre, se conserva la velocidad de entrada y se repone al aterrizar. Atributo `JumpDistance` = 80 en las 54 cuñas `YardRamp`/`RampStripe`: al despegar se calcula el impulso hacia arriba para caer a 80 studs (unos 66 dentro de la casa, pasando el obstáculo a 46), con tope `Slide.MaxRampLift` 65.
- descartado: mover los obstáculos de las casas, o dejarlos donde caías encima.
- dónde vive: `Client.Race.SlideMotor`, `Client.Race.GroundProbe` (ahora devuelve la parte pisada) → [[sistemas]].
