---
tipo: diseno
estado: aprobado-pendiente
version: v0.1
actualizado: 2026-11-12
---
# Nivel 2 · Decoración "Festival de Faroles" #decidido

> **Instrucción de Angel:** cuando diga **"agrega la decoración al nivel 2"**, Claude debe meter a Studio exactamente esta decoración, igual que se hizo con el nivel 1 ([[D-006 Decoración festiva del nivel 1]]).

- Artefacto aprobado: https://claude.ai/artifact/6UzmRzQXgsgLc2GiZK9nQL
- Código del artefacto (referencia de posiciones y formas): `05 Técnico/Nivel2Decoracion_artefacto_v01.html`
- Angel lo aprobó el 2026-11-12 pero pidió meterlo a Studio otro día.

## Qué incluye
| Grupo | Contenido |
|---|---|
| Entrada con campana | Campana que se mece sobre la puerta "ALDEA NEVADA", faroles de papel, letrero con mapa de la aldea, puesto de té caliente, aldeanos saludando |
| Vida en la aldea | Humo de chimeneas, coronas en las puertas, pingüinos asomados en ventanas, tendederos con bufandas, pingüinos con pala y montones de nieve, huellas, gatos en los techos |
| Festival de faroles | Cientos de faroles flotando sobre el pabellón (Z 670–826, muy arriba), cuerdas de faroles en Z 300, 480, 1000 y 1100, linternas que suben al cielo, dragón de tela con pingüinos a un lado (X −80) |
| Mercado festivo | Puestos de castañas (brasas y humo), bufandas, pescado y paletas con vendedores, carrusel de trineos (X −82, Z 1000), pingüino con acordeón y notas (X 80, Z 960) |
| Patinaje en el arroyo | Dos pistas de patinaje (X ±80, Z 1230) con pingüinos girando, uno que se resbala, pescadores en hoyos del hielo |
| Bosque encantado | Faroles colgando de los pinos, luciérnagas, búhos en las puntas que giran la cabeza, cabaña del leñador, ardilla |
| Fiesta en la meta | Pingüinos con tambores, cintas en la puerta "¡META!", gong que suena, estatua de hielo iluminada, lluvia de pétalos dorados |
| Paisaje | Pagoda iluminada en una colina, molino de viento girando, pueblo vecino con luces a lo lejos |

## Reglas para meterlo a Studio
- Todo fuera de la pista: entre los bancos de nieve (X ±62) y las casas (|X| ≥ 92), o muy por encima del pingüino. Lo que quede sobre la pista va sin colisión (CanCollide, CanQuery y CanTouch en false).
- Recordar que en Studio el nivel 2 está en X +6000; las coordenadas del artefacto son relativas al nivel.
- No tocar scripts del juego. Reusar el sistema de animación del cliente (`Client.Decoration`): tags `CheeringPenguin` y `SpinningDecor`, y `FlickeringFlame` para las brasas.
- Falta agregar: un módulo para faroles que se mecen y linternas que suben, y modos nuevos de pingüino (tambor, pala, acordeón, patinar, saludar) en `CheeringCrowd` o un módulo aparte.
- Script de construcción sugerido: `05 Técnico/BuildLevel2Decoration_v01.lua` (carpeta `FestiveDecoration` dentro del folder del nivel 2).

Relacionado: [[Nivel 2 - Aldea Nevada]] · [[D-006 Decoración festiva del nivel 1]]
