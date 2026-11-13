---
tipo: guia-registros
verificado: 2026-11-13
---
# Preguntas abiertas

Cada pregunta es un archivo en `pendientes/preguntas/`. Solo existe mientras está abierta.

- Ver todas: `python3 herramientas/ver.py preguntas` · una: `ver.py preguntas Q-25` · por texto o grupo: `ver.py preguntas hallazgos`
- Crear: `python3 herramientas/nuevo.py pregunta "Título corto" --grupo niveles`. En el cuerpo: qué hay que decidir, qué se sabe y qué bloquea.
- Grupos en uso: `hallazgos` (algo encontrado en la place que alguien debe confirmar), `juego`, `alcance`, `controles`, `personaje`, `niveles`, `proyecto`.
- Resolver: crear la decisión que la responde y borrar el archivo de la pregunta. El verificador avisa de toda nota que la siga citando.
