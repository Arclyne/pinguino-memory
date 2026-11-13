---
tipo: guia-registros
verificado: 2026-11-13
---
# Registro de decisiones

Cada decisión es un archivo en esta carpeta (`D-NNN-titulo.md`). No hay índice escrito a mano: se consulta con el visor.

- Ver todas (una línea cada una): `python3 herramientas/ver.py decisiones`
- Una: `ver.py decisiones D-016` · por tema o texto: `ver.py decisiones niveles`
- Crear: `python3 herramientas/nuevo.py decision "Título corto" --tema niveles`. Luego completar el cuerpo y borrar las líneas que no apliquen.

## Formato del cuerpo
- `<Persona> decidió:` lo que confirmó una persona del equipo, con su nombre.
- `Claude eligió (sin aprobar):` detalle de implementación que nadie ha aprobado; se puede cambiar sin nueva decisión.
- `porqué:`, `descartado:`, `dónde vive:`, `abierto:` solo si aportan.

## Reglas
- `estado:` es `vigente`, `reemplazada por D-NNN` o `retirada`. Una decisión no se borra ni se reescribe: si cambia, se crea otra y la vieja se marca reemplazada.
- El ID lo pone `nuevo.py`: siguiente número más la letra de quien escribe (la de Angel es `a`). Así dos personas nunca crean el mismo ID. Las 20 primeras no llevan letra.
- Temas en uso: `concepto`, `resortera`, `controles`, `obstaculos`, `personaje`, `codigo`, `gui`, `carrera`, `mapa`, `niveles`, `decoracion`, `lobby`, `economia`, `datos`, `efectos`, `skins`.
