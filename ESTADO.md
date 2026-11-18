---
tipo: estado
verificado: 2026-11-18 (bases rediseñadas según D-057c el 18 por angel, probadas en Play; planeo probado en Play con bot; ramales y puente alto vistos en Play, sin bajar por ellos; piso medido pieza por pieza; Studio; frío apagado, obstáculos de D-063c y efectos de velocidad probados en Play con bot: pegado al borde derecho murió a ~3,900 m; 15 biomas más, música y 9 resorteras el 18 por ciervo: salto de resortera, música y tienda probados en Play con bot, biomas nuevos sin bajar jugando. 2026-11-17: pista cerrada, obstáculos en movimiento y huevos con aura probados en Play con bot el 17 por ciervo; biomas nuevos y frío apagado el 17, sin bajar jugando por ellos; bajada infinita, huevos y bases probados en Play por angel; pantalla de muerte probada en Play por angel; antes, por inspección de la place en modo edición; la pista navideña no se jugó; el Modo Avalancha se probó en Play con bot)
---
# Estado

Prototipo jugable en **PINGUINO TEST** (placeId 76340917059535, universeId 10776032682): la bajada infinita (D-045a, D-050a), el Modo Avalancha (D-033c), lobby en su meseta y economía de peces con datos guardados. Sin publicar y sin monetización.

Esta nota solo cambia cuando cambia lo que existe en el juego. Lo que se mueve cada sesión (huella, bitácoras, tareas urgentes, preguntas) lo arma `python3 herramientas/ver.py inicio`.

## Existe en Studio
- **Bajada infinita (N1):** sale de la resortera del lobby. Mapa sin fin armado en el cliente, semilla semanal, 29 biomas en orden fijo (navideño con 9 piezas y 28 temas hechos con constructor, 3 piezas y obstáculos propios cada uno, D-058c, D-061c) con 5 canciones propias cada uno (D-061c, D-064c), obstáculos repartidos por el generador, frío apagado en Studio (D-058c, D-063c de ciervo); Angel había pedido encenderlo (D-061a): sin resolver, Q-37a, contorno dorado en los obstáculos cercanos (D-065c), rampas turbo con flechas verdes (~7 por bioma) y 2 botiquines por bioma (D-066c), límite real de ~200,000 m por la altura mínima de Roblox (D-065c), obstáculos contra pegarse al borde (meteoritos que caen, muro con hueco, picos en los bordes, láser; D-063c) efectos en pantalla a alta velocidad sin bordes ni anillos y temblor solo cerca del máximo (D-063c, D-068c), ramales sin letreros que salen por huecos de la baranda y vuelven a la pista (puente alto sobre un valle y colinas con rampas) y plataforma de planeo cada 3 tramos (D-069c), piso de triángulos continuo sin escalones (D-068c), paredes y cerco para que nadie se salga, obstáculos en movimiento y fijos en cada bioma, huevos grandes con aura, sin letrero, y con los 47 diseños aprobados (D-059c, D-060c, D-061c), estadísticas según la skin puesta (D-039a, valores sin aprobar: Q-27a), sin meta y sin más curación que los botiquines (D-038a, D-045a, D-048a, D-050a, D-066c). → [[nivel-1]]
- **Carrera:** resortera → vuelo → deslizamiento hasta quedarte sin vida. Un choque te tumba y te endereza sobre la pista; sin vida (choque o caída): pantalla de muerte con bioma, distancia y botones REINTENTAR o LOBBY (D-037a). → [[juego]]
- **Huevos (D-040a, D-052a):** de 1 a 3 por bioma en la bajada, con 7 rarezas; llevas uno a la vez, se aseguran al pasar al siguiente bioma y se pierden si mueres antes. → [[nivel-1]]
- **Bases (D-052a, rediseñadas según D-057c):** 12 parcelas junto al lobby, una por jugador, con portada de hielo, cúpula con nidos para incubar por tiempo (3 abiertos y 3 congelados para el gamepass), pingüinos exhibidos en pedestales y letrero; panel MI BASE. De los huevos nacen pingüinos; cada uno es un objeto propio. → [[lobby-economia]]
- **Obstáculos:** 49 en el navideño, 8–9 en cada uno de los 13 biomas de D-058c (46 en movimiento, D-059c) y 5 en cada uno de los 15 de D-061c (3 en movimiento), repartidos por el generador, más las pilas de regalos de las piezas navideñas. Nada quita vida entre el lanzamiento y el aterrizaje (D-030c). **Pads de turbo** dentro de las piezas y **efectos de movimiento** (D-018).
- **Avalancha:** cinemática al subirse a la resortera y ola que persigue al inicio de la bajada (D-029c).
- **Eventos (D-032c):** solo la Nevada de peces. Los de la bajada (Santa, tormenta, desfile, duendes, trineo dorado) y la carrera programada están en pausa: dependían de la pista vieja (Q-33a).
- **Modo Avalancha (D-033c):** botón de arriba del lobby, una vez cada 12 h. Mapa aparte (nivel 2): bajada de ~4 min a ~450 km/h con ~2,000 peces, barreras para saltar, muros para esquivar, avalancha que te alcanza si chocas dos veces seguidas, y rampa final a un campo de distancias con premio. → [[nivel-2]]
- **Lobby** en la meseta de N1 con música nostálgica al azar (D-065c): camino de flechas, podio, tienda, fogatas, y al fondo el salón de la fama y la ruleta (D-054a; el portal de niveles y el pedestal del evento se retiraron). → [[lobby-economia]]
- **Economía:** tienda rotativa de huevos cada hora (D-054a), regalo diario, impulso x2, ruleta, 9 resorteras con su propio panel y vista previa que se compran con peces y lanzan más lejos, las últimas saltando biomas completos (D-062c, D-064c), 3,000,000 de peces de prueba solo para ciervo en Studio (D-064c), 12 skins que salen de huevos (7 provisionales; ya no se compran), tabla semanal. Datos con DataKit (D-015).

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
- Rendimiento en celular: Workspace bajó a ~19,800 instancias, pero cada cliente carga ~391,000 instancias de piezas en `ReplicatedStorage` (D-068c, D-069c). Studio se cerró una vez al darle Play con todo cargado.
- Los 28 biomas nuevos jugando (de los 15 del 18 solo se vio la Pradera en Play) y la música escuchada por una persona.
- Comprar resorteras de verdad (se probó con el nivel puesto a mano, sin gastar peces).
- Que el lobby coincida con los artefactos aprobados (Q-01).

## Frases gatillo
| La persona dice | Claude hace |
|---|---|
| "cierra sesión" | protocolo de cierre de `CLAUDE.md` |
| "agrega lo que no agregamos" · "agrega todo lo que no se agregó" · "agrega la decoración al nivel 2" | retiradas: todo lo de esas listas ya está en Studio. Avisar y preguntar qué falta |

## Avisos
- El vault anterior está en `archivo/vault-v1.zip` (copia de las 02:15 del 2026-11-13).
