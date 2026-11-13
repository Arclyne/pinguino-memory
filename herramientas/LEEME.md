# Herramientas

Todas se corren desde cualquier carpeta con `python3 herramientas/<nombre>.py`.

## ver.py (leer)
- `ver.py inicio`: estado, huella guardada, bitácoras recientes, tareas del grupo `ahora` y conteo de preguntas. Es lo primero de cada sesión.
- `ver.py decisiones|preguntas|tareas`: una línea por registro (`id | tema o grupo | estado | título`).
- `ver.py decisiones D-016` o `ver.py preguntas avalancha`: con un ID o un texto imprime el registro completo si hay 3 o menos coincidencias; si hay más, la lista.

## nuevo.py (escribir)
- `nuevo.py decision "Título" --tema niveles` · `nuevo.py pregunta "Título" --grupo juego` · `nuevo.py tarea "Título" --grupo ahora` · `nuevo.py bitacora`
- Pone el ID (siguiente número + letra de la persona), el nombre del archivo y el encabezado. Imprime la ruta creada; después se completa el cuerpo.
- Sabe quién escribe por el archivo `.autor` (una palabra: la clave de `AUTORES.md`) o por `--autor`. Si falta, se detiene y lo dice.
- `--fecha AAAA-MM-DD` si la fecha del sistema no es la de la persona.

`registros.py` es el módulo común de las tres herramientas.

## verificar.py
`python3 herramientas/verificar.py` (funciona desde cualquier carpeta). Revisa: notas obligatorias, nombres repetidos, enlaces rotos, decisiones (índice = bloques, números seguidos, citas válidas), preguntas y tareas citadas que ya no existen, que las huellas de las dos notas generadas coincidan, marcadores de conflicto de git, formato e ID únicos de cada registro, que `place/sistemas.md` mencione cada script y etiqueta de `place/mapa-place.md`, una ficha por nivel, claves `GameConfig.*` / `EconomyConfig.*` citadas que existan en `place/valores.md`, fechas, tamaño de las notas de arranque y que `archivo/MANIFIESTO.md` liste todo. Termina en `OK (...)` o lista `ERROR` / `AVISO`.

## PlaceMap (generador del mapa de la place)
Vive en Studio: `ServerStorage.DevTools.PlaceMap`. Copia idéntica: `herramientas/mapa_place.luau`. Si falta en la place, crear el ModuleScript con ese contenido.

Llamarlo desde `execute_luau` (datamodel Edit). **Siempre con `:Clone()`**: en modo edición `require` guarda en caché y devolvería una versión vieja.

```lua
return require(game.ServerStorage.DevTools.PlaceMap:Clone())({ "huella" })
```

| Secciones | Para qué | Va a |
|---|---|---|
| `huella` | saber si la place cambió (1 línea) | comparar con `huella:` de `place/mapa-place.md` |
| `huella`, `scripts` | lista de scripts con API, dependencias, remotes, etiquetas, atributos, teclas | `place/mapa-place.md` |
| `etiquetas`, `niveles`, `mundo` | etiquetas, anclas y medidas por nivel, prompts, personaje, ajustes | `place/mapa-place.md` |
| `huella`, `valores` | configuración y catálogos aplanados | `place/valores.md` |

### Regenerar una nota (solo viaja lo que cambió)
1. `python3 herramientas/parche.py base place/mapa-place.md` imprime una cadena hexadecimal (6 caracteres por línea de la nota).
2. En Studio, pasar esa cadena como segundo argumento. Devuelve un parche: `@parche …`, `=a-b` (copiar líneas viejas) y `+texto` (línea nueva).
   ```lua
   return require(game.ServerStorage.DevTools.PlaceMap:Clone())({ "huella", "scripts", "etiquetas", "niveles", "mundo" }, "<cadena>")
   ```
3. `python3 herramientas/parche.py aplicar place/mapa-place.md <<'EOF'` … pegar el parche … `EOF`. Comprueba la suma del resultado; si no coincide no toca la nota.
4. Lo mismo para `place/valores.md` con las secciones `{ "huella", "valores" }`.
5. Correr `verificar.py`: avisará de scripts, etiquetas o niveles nuevos que falten en las notas a mano.

Sin segundo argumento devuelve el texto completo (para crear la nota desde cero: todo lo que va de `# huella` al final).

La huella cambia si cambia cualquier script (incluido PlaceMap), el número de instancias de un nivel o el conteo de alguna etiqueta. No detecta que una pieza se movió sin cambiar el conteo.

Si se edita PlaceMap en Studio, copiar el cambio a `herramientas/mapa_place.luau`.
