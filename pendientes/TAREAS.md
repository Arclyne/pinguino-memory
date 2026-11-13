---
tipo: guia-registros
verificado: 2026-11-13
---
# Tareas

Cada tarea es un archivo en `pendientes/tareas/`. No hay lista escrita a mano: se consulta con el visor.

- Ver todas: `python3 herramientas/ver.py tareas` · una: `ver.py tareas T-01` · por texto o grupo: `ver.py tareas probar`
- Crear: `python3 herramientas/nuevo.py tarea "Título corto" --grupo ahora` (grupos: `ahora`, `probar`, `construir`). Luego completar el cuerpo.
- Terminar: borrar el archivo y anotarlo en la bitácora. Quien la deja a medias cambia `estado:` y explica en el cuerpo.
- `responsable:` en el encabezado dice quién la hace; sin ese campo es de cualquiera.

## Elecciones de Claude sin aprobar
Detalles que Claude eligió para que algo funcionara. Valen hasta que Angel los cambie; si los aprueba, pasan a "Angel decidió" en su decisión.
- Rango y velocidades de la resortera; arrastre hacia arriba = más fuerza (D-002, D-005).
- Gravedad reducida y sin control en el vuelo de lanzamiento (D-007).
- Toda la física del deslizamiento: tope, arrastre, giro, salto (`GameConfig.Slide`).
- Una persona por resortera y tiempo límite para apuntar.
- Duración del ragdoll; caer al río o a una grieta elimina (D-008).
- Regla de alturas: ≤ 4 studs se salta, ≥ 9 se esquiva.
- Distribución de zonas y obstáculos de los niveles.
- Espera antes del avance automático y repetir el último nivel (D-016).
- Qué piezas son rampas de impulso y sus valores (D-017).
- Qué se ve en cada efecto de movimiento y sus umbrales (D-018).
- Toda la economía: valor del pez, precios en peces, premios y probabilidades de la ruleta, regalo diario, duración del impulso, rarezas y precios de skins.
- Desbloqueo de niveles en orden (Q-05).

## Fases
| Fase | Objetivo | Estado |
|---|---|---|
| 1. Planeación | concepto, ciclo, mecánicas, alcance del MVP | falta objetivo, multijugador y MVP (Q-15, Q-16, Q-17) |
| 2. Prototipo | resortera + deslizamiento jugable | hecho: 5 niveles, lobby y economía |
| 3. Vertical slice | un nivel completo con arte y feedback, probado | falta jugarlo y ajustar (T-01) |
| 4. Contenido y progresión | más pistas, mejoras, guardado | guardado hecho; progresión sin definir |
| 5. Lanzamiento | pulido, monetización, publicación | sin empezar |
