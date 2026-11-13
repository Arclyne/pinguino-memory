---
tipo: diseno
verificado: 2026-11-13 (rig comprobado en Studio; la hoja de personaje sigue sin aprobar)
---
# Personaje: pingüino

## Angel decidió
- Estilo tierno, cuadrado, de bloques tipo studs de Roblox, **sin bufanda**.
- Se desliza de panza (D-004). Es el personaje del jugador (D-007). Su frente es -Z.
- La textura de studs se define en Blender (la dibujada estaba mal).

## Hoja de personaje v5 (sin aprobar → Q-09)
- Lienzo: https://claude.ai/artifact/A5fusUxf1ugrSok7gAHdoV
- Piezas rectas tipo Part, caras lisas. Sin studs de bulto y sin textura dibujada.

| Medida (studs) | De pie | Deslizándose |
|---|---|---|
| Alto | 3.10 | 2.61 |
| Ancho con aletas | 3.00 | 3.86 |
| Fondo / largo | 2.61 | 3.10 |

Colores: cuerpo `#2A3147` · panza y cara `#F7F8FC` · pico `#FFA53D` · patas `#FF8F1F` · chapitas `#FF9FB4` · ojos `#14161F`. Un jugador R15 mide ~5 studs; el pingüino queda a ~⅔.

## En Studio
- `StarterPlayer.StarterCharacter`. Piezas, medidas y uniones exactas: [[mapa-place]] § StarterCharacter.
- `HumanoidRootPart` invisible; `Body` es una unión (cuerpo, panza y cara). Motor6D: `RootJoint`, `LeftShoulder`, `RightShoulder`, `LeftAnkle`, `RightAnkle`, `TailJoint`. Pico, ojos y chapitas van soldados al cuerpo.
- `SlideCollider` (cubo invisible soldado a la raíz) es el colisionador del deslizamiento.
- Las skins se aplican sobre este rig (`SkinAppearance`); `SkinService` espera a `Body`, `Flipper_L` y `Flipper_R`. Renombrar esas piezas rompe las skins.
- Animaciones por código (`PenguinAnimator`), una por pose: Standing, Aiming, Flying, Landing, Sliding, Jumping, Airborne, Crashed, Celebrating.
- Patas muy cortas: no subía escalones caminando. `StepAssist` lo levanta en escalones bajos mientras camina.

## Blender
- `archivo/modelos/pinguino.blend` y `.fbx`: modelo v1 con las medidas de la hoja (1 unidad = 1 stud), 11 mallas bajo el Empty `Penguin`.
- El pingüino de Studio está armado con Parts; el modelo de Blender no está importado.

## Descartado
v1 3D redondo · v2 low poly con bufanda (no era suficientemente cuadrado) · v3 studs de bulto en la cabeza (se veían raros) · v4 textura de studs dibujada (estaba mal).
