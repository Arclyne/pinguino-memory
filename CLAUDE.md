# Pingüino Resortera — memoria compartida del proyecto

Este vault es la fuente de verdad del juego de Roblox **PINGUINO TEST** (placeId 76340917059535). Lo comparten varias personas, cada una con su Claude, y se sincroniza por GitHub (`Arclyne/pinguino-memory`). Si el vault contradice a la memoria de Claude, gana el vault. Si el vault contradice a Studio, gana Studio y se corrige el vault.

## Al empezar (siempre, en este orden)
1. Saber quién es la persona: su clave está en `.autor`; si falta, preguntarle, comprobarla en `AUTORES.md` y crear el archivo.
2. `python3 herramientas/ver.py inicio` (estado, bitácoras recientes de todos, tareas urgentes).
3. `python3 herramientas/verificar.py` y arreglar lo que marque. Un `ERROR` de conflicto o de ID repetido significa que alguien más sincronizó: resolverlo antes de trabajar.
4. Si Studio está conectado, pedir la huella: `return require(game.ServerStorage.DevTools.PlaceMap:Clone())({ "huella" })`. Si no coincide con la de `place/mapa-place.md`, alguien cambió la place: regenerar las notas de `place/` (`herramientas/LEEME.md`), revisar qué cambió, actualizar `place/sistemas.md` y anotarlo en la bitácora.

## Dónde buscar (no leer todo)
| Necesito | Cómo |
|---|---|
| qué existe, qué es fachada, qué falta probar | `ESTADO.md` |
| si algo ya se decidió o descartó | `python3 herramientas/ver.py decisiones [ID, tema o texto]` |
| dudas sin resolver | `python3 herramientas/ver.py preguntas [ID, grupo o texto]` |
| trabajo pendiente | `python3 herramientas/ver.py tareas [ID, grupo o texto]` |
| elecciones de Claude sin aprobar, fases | `pendientes/TAREAS.md` |
| reglas del juego, ciclo, controles, mecánicas | `diseno/juego.md` |
| un nivel: zonas, obstáculos, decoración | `diseno/nivel-N.md` |
| lobby, peces, skins, ruleta, tabla, botones | `diseno/lobby-economia.md` |
| el pingüino: medidas, colores, rig | `diseno/personaje.md` |
| qué hace un sistema y qué scripts lo forman | `place/sistemas.md` |
| un script, etiqueta, atributo, remote o coordenada | `grep` en `place/mapa-place.md` (generado) |
| un número ajustable | `grep` en `place/valores.md` (generado) |
| qué hizo cada quien y cuándo | `bitacora/AAAA-MM-DD-autor.md` |
| scripts de construcción, artefactos, modelos, vault viejo | `archivo/MANIFIESTO.md` |

Buscar en todo: `grep -rn "texto" --include=*.md --exclude-dir=archivo .`

## Dos clases de notas
- **Registros** (decisiones, preguntas, tareas, bitácora): un archivo por registro, creado siempre con `python3 herramientas/nuevo.py` (pone ID, nombre y encabezado). Nunca se inventa un ID ni se crea el archivo a mano. Como cada quien crea archivos distintos, no hay conflictos al sincronizar.
- **Notas de referencia** (`ESTADO.md`, `diseno/`, `place/sistemas.md`): una por tema; se editan en su lugar. No se crean notas de referencia nuevas sin que la persona lo pida: lo nuevo va en la nota del tema que ya existe.

## Al cambiar algo (en el momento, no al final de la sesión)
- Alguien decide algo → `nuevo.py decision`. Si cambia una decisión anterior, la vieja queda `estado: reemplazada por D-…`.
- Surge una duda que no se puede resolver ahora → `nuevo.py pregunta`. Al resolverse: decisión nueva y se borra el archivo de la pregunta.
- Queda trabajo pendiente → `nuevo.py tarea`. Al terminarla se borra su archivo.
- Cambio en Studio → actualizar `place/sistemas.md` si cambia qué hace un sistema, y la ficha de `diseno/` que toque.
- Cambia lo que existe en el juego (sistema nuevo, nivel nuevo, algo deja de ser fachada) → `ESTADO.md`.

## Al cerrar (cuando la persona diga "cierra sesión" o se despida)
1. Si se tocó Studio: regenerar `place/mapa-place.md` y `place/valores.md`.
2. `nuevo.py bitacora` y llenar la nota del día de esta persona (máximo 40 líneas: cambió / probado / sin probar / lecciones / siguiente). Si ya existe, se agrega a ella.
3. `python3 herramientas/verificar.py` hasta que diga `OK`.
4. Recordar a la persona: guardar la place (Ctrl+S) si se tocó Studio, y sincronizar el vault.

## Reglas del contenido
- Un dato vive en una sola nota. Las demás lo citan por ID o enlace wiki, no lo copian.
- Solo cuenta como decidido lo que confirmó una persona, y se anota quién. Lo que eligió Claude se marca **Claude eligió (sin aprobar)**.
- No copiar números del código: citar la clave (`GameConfig.Slide.MaxSpeed`); el valor está en `place/valores.md`.
- Decir lo que no se sabe: si algo no se probó o no se leyó, la nota lo dice.
- No editar la bitácora de otra persona. Las notas `generado: sí` no se editan a mano; si llegan revueltas tras sincronizar, se regeneran.
- Toda nota de referencia lleva `verificado: AAAA-MM-DD (contra qué)` en el encabezado.
- `archivo/` no es fuente de verdad: no se lee salvo para historia o para reconstruir algo.
- Notas en español; código e identificadores en inglés.

## Reglas de código (Roblox)
- Sin comentarios, nombres declarativos, SOLID, GUIs en MVP (D-006). Sin rastros de IA en código, commits ni PRs.
- Editar scripts con `multi_edit`; nunca asignar `.Source` a un script que ya existe. Verificar el código guardado y probar en Play antes de darlo por hecho.
- En modo edición `require` guarda en caché: para leer un módulo actual, `require(modulo:Clone())`.
- El adelante es **-Z** (pingüino, resortera, pista). El mapa se conecta al código por etiquetas: si se rehace una pieza hay que volver a etiquetarla.
- Servicios nuevos se agregan a `Server.Main` (carrera) o `EconomyMain` (economía); en cliente a `Client.Main` o `LobbyMain`.
