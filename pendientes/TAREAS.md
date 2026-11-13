---
tipo: tareas
verificado: 2026-11-13
---
# Tareas

Solo lo pendiente. Lo terminado se borra y queda en la bitácora. Siguiente número libre: T-12.

## Ahora
- **T-01** (Angel) Jugar N1 → N5 seguidos con control y ajustar la sensación: `GameConfig.Boost`, `GameConfig.Feel`, `GameConfig.Slide`.
- **T-02** (Angel) Guardar la place en Studio (Ctrl+S): se agregó `ServerStorage.DevTools.PlaceMap`.
- **T-03** Responder los hallazgos de [[PREGUNTAS]] (Q-25, Q-01, Q-02, Q-05, Q-06, Q-12, Q-13, Q-14, Q-22).

## Probar
- **T-04** Session lock de DataKit con dos servidores: que el servidor viejo expulse al jugador.
- **T-05** Peces: ver jugando que el reparto queda sobre la pista en los 5 niveles (en N3 son techos con huecos; en N5 la pista cruza casas).
- **T-06** Saltos de N3, grietas de N4 y recorrido de N5 (Q-10).
- **T-07** Rendimiento de la decoración de N1 y N2 en celular.

## Construir
- **T-08** Controles de celular y consola (bloqueada por Q-07).
- **T-09** Validación en servidor: hoy el choque lo decide el cliente y no se valida la velocidad.
- **T-10** (Angel) Textura de studs del pingüino en Blender (Q-09).
- **T-11** Limpiar restos de ServerStorage y Workspace (bloqueada por Q-14).

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
