---
tipo: estado
verificado: 2026-11-14 (Studio, por inspección de la place en modo edición; la pista navideña no se jugó; el Modo Avalancha se probó en Play con bot)
---
# Estado

Prototipo jugable en **PINGUINO TEST** (placeId 76340917059535, universeId 10776032682): un solo nivel, la pista navideña larga (D-027c), el Modo Avalancha (D-033c), lobby en su meseta y economía de peces con datos guardados. Sin publicar y sin monetización.

Esta nota solo cambia cuando cambia lo que existe en el juego. Lo que se mueve cada sesión (huella, bitácoras, tareas urgentes, preguntas) lo arma `python3 herramientas/ver.py inicio`.

## Existe en Studio
- **Pista navideña (N1):** una bajada de ~16,350 studs con 8 zonas, 10 atajos, vida (choque y caída restan, cada zona cura), rescate si te caes, ayuda de dirección y premios de peces por zona y en la meta. → [[nivel-1]]
- **Carrera:** resortera → vuelo → deslizamiento → meta. Un choque te tumba y te endereza sobre la pista; sin vida, o al pisar un `Hazard` sin vida, eliminado y reaparece en la meseta. → [[juego]]
- **Repetición:** al terminar se vuelve a montar en la misma resortera (el portal lleva a N1).
- **Obstáculos** en las 8 zonas: 66 más 9 pilas de regalos, con slalom en la recta final (D-031c). Nada quita vida entre el lanzamiento y el aterrizaje (D-030c). **Pads de turbo** (`BoostRamp`, 46) en zonas y atajos, y **efectos de movimiento** (D-018).
- **Avalancha:** cinemática al subirse a la resortera y ola que persigue al inicio de la bajada (D-029c).
- **Eventos (D-032c):** en la bajada, Santa con regalos, tormenta, desfile de juguetes, duendes y trineo dorado; para todo el servidor, Nevada de peces y carrera programada con inscripción.
- **Modo Avalancha (D-033c):** botón de arriba del lobby, una vez cada 12 h. Mapa aparte (nivel 2): bajada de ~4 min a ~450 km/h con ~2,000 peces, barreras para saltar, muros para esquivar, avalancha que te alcanza si chocas dos veces seguidas, y rampa final a un campo de distancias con premio. → [[nivel-2]]
- **Lobby** en la meseta de N1: camino de flechas, ruleta, salón de la fama, pedestal del evento, podio, portal de niveles (un solo nivel), tienda, fogatas. → [[lobby-economia]]
- **Economía:** peces en la pista (5 carriles), regalo diario, impulso x2, ruleta, 5 skins, tabla semanal. Datos con DataKit (D-015).

## Descartado (D-027c; sigue guardado en `ServerStorage.Respaldo_MapaViejo`)
N2–N5 (`Niveles2a5`), y la pista vieja de N1 con casi toda su decoración festiva (D-013). Las fichas [[nivel-3]], [[nivel-4]] y [[nivel-5]] describen cómo eran.

## Solo fachada (botón con panel "próximamente")
Personalizar, Pack inicial, VIP, Renacer, Lanzarse con un amigo. No hay ninguna compra con Robux.

## Sin probar
- La pista navideña completa con control: zonas, atajos, obstáculos, vida, rescate, meta y tiempo (T-14c).
- El Modo Avalancha jugado por una persona (solo se probó con bot) y con varios jugadores a la vez.
- Session lock de DataKit con dos servidores.
- Celular y consola: no hay controles táctiles.
- Rendimiento en celular: la place tiene ~90,500 instancias (la pista navideña sola ~85,000).
- Que el lobby coincida con los artefactos aprobados (Q-01).

## Frases gatillo
| La persona dice | Claude hace |
|---|---|
| "cierra sesión" | protocolo de cierre de `CLAUDE.md` |
| "agrega lo que no agregamos" · "agrega todo lo que no se agregó" · "agrega la decoración al nivel 2" | retiradas: todo lo de esas listas ya está en Studio. Avisar y preguntar qué falta |

## Avisos
- El vault anterior está en `archivo/vault-v1.zip` (copia de las 02:15 del 2026-11-13).
