---
tipo: diseno
verificado: 2026-11-14 (controles y reglas leídos del código en Studio; la vida, el rescate y la ayuda de dirección leídos del código el 14; sensación de juego sin probar)
---
# Juego: reglas, ciclo y controles

Los números viven en [[valores]]; aquí solo se citan sus claves.

## Concepto (D-001)
Un pingüino es lanzado con una resortera: el jugador elige dirección y fuerza, lo suelta, cae en un acantilado de nieve y se desliza hasta abajo esquivando estructuras. Plataforma: Roblox.

## Ciclo
```
Lobby (Idle) --E o ¡LANZAR!--> Aiming --soltar--> Racing --meta--> Finished --auto--> Aiming en la misma resortera
                                  |                 |
                                  X: bajarse        choque: tumbo y te endereza (−vida) · caída: rescate sobre la pista (−vida)
                                                    sin vida: ragdoll, LoadCharacter, vuelve a Idle en la meseta
```
- Estados y transiciones exactas: [[sistemas]] § Estados.
- Desde el 2026-11-14 hay un solo nivel (la pista navideña, D-027c): al terminar, el avance automático (D-016) vuelve a montar en la misma resortera.
- Vida, zonas y premios de la pista: [[nivel-1]].
- Sin puntos de control (D-008).

## Controles (leídos del código)
| Fase | Entrada | Acción | Script |
|---|---|---|---|
| Lobby | E cerca de un objeto | Subirse a la resortera o abrir el panel del objeto | ProximityPrompt (`OpensPanel`) |
| Lobby | R o botón ¡LANZAR! | Monta directo en la resortera del nivel actual (D-021c) | `LobbyHud` → `LaunchPadRequested` |
| Lobby | P G K Y Q B L H X C Z U F N | Paneles (tabla en [[lobby-economia]]) | `LobbyHud` |
| Lobby | Esc | Cierra el panel abierto | `LobbyHud` |
| Resortera | Mover mouse | Dirección: izquierda/derecha gira, arriba/abajo cambia la elevación (D-005) | `AimInput` |
| Resortera | Clic sostenido y arrastrar hacia atrás (abajo) | Fuerza; soltar = lanzar | `AimInput` |
| Resortera | X | Bajarse | `AimInput` → `DismountRequested` |
| Carrera | A / D, flechas, stick izquierdo | Moverse de lado | `MoveInput` |
| Carrera | Espacio | Salto de panza | `SlideMotor.requestJump` |
- La X no choca entre VIP (lobby) y bajarse (resortera): el HUD del lobby solo existe en `Idle` y `Finished`.
- Celular y consola: sin controles táctiles; el control solo gira y salta → Q-07.

## Resortera
- Angel decidió: solo apunta hacia adelante (D-002); mouse y arrastre hacia atrás (D-005, D-022c).
- Claude eligió: rango de giro y elevación, velocidad mínima y máxima de lanzamiento, una persona a la vez por resortera, se baja sola si no lanza en `GameConfig.Slingshot.AimTimeoutSeconds`. Trayectoria predicha con puntos (`TrajectoryPreview`). Claves: `GameConfig.Slingshot.*`.
- El servidor valida distancia al subirse y al lanzar ([[sistemas]] § Resortera).
- Diseño visual v0.2 y medidas: [[nivel-1]] § Resortera.

## Vuelo
- Angel decidió: animación en el aire y al caer (D-004).
- Claude eligió: gravedad reducida mientras vuela (`GameConfig.Flight.GravityScale`), aletas abiertas, sin control durante el vuelo de lanzamiento. En saltos dentro de la carrera sí hay control parcial (`GameConfig.Slide.AirControl`).

## Deslizamiento
- Angel decidió: de panza (D-004); A/D y Espacio (D-009); efectos de movimiento (D-018).
- Claude eligió: toda la física (`GameConfig.Slide.*`): tope de velocidad, arrastre cuadrático, empuje cuesta abajo, giro. La física corre en el cliente; el servidor valida meta y peligros.
- No hay botón de frenar: los efectos de frenado salen al perder velocidad sola.

## Obstáculos y eliminación
- Angel decidió: tipos iniciales (D-003); chocar = ragdoll y muerte sin la muerte de Roblox (D-008); las rampas impulsan (D-017).
- Regla de alturas (Claude eligió; la usan los obstáculos de la pista navideña, D-031c): lo que mide ≤ 4 studs se salta; lo que mide ≥ 9 se esquiva.
- Tres formas de ser eliminado: choque de frente (lo detecta el cliente, `CrashSensor`, umbrales en `GameConfig.Crash`), pisar una parte con etiqueta `Hazard` (servidor) y caer bajo `GameConfig.Race.KillHeight` (servidor).
- En la pista navideña (D-027c; los valores los eligió Claude, sin aprobar) los dos primeros solo restan vida: el choque te tumba y te endereza en ~1 s, la caída te rescata sobre la pista; solo eliminan cuando la vida llega a 0. Las partes con atributo `Bumper` (barandales, bordes) rebotan sin chocar, y una ayuda de dirección gira sola con las curvas.
- Una carrera más corta que `GameConfig.Race.MinimumPlausibleSeconds` no cuenta: el servidor reinicia al jugador.

## Niveles
- Regla de Angel: cada nivel es más largo y complejo que el anterior, pero pasable.
- Hasta el 2026-11-13: orden 1 → 2 → 3 → 4 → 5 por los portales, el último se repetía (Q-03). Desde el 14 solo existe N1 y se repite.
- En el código los niveles se desbloquean en orden: para viajar al nivel N hay que haber terminado el N-1 (`ProgressService.isUnlocked`). Angel no lo ha decidido → Q-05.
- Fichas: [[nivel-1]] (en el juego) · [[nivel-2]] · [[nivel-3]] · [[nivel-4]] · [[nivel-5]] (descartados, D-027c).

## Sin definir
Objetivo final, multijugador, alcance del MVP y monetización → [[PREGUNTAS]].
