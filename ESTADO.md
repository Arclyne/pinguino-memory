---
tipo: estado
verificado: 2026-11-13 (Studio, por inspección de la place en modo edición; no se jugó)
ultima_sesion: 2026-11-13
huella: scripts=136 lineas=18439 codigo=79f4e2ab instancias=61499 mundo=aead3f96
---
# Estado

Prototipo jugable en **PINGUINO TEST** (placeId 76340917059535, universeId 10776032682): 5 niveles encadenados, lobby en la meseta del nivel 1 y economía de peces con datos guardados. Sin publicar y sin monetización.

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

## Siguiente paso
1. Angel responde Q-25: qué se hizo en la place la madrugada del 13 y qué quedó aprobado. Sin eso N5 no tiene diseño ni decisión.
2. Angel juega N1 → N5 y ajusta la sensación (T-01).
3. Angel responde el resto de hallazgos: Q-01, Q-02, Q-05, Q-06, Q-12, Q-13, Q-14, Q-22 → [[PREGUNTAS]]
4. Definir objetivo, multijugador y MVP (Q-15, Q-16, Q-17): bloquean la fase 3 → [[TAREAS]]

## Frases gatillo
| Angel dice | Claude hace |
|---|---|
| "cierra sesión" | protocolo de cierre de `CLAUDE.md` |
| "agrega lo que no agregamos" · "agrega todo lo que no se agregó" · "agrega la decoración al nivel 2" | retiradas: todo lo de esas listas ya está en Studio. Si Angel las dice, avisarle y preguntar qué falta |

## Avisos
- ⚠️ Angel debe guardar la place (Ctrl+S): se agregó y cambió `ServerStorage.DevTools.PlaceMap` (T-02).
- Dos computadoras sincronizan este vault (angels-MacBook-Air y OasisMachine). La otra debe hacer pull antes de escribir: el 2026-11-13 se reestructuró todo.
- El vault anterior está en `archivo/vault-v1.zip` (copia de las 02:15 del 2026-11-13).
