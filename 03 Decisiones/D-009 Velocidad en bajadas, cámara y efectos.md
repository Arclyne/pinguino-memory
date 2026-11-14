---
tipo: decision
id: D-009
fecha: 2026-11-12
estado: aceptada
---
# D-009 Velocidad en bajadas, cámara y efectos #decidido

## Pedido de Angel
- En las bajadas el pingüino debe ir "significativamente más rápido, pero que siga siendo posible de pasar".
- Que la cámara se aleje con la velocidad, con efectos visuales coherentes.
- Después: la cámara iba muy pegada al suelo; subirla para que se vean los obstáculos, sin que quede muy arriba.

## Qué se hizo
- **Velocidad:** en el suelo y de bajada se suma un empujón de 60% de la gravedad según qué tan empinado esté (`GameConfig.Slide.DownhillBoost = 0.6`, `DownhillMinimumSlope = 0.08`). Velocidad máxima de 120 → 145. En plano, subida y aire no cambia nada.
- **Cámara** (`Client.Race.ChaseCamera`): altura 11 studs, mira 16 studs adelante; a partir de velocidad 55 se aleja hasta 8 studs más y sube 6 más; tiembla un poco a tope.
- **Efectos** (`Client.Race.SpeedEffects`): líneas de velocidad en pantalla, nieve que salpica atrás del pingüino al tocar el suelo y estela azul clarita. Empiezan a velocidad 60.

## Para ajustar
- Más suave: `DownhillBoost = 0.4`; más intenso: `0.8`.
- Cámara: `HEIGHT_ABOVE` (9 más baja, 13 más alta).

## Relacionado
[[Deslizamiento]] · Código: `05 Técnico/PatchSpeedDownhill_v01.lua`, `05 Técnico/SpeedEffects.lua`
