---
tipo: estado
verificado: 2026-11-13 (Studio, por inspección de la place en modo edición; no se jugó)
---
# Estado

Prototipo jugable en **PINGUINO TEST** (placeId 76340917059535, universeId 10776032682): 5 niveles encadenados, lobby en la meseta del nivel 1 y economía de peces con datos guardados. Sin publicar y sin monetización.

Esta nota solo cambia cuando cambia lo que existe en el juego. Lo que se mueve cada sesión (huella, bitácoras, tareas urgentes, preguntas) lo arma `python3 herramientas/ver.py inicio`.

## Existe en Studio
- **Carrera** en N1–N5: resortera → vuelo → deslizamiento → meta. Chocar, pisar un `Hazard` o caer elimina y reaparece en la meseta del mismo nivel. → [[juego]]
- **Encadenado:** al terminar un nivel se monta solo en la resortera del siguiente; el último (N5) se repite (D-016).
- **Rampas de impulso** en N1, N2 y N3 (D-017) y **efectos de movimiento** (D-018).
- **Lobby** en la meseta de N1: camino de flechas, ruleta, salón de la fama, pedestal del evento, podio, portal de niveles, tienda, fogata. → [[lobby-economia]]
- **Economía:** peces en la pista, regalo diario, impulso x2, ruleta, 5 skins, tabla semanal. Datos con DataKit (D-015).
- **Decoración:** festiva en N1 (D-013) y Festival de Faroles en N2 (D-019).
- **Cinemática de avalancha** en N1 al subirse a la resortera (sin decisión: Q-02).
- **N5 Vecindario Navideño:** 18 casas que se cruzan por dentro y 36 ventanas que se rompen (sin decisión ni diseño: Q-25). → [[nivel-5]]

## Solo fachada (botón con panel "próximamente")
Personalizar, Pack inicial, VIP, Renacer, Lanzarse con un amigo, Próxima carrera, Evento Avalancha. No hay ninguna compra con Robux.

## Sin probar
- Nadie ha registrado una partida completa de los 5 niveles con control. N5 no tiene ninguna prueba anotada.
- Saltos de N3 y grietas de N4 con la física real.
- Session lock de DataKit con dos servidores.
- Celular y consola: no hay controles táctiles.
- Rendimiento en celular (la place pasó de ~42,000 a ~61,500 instancias con N5).
- Que el lobby y el Festival de N2 coincidan con los artefactos aprobados (Q-01).

## Frases gatillo
| La persona dice | Claude hace |
|---|---|
| "cierra sesión" | protocolo de cierre de `CLAUDE.md` |
| "agrega lo que no agregamos" · "agrega todo lo que no se agregó" · "agrega la decoración al nivel 2" | retiradas: todo lo de esas listas ya está en Studio. Avisar y preguntar qué falta |

## Avisos
- El vault anterior está en `archivo/vault-v1.zip` (copia de las 02:15 del 2026-11-13).
