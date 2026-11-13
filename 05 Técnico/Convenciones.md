---
tipo: tecnico
---
# Convenciones

- Código e identificadores en inglés.
- Sin comentarios innecesarios: nombres declarativos que expliquen qué es cada cosa.
- Principios SOLID; ModuleScripts con una responsabilidad.
- GUIs con patrón MVP → [[D-006 Patrón MVP para las GUIs]]
- Sin rastros de IA en código, commits ni PRs.
- Notas del vault en español.

## Trabajo en Roblox Studio con Claude
- Editar scripts con la herramienta de edición de scripts (`multi_edit`), no asignando `.Source` desde `execute_luau`: si el script está abierto en Studio, el cambio puede revertirse sin avisar.
- Después de editar, verificar el código guardado (y probar en Play) antes de darlo por hecho.
- El "adelante" del juego es **-Z** (LookVector de Roblox): pingüino, resortera y pista; no invertir el eje.
- Las piezas del mapa se conectan por etiquetas (ver [[Arquitectura]]); si se rehace una pieza hay que volver a etiquetarla.
