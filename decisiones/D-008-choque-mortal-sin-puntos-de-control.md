---
tipo: decision
id: D-008
fecha: 2026-11-11
autor: v1
estado: vigente
tema: carrera, gui
---
# D-008 · Choque mortal, sin puntos de control, GUI minimalista
- Angel decidió: no hay puntos de control. Al chocar no te puedes mover: ragdoll y mueres. La muerte no usa la muerte normal de Roblox (se sentía rara). Hay animación de salto. La GUI es minimalista y no estorba. En la meta no hay panel, solo el tiempo.
- porqué: correcciones de Angel al jugar el prototipo v1. Sustituye las propuestas de aturdimiento y de regreso al checkpoint.
- Claude eligió: tras el ragdoll (`GameConfig.Crash.RagdollSeconds`) el servidor hace `LoadCharacter`. Caer al río o a una grieta también elimina. Roces de lado no cuentan.
