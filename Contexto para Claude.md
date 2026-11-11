---
tipo: reglas
---
# Contexto para Claude

Reglas para mantener este vault como memoria del proyecto.

## Al empezar una sesión
1. Leer [[00 Índice]] (estado actual y siguiente paso).
2. Leer la última nota de `06 Bitácora`.
3. Revisar [[Registro de decisiones]] y [[Preguntas abiertas]] antes de proponer algo que ya se decidió o descartó.

## Al terminar una sesión
1. Crear/actualizar la nota de bitácora del día con la plantilla [[Plantilla Sesión]].
2. Cada decisión tomada → nota nueva en `03 Decisiones` (plantilla [[Plantilla Decisión]]) y fila en [[Registro de decisiones]].
3. Actualizar "Estado actual" en [[00 Índice]].
4. Mover preguntas resueltas de [[Preguntas abiertas]] a su decisión.

## Reglas del contenido
- Solo se marca como `#decidido` lo que Angel confirmó. Las propuestas de Claude van como `#idea` hasta que se aprueben.
- Notas en español; código, nombres de scripts e identificadores en inglés.
- Código: sin comentarios, nombres declarativos, principios SOLID.
- Sin rastros de IA en commits o PRs.
- Un tema por nota; enlazar con `[[ ]]` en vez de duplicar.
