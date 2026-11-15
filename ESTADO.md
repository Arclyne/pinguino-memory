---
tipo: estado
verificado: 2026-11-14 (Studio; bajada infinita, huevos y bases probados en Play por angel; pantalla de muerte probada en Play por angel; antes, por inspección de la place en modo edición; la pista navideña no se jugó; el Modo Avalancha se probó en Play con bot)
---
# Estado

Prototipo jugable en **PINGUINO TEST** (placeId 76340917059535, universeId 10776032682): la bajada infinita (D-045a, D-050a), el Modo Avalancha (D-033c), lobby en su meseta y economía de peces con datos guardados. Sin publicar y sin monetización.

Esta nota solo cambia cuando cambia lo que existe en el juego. Lo que se mueve cada sesión (huella, bitácoras, tareas urgentes, preguntas) lo arma `python3 herramientas/ver.py inicio`.

## Existe en Studio
- **Bajada infinita (N1):** sale de la resortera del lobby. Mapa sin fin armado en el cliente con 9 piezas del bioma navideño, semilla semanal, obstáculos repartidos por el generador, frío que quita vida con la distancia (con avisos en pantalla), estadísticas según la skin puesta (D-039a, valores sin aprobar: Q-27a), sin curación ni meta (D-038a, D-045a, D-048a, D-050a). → [[nivel-1]]
- **Carrera:** resortera → vuelo → deslizamiento hasta quedarte sin vida. Un choque te tumba y te endereza sobre la pista; sin vida (choque, caída o frío): pantalla de muerte con bioma, distancia y botones REINTENTAR o LOBBY (D-037a). → [[juego]]
- **Huevos (D-040a, D-052a):** de 1 a 3 por bioma en la bajada, con 7 rarezas; llevas uno a la vez, se aseguran al pasar al siguiente bioma y se pierden si mueres antes. → [[nivel-1]]
- **Bases (D-052a):** 12 parcelas junto al lobby, una por jugador, con nidos para incubar por tiempo, pingüinos exhibidos y letrero; panel MI BASE. De los huevos nacen pingüinos; cada uno es un objeto propio. → [[lobby-economia]]
- **Obstáculos:** 45 modelos repartidos por el generador, más las pilas de regalos de cada pieza. Nada quita vida entre el lanzamiento y el aterrizaje (D-030c). **Pads de turbo** dentro de las piezas y **efectos de movimiento** (D-018).
- **Avalancha:** cinemática al subirse a la resortera y ola que persigue al inicio de la bajada (D-029c).
- **Eventos (D-032c):** solo la Nevada de peces. Los de la bajada (Santa, tormenta, desfile, duendes, trineo dorado) y la carrera programada están en pausa: dependían de la pista vieja (Q-33a).
- **Modo Avalancha (D-033c):** botón de arriba del lobby, una vez cada 12 h. Mapa aparte (nivel 2): bajada de ~4 min a ~450 km/h con ~2,000 peces, barreras para saltar, muros para esquivar, avalancha que te alcanza si chocas dos veces seguidas, y rampa final a un campo de distancias con premio. → [[nivel-2]]
- **Lobby** en la meseta de N1: camino de flechas, podio, tienda, fogatas, y al fondo el salón de la fama y la ruleta (D-054a; el portal de niveles y el pedestal del evento se retiraron). → [[lobby-economia]]
- **Economía:** tienda rotativa de huevos cada hora (D-054a), regalo diario, impulso x2, ruleta, 12 skins que salen de huevos (7 provisionales; ya no se compran), tabla semanal. Datos con DataKit (D-015).

## Descartado (D-027c; sigue guardado en `ServerStorage.Respaldo_MapaViejo`)
N2–N5 (`Niveles2a5`), la pista vieja de N1 con casi toda su decoración festiva (D-013) y, desde D-050a, la pista navideña (`ChristmasRun`), de donde se cortan las piezas. Las fichas [[nivel-3]], [[nivel-4]] y [[nivel-5]] describen cómo eran.

## Sin peces bajando
Desde D-050a no se gana ningún pez en la bajada (ni carriles, ni zonas, ni meta). Falta repartirlos con el generador (T-16a, Q-33a).

## Solo fachada (botón con panel "próximamente")
Personalizar, Pack inicial, VIP, Renacer, Lanzarse con un amigo. No hay ninguna compra con Robux.

## Sin probar
- La pantalla de muerte en celular (tamaño y toques) y con la resortera ocupada al reintentar.
- El Modo Avalancha jugado por una persona (solo se probó con bot) y con varios jugadores a la vez.
- La bajada infinita jugada por una persona, en celular y con varios jugadores (solo se probó con bot hasta ~5,800 studs). La caída con rescate.
- Huevos y bases a mano y con dos jugadores (dos bases a la vez, que nadie use el nido de otro); perfiles con muchos pingüinos; el servidor aún admite 60 jugadores y solo hay 12 bases (T-17a).
- Session lock de DataKit con dos servidores.
- Celular y consola: no hay controles táctiles.
- Rendimiento en celular: Workspace bajó a ~19,800 instancias, pero cada cliente carga ~38,400 de piezas en `ReplicatedStorage`.
- Que el lobby coincida con los artefactos aprobados (Q-01).

## Frases gatillo
| La persona dice | Claude hace |
|---|---|
| "cierra sesión" | protocolo de cierre de `CLAUDE.md` |
| "agrega lo que no agregamos" · "agrega todo lo que no se agregó" · "agrega la decoración al nivel 2" | retiradas: todo lo de esas listas ya está en Studio. Avisar y preguntar qué falta |

## Avisos
- El vault anterior está en `archivo/vault-v1.zip` (copia de las 02:15 del 2026-11-13).
