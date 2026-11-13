# Pingüino Resortera — memoria del proyecto

Este vault es la fuente de verdad del juego de Roblox **PINGUINO TEST** (placeId 76340917059535). Se sincroniza por GitHub (`Arclyne/pinguino-memory`). Si el vault contradice a la memoria del proyecto de Claude, gana el vault. Si el vault contradice a Studio, gana Studio y se corrige el vault.

## Al empezar (siempre, en este orden)
1. Leer `ESTADO.md`.
2. Leer la última nota de `bitacora/`.
3. Correr `python3 herramientas/verificar.py` y arreglar lo que marque.
4. Si Studio está conectado, pedir la huella: `return require(game.ServerStorage.DevTools.PlaceMap:Clone())({ "huella" })`. Si no coincide con `huella:` de `ESTADO.md`, la place cambió fuera del vault: regenerar `place/mapa-place.md` y `place/valores.md` (`herramientas/LEEME.md`), actualizar `place/sistemas.md` y anotar qué cambió en la bitácora.

## Dónde buscar (no leer todo)
| Necesito | Archivo |
|---|---|
| qué hay, qué falta, siguiente paso, frases gatillo | `ESTADO.md` |
| si algo ya se decidió o descartó | `decisiones/REGISTRO.md` (buscar `D-0xx` o `tema:`) |
| reglas del juego, ciclo, controles, mecánicas | `diseno/juego.md` |
| un nivel: zonas, obstáculos, decoración | `diseno/nivel-N.md` |
| lobby, peces, skins, ruleta, tabla, botones | `diseno/lobby-economia.md` |
| el pingüino: medidas, colores, rig | `diseno/personaje.md` |
| qué hace un sistema y qué scripts lo forman | `place/sistemas.md` |
| un script, etiqueta, atributo, remote o coordenada | `place/mapa-place.md` (generado; usar grep) |
| un número ajustable | `place/valores.md` (generado; usar grep) |
| dudas sin resolver | `pendientes/PREGUNTAS.md` |
| trabajo pendiente y elecciones sin aprobar | `pendientes/TAREAS.md` |
| scripts de construcción, artefactos, modelos, vault viejo | `archivo/MANIFIESTO.md` |

Buscar en todo: `grep -rn "texto" --include=*.md --exclude-dir=archivo .`

## Al cambiar algo (en el momento, no al final de la sesión)
- Angel decide algo → bloque nuevo en `decisiones/REGISTRO.md` y fila en su índice.
- Una pregunta se resuelve → se borra de `pendientes/PREGUNTAS.md`; su respuesta queda en una `D-0xx`.
- Una tarea se termina → se borra de `pendientes/TAREAS.md`.
- Cambio en Studio → actualizar `place/sistemas.md` si cambia qué hace un sistema; las notas generadas se regeneran al cerrar.
- Diseño nuevo o artefacto → su enlace va a la nota de `diseno/` que corresponda.

## Al cerrar (cuando Angel diga "cierra sesión" o se despida)
1. Si se tocó Studio: regenerar `place/mapa-place.md` y `place/valores.md`.
2. Actualizar `ESTADO.md`: lo que existe, lo que falta probar, siguiente paso, `huella`, `verificado`, `ultima_sesion`.
3. Escribir `bitacora/AAAA-MM-DD.md` (máximo 40 líneas: cambió / probado / sin probar / lecciones / siguiente).
4. Correr `python3 herramientas/verificar.py` hasta que diga `OK`.
5. Si se tocó Studio: recordar a Angel guardar la place (Ctrl+S).

## Reglas del contenido
- Un dato vive en una sola nota. Las demás lo citan (`D-0xx`, `Q-xx`, `T-xx` o un enlace wiki), no lo copian.
- Separar siempre **Angel decidió** de **Claude eligió**. Nada pasa a decidido sin que Angel lo confirme.
- No copiar números del código a las notas: citar la clave (`GameConfig.Slide.MaxSpeed`); el valor está en `place/valores.md`.
- Decir lo que no se sabe: si algo no se probó o no se leyó, la nota lo dice.
- Las notas con `generado: sí` no se editan a mano.
- Toda nota escrita a mano lleva `verificado: AAAA-MM-DD (contra qué)` en el encabezado.
- `archivo/` no es fuente de verdad: no se lee salvo que haga falta historia o reconstruir algo.
- Notas en español; código e identificadores en inglés.

## Reglas de código (Roblox)
- Sin comentarios, nombres declarativos, SOLID, GUIs en MVP (D-006). Sin rastros de IA en código, commits ni PRs.
- Editar scripts con `multi_edit`; nunca asignar `.Source` a un script que ya existe. Verificar el código guardado y probar en Play antes de darlo por hecho.
- En modo edición `require` guarda en caché: para leer un módulo actual, `require(modulo:Clone())`.
- El adelante es **-Z** (pingüino, resortera, pista). El mapa se conecta al código por etiquetas: si se rehace una pieza hay que volver a etiquetarla.
- Servicios nuevos se agregan a `Server.Main` (carrera) o `EconomyMain` (economía); en cliente a `Client.Main` o `LobbyMain`.
