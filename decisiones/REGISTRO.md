---
tipo: registro-decisiones
verificado: 2026-11-13 (migrado del vault v1; el código citado se comprobó en Studio)
---
# Registro de decisiones

Formato de cada bloque: **Angel decidió** = confirmado por Angel. **Claude eligió** = detalle de implementación que Angel no ha aprobado; se puede cambiar sin nueva decisión. `estado`: vigente | reemplazada por D-0xx | retirada. Nueva decisión = siguiente número libre, bloque al final y fila en el índice.

## Índice
| ID | Tema | Decisión en una línea | Estado |
|---|---|---|---|
| D-001 | concepto | Pingüino lanzado con resortera que se desliza por un acantilado esquivando estructuras | vigente |
| D-002 | resortera | La resortera solo apunta hacia adelante, sin ángulos de 90° | vigente |
| D-003 | obstaculos | Obstáculos iniciales: piedras, árboles, troncos partidos, rampas | vigente (rampas cambian con D-017) |
| D-004 | personaje | Se desliza de panza; animación en el aire y al caer | vigente |
| D-005 | resortera, controles | Mouse = dirección; arrastrar de atrás hacia adelante = fuerza | vigente |
| D-006 | codigo, gui | GUIs en MVP; SOLID; sin comentarios; código en inglés | vigente |
| D-007 | carrera | El pingüino es el jugador; se sube, apunta, se lanza, se mueve, salta de panza, choca, llega a la meta | vigente |
| D-008 | carrera, gui | Sin checkpoints; chocar = ragdoll y muerte sin la muerte de Roblox; GUI minimalista | vigente |
| D-009 | mapa, controles | Meseta de spawn, pendiente, A/D esquiva, Espacio salta, río con témpanos | vigente |
| D-010 | niveles | Nivel 2 en el mismo place (X +6000); el portal de N1 lleva a N2 | vigente |
| D-011 | niveles | Nivel 3 aprobado y construido (X +12000); portal N2 → N3 | vigente |
| D-012 | niveles | Nivel 4 aprobado y construido (X +18000, base Y 1200); portal N3 → N4 | vigente |
| D-013 | decoracion | Decoración festiva de N1 con público de pingüinos animado | vigente |
| D-014 | lobby, economia | El lobby es la meseta de N1; los peces son la moneda y se recogen en la pista | vigente |
| D-015 | datos | Datos del jugador con DataKit (paquete de Angel) | vigente |
| D-016 | niveles | Al terminar un mapa empieza solo el siguiente, ya montado en la resortera | vigente |
| D-017 | obstaculos | Las rampas que ya había dan impulso de velocidad con efectos | vigente |
| D-018 | efectos | Efectos por velocidad, frenado, giro y temblor a velocidad máxima | vigente |
| D-019 | decoracion | Decoración "Festival de Faroles" de N2 aprobada | vigente |
| D-020 | skins | Las skins son fieles al pingüino original; el tema va en accesorios y efectos | vigente |

## D-001 · Concepto base
- fecha: 2026-11-11 · estado: vigente · tema: concepto
- Angel decidió: el juego trata de un pingüino en una resortera. El jugador elige dirección y fuerza, lo lanza, cae a un acantilado de nieve y se desliza hasta abajo esquivando estructuras.
- ver: [[juego]]

## D-002 · Límite de ángulo de la resortera
- fecha: 2026-11-11 · estado: vigente · tema: resortera
- Angel decidió: la resortera solo apunta hacia adelante; no hay ángulos de 90°.
- Claude eligió: el rango exacto. Claves `GameConfig.Slingshot.MaxYawDegrees`, `MinPitchDegrees`, `MaxPitchDegrees`.
- abierto: Q-08 (aprobar el rango).

## D-003 · Tipos de obstáculos
- fecha: 2026-11-11 · estado: vigente · tema: obstaculos
- Angel decidió: los obstáculos iniciales son piedras, árboles, troncos partidos y rampas. Se pueden agregar más después.
- nota: desde D-017 las rampas impulsan en vez de estorbar.

## D-004 · Pose y animaciones del pingüino
- fecha: 2026-11-11 · estado: vigente · tema: personaje
- Angel decidió: se desliza de panza; tiene animación al estar en el aire y al caer.
- Claude eligió: las animaciones son por código sobre los Motor6D (`PenguinAnimator`), no assets de animación.

## D-005 · Controles de la resortera
- fecha: 2026-11-11 · estado: vigente · tema: resortera, controles
- Angel decidió: la dirección se controla con el mouse; la fuerza, arrastrando de atrás hacia adelante.
- Claude eligió: "hacia adelante" = arrastrar hacia arriba en pantalla (`GameConfig.Slingshot.DragForwardIncreasesPower` lo invierte).
- abierto: Q-07 (celular y consola).

## D-006 · Patrón MVP y estilo de código
- fecha: 2026-11-11 · estado: vigente · tema: codigo, gui
- Angel decidió: todas las GUIs siguen MVP (Model–View–Presenter). Todo el código sigue SOLID, sin comentarios innecesarios (nombres declarativos) y en inglés.
- nota: el HUD de carrera (`Client.Gui`) sí está en MVP. El lobby (`LobbyHud`, `Panels`, `UiKit`) construye la GUI por código sin esa separación → Q-12.

## D-007 · Jugabilidad base del recorrido
- fecha: 2026-11-11 · estado: vigente · tema: carrera
- Angel decidió: el pingüino es el personaje del jugador. Se sube a la resortera, apunta y se lanza. Al deslizarse se mueve y salta de panza. Hay choques. El recorrido termina en la meta. Lleva sonidos y partículas al deslizarse. El frente y el lanzamiento van hacia -Z; no se invierte el eje.
- Claude eligió: todo lo demás del prototipo (gravedad reducida en vuelo, una persona por resortera, tiempo límite para apuntar). Lista en [[TAREAS]] § elecciones sin aprobar.

## D-008 · Choque mortal, sin puntos de control, GUI minimalista
- fecha: 2026-11-11 · estado: vigente · tema: carrera, gui
- Angel decidió: no hay puntos de control. Al chocar no te puedes mover: ragdoll y mueres. La muerte no usa la muerte normal de Roblox (se sentía rara). Hay animación de salto. La GUI es minimalista y no estorba. En la meta no hay panel, solo el tiempo.
- porqué: correcciones de Angel al jugar el prototipo v1. Sustituye las propuestas de aturdimiento y de regreso al checkpoint.
- Claude eligió: tras el ragdoll (`GameConfig.Crash.RagdollSeconds`) el servidor hace `LoadCharacter`. Caer al río o a una grieta también elimina. Roces de lado no cuentan.

## D-009 · Mapa base y controles al deslizarse
- fecha: 2026-11-11 · estado: vigente · tema: mapa, controles
- Angel decidió: el spawn está en una montaña plana y amplia; abajo empieza la pendiente. Obstáculos: piedras, troncos tirados y árboles. A / D mueven de lado; Espacio salta. Hay un río con bloques de hielo que sobresalen y el pingüino salta de uno a otro.
- Claude eligió: la distribución de zonas y los obstáculos extra de [[nivel-1]].

## D-010 · Nivel 2 y portal entre niveles
- fecha: 2026-11-11 · estado: vigente · tema: niveles
- Angel decidió: el nivel 2 (Aldea Nevada) vive en el mismo place, lejos del nivel 1 para que no se vea. El portal del nivel 1 lleva al nivel 2.
- Claude eligió: separación de 6000 studs en X por nivel; cada nivel es un Folder con atributo `LevelId`; el jugador guarda su nivel en el atributo `LevelId`; el portal usa `DestinationLevel`.
- dónde vive: [[sistemas]] § Niveles.

## D-011 · Nivel 3 en Studio
- fecha: 2026-11-12 · estado: vigente · tema: niveles
- Angel decidió: aprobó el prototipo de la Ciudad Nevada; se construyó en el mismo place y el portal del nivel 2 lleva al nivel 3.
- Claude eligió: huecos y lados de la pista con partes invisibles `Hazard` (`HazardKind = Pit`); los techos de relleno también eliminan.
- ver: [[nivel-3]]

## D-012 · Nivel 4 en Studio
- fecha: 2026-11-12 · estado: vigente · tema: niveles
- Angel decidió: aprobó el prototipo del Valle del Avión; se construyó en el mismo place y el portal del nivel 3 lleva al nivel 4.
- Claude eligió: base a Y 1200 (los demás a Y 600) porque la pista baja ~1,000 studs y terminaría bajo `GameConfig.Race.KillHeight`. Ciervos quietos, sin script. El piso del valle es `Hazard`.
- ver: [[nivel-4]]

## D-013 · Decoración festiva del nivel 1
- fecha: 2026-11-12 · estado: vigente · tema: decoracion
- Angel decidió: aprobó toda la decoración del artefacto "Nivel 1 · Decoración v0.1" y pidió meterla. Los pingüinos del público saltan y agitan las aletas. Todo queda fuera de la pista o sin colisión: la jugabilidad no cambia.
- Claude eligió: animación solo en cliente por etiquetas; solo se animan los pingüinos cerca de la cámara.
- dónde vive: [[sistemas]] § Decoración animada · [[nivel-1]]

## D-014 · Lobby en la meseta y peces como moneda
- fecha: 2026-11-12 · estado: vigente · tema: lobby, economia
- Angel decidió: el lobby es la meseta del nivel 1 (donde está la resortera), no un lugar aparte. Los peces son la moneda; se ganan en cada nivel, dispersos por el mapa estilo las monedas de Subway Surfers. Los precios en Robux aún no están decididos (dejarlos configurables).
- ver: [[lobby-economia]]

## D-015 · DataKit para los datos del jugador
- fecha: 2026-11-13 · estado: vigente · tema: datos
- Angel decidió: los datos del jugador se guardan con DataKit, su paquete (`Arclyne/data-kit`), en `ServerStorage.Packages.DataKit`.
- porqué: el `ProfileService` casero guardaba con `SetAsync` sin session lock y, si la carga fallaba, daba un perfil vacío que luego pisaba los datos reales. DataKit tiene lease en MemoryStore más fencing token, y este juego le sirve de segundo caso real.
- descartado: manejador casero (podía borrar datos). ProfileStore de loleris queda como plan B.
- consecuencias: si la carga falla o tarda más de 60 s se expulsa al jugador en vez de darle un perfil vacío; si otro servidor toma la sesión se le expulsa del viejo; si DataKit falla, lo arregla Angel en su paquete.
- dónde vive: [[sistemas]] § Datos.

## D-016 · Avance automático al siguiente nivel
- fecha: 2026-11-13 · estado: vigente · tema: niveles
- Angel decidió: al terminar un mapa empieza solo el siguiente y el jugador queda arriba de la resortera, listo para lanzarse.
- Claude eligió: espera `GameConfig.Race.AutoAdvanceSeconds` tras la meta; el siguiente nivel es el `DestinationLevel` del portal (el último nivel no tiene, así que se repite); entrar al portal antes adelanta el avance; si la resortera está ocupada, llega a la meseta en `Idle`.
- abierto: Q-03 (qué pasa al terminar el último nivel).

## D-017 · Rampas de impulso
- fecha: 2026-11-13 · estado: vigente · tema: obstaculos
- Angel decidió: las rampas dan un impulso de velocidad con efectos; se usan las rampas que ya había.
- Claude eligió: qué piezas (N1 `Obstacles.SnowMound`, N2 las 3 tablas que suben de `Obstacles.Bridge`, N3 `Obstacles.ramp_39.Ramp`; N4 no tiene); etiqueta `BoostRamp`; valores de `GameConfig.Boost`; flechas de neón cian con `PulseGlow`.
- abierto: Q-04 (rampas en N4).

## D-018 · Efectos de movimiento
- fecha: 2026-11-13 · estado: vigente · tema: efectos
- Angel decidió: efectos por velocidad, efectos al frenar, efectos al moverse a izquierda y derecha, y temblor de pantalla a velocidad máxima.
- Claude eligió: qué se ve en cada uno y los umbrales (`GameConfig.Feel`). No hay botón de frenar: el efecto sale cuando el pingüino pierde velocidad solo.
- dónde vive: [[sistemas]] § Cámara y sensación.

## D-019 · Decoración "Festival de Faroles" del nivel 2
- fecha: 2026-11-12 · estado: vigente · tema: decoracion
- Angel decidió: aprobó el artefacto "Nivel 2 · Festival de Faroles · Decoración v0.1" y pidió meterlo a Studio otro día, con las mismas reglas que D-013 (todo fuera de la pista o sin colisión).
- nota: en el vault v1 esto vivía como nota de diseño "aprobado-pendiente", sin número. Ya está construido (`FestivalDecoration` en N2), pero ninguna bitácora registra la sesión que lo metió → Q-01.
- ver: [[nivel-2]]

## D-020 · Skins fieles al pingüino original
- fecha: 2026-11-12 · estado: vigente · tema: skins
- Angel decidió: las skins conservan el diseño principal (cuerpo negro, panza blanca, pico y patas naranjas, mismas proporciones); el tema va en accesorios y efectos, "con mucha más dopamina".
- nota: en el vault v1 era una regla dentro de la nota de lobby, sin número.
- Claude eligió: las 4 skins, sus rarezas y precios en peces (`SkinCatalog` en [[valores]]).
