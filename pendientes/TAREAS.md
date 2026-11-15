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
- Rango y velocidades de la resortera; arrastre hacia atrás = más fuerza (D-002, D-022c).
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
- Todo lo marcado en D-049a y D-050a: qué piezas se cortaron, mover la pista vieja a respaldo en vez de borrarla, eventos y carrera en pausa, reparto de obstáculos, fin de bioma en el borde de una pieza, distancia en "m".
- Estadísticas de las 5 skins y la fórmula de Abrigo y Resistencia (Q-27a); cómo se avisa el frío (número que flota, letrero, escarcha, pingüino azulado) y sus umbrales (`EndlessConfig.Cold`).
- Huevos y bases (D-052a): huevos sorteados por bajada y no por semana, tabla de rarezas por bioma, tecla T, dónde y cómo son las alas y parcelas, E pone el huevo más raro, qué pingüinos se exhiben, las 7 skins provisionales y sus estadísticas.
- D-053a y D-054a: forma del arco, mensajes en fila, cómo se señalan las bases, ambientes por bioma, pesos y precios de la tienda rotativa, lugar del salón y la ruleta.

## Fases
| Fase | Objetivo | Estado |
|---|---|---|
| 1. Planeación | concepto, ciclo, mecánicas, alcance del MVP | falta objetivo, multijugador y MVP (Q-15, Q-16, Q-17) |
| 2. Prototipo | resortera + deslizamiento jugable | hecho: 5 niveles, lobby y economía |
| 3. Vertical slice | un nivel completo con arte y feedback, probado | falta jugarlo y ajustar (T-01) |
| 4. Contenido y progresión | más pistas, mejoras, guardado | guardado hecho; progresión definida en D-038a a D-044a, en tres partes (frío + huevos + incubación + tienda → nivel y evolución → tradeo); falta el mapa (Q-28a) |
| 5. Lanzamiento | pulido, monetización, publicación | sin empezar |
