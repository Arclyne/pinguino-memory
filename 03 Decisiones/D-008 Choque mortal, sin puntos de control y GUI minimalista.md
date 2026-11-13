---
tipo: decision
id: D-008
fecha: 2026-11-11
estado: aceptada
---
# D-008 Choque mortal, sin puntos de control y GUI minimalista #decidido

## Decisión
- **No hay puntos de control.** Se quitaron del juego y del mapa.
- **Al chocar ya no puedes moverte:** quedas en ragdoll y mueres.
- La muerte **no usa la muerte normal de Roblox** (se sentía rara): tras el ragdoll se hace `LoadCharacter` y reapareces arriba.
- Hay **animación de salto**.
- La **GUI es minimalista** y no estorba en medio de la pantalla.
- Al llegar a la meta no hay panel: solo una lectura mínima del tiempo.

## Contexto
Correcciones de Angel al jugar el prototipo v1. Sustituye las propuestas de choque con aturdimiento y de regreso al punto de control.

## Consecuencias
- Caer al río o a una grieta también elimina al pingüino (propuesta de Claude, #idea).
- El ragdoll dura 1.2 s antes del `LoadCharacter` (valor de Claude, #idea).
- Para volver desde la meta se entra al portal; ya no hay botón.

## Relacionado
[[Prototipo jugable v1]] · [[D-007 Jugabilidad base del recorrido]] · [[D-006 Patrón MVP para las GUIs]]
