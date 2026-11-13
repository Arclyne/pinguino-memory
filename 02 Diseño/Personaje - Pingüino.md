---
tipo: diseno
estado: borrador
---
# Personaje — Pingüino

## Lo definido
- Estilo **tierno**, **cuadrado / bloques estilo studs de Roblox**, **sin bufanda** (pedido por Angel).
- Se desliza de panza → [[D-004 Pose y animaciones del pingüino]]

## Hoja de personaje v5 — bloques estilo Roblox #idea
- Dibujo plano (fase de planeación). Angel pidió: **más cuadrado, sin bufanda, estilo studs de Roblox**.
- Piezas rectas tipo Part, caras lisas, un tono de luz y uno de sombra por cara.
- Sin studs de bulto en la cabeza (se veían raros) y sin la textura de studs dibujada (Angel dijo que estaba mal). La textura se definirá en Blender.
- Modelo en Blender v1 armado con estas medidas (1 unidad = 1 stud): colección `Penguin` con 11 mallas emparentadas al Empty `Penguin`: `Body` (cuerpo + panza + cara en una sola malla cerrada, 2 materiales) y separadas patas, aletas, ojos (con brillo), chapitas, pico y cola, como pidió Angel, mide 3.00 × 2.61 × 3.10. Archivos: `05 Técnico/Modelos/pinguino.blend` y `pinguino.fbx`.
- En Roblox (place PINGUINO TEST): el pingüino es el **personaje del jugador** (pedido por Angel). Está en `StarterPlayer.StarterCharacter` con `Humanoid` (R15, HipHeight 0.3, RequiresNeck off) y `HumanoidRootPart` invisible de 2.4 × 2.8 × 2. Motor6D: `RootJoint`, `LeftShoulder`, `RightShoulder`, `LeftAnkle`, `RightAnkle`, `TailJoint`; pico, ojos y chapitas soldados al cuerpo. El frente del pingüino es -Z (el LookVector de Roblox), igual que la dirección de la resortera.
- Lienzo: https://claude.ai/artifact/A5fusUxf1ugrSok7gAHdoV — vistas de frente, ¾, lado y atrás; pose deslizándose (lado y arriba); colores y medidas.

| Medida | De pie | Deslizándose |
|---|---|---|
| Alto | 3.10 st · 0.87 m | 2.61 st · 0.73 m |
| Ancho con aletas | 3.00 st · 0.84 m | 3.86 st · 1.08 m |
| Fondo / largo | 2.61 st · 0.73 m | 3.10 st · 0.87 m |

| Pieza | Ancho × alto × fondo (st) |
|---|---|
| Cuerpo | 2.40 × 2.80 × 2.00 |
| Aletas (2) | 0.30 × 1.40 × 0.60 |
| Patas (2) | 0.80 × 0.30 × 1.00 |
| Pico | 0.30 × 0.18 × 0.24 |
| Cola | 0.30 × 0.30 × 0.25 |
| Ojos (2) | 0.28 × 0.28 |

Referencia: un jugador R15 mide ~5 studs; el pingüino queda a ~⅔ de su altura.

Colores: cuerpo `#2A3147` · panza/cara `#F7F8FC` · pico `#FFA53D` · patas `#FF8F1F` · chapitas `#FF9FB4` · ojos `#14161F`

Versiones descartadas: v2 low poly con bufanda (no era suficientemente cuadrado); v3 con studs de bulto en la cabeza (se veían raros); v4 con textura de studs dibujada (estaba mal).
Antes se hizo un modelo 3D (v1, redondo) que se descartó: el 3D va después de planeación. Copia en `02 Diseño/Prototipos/pinguino-3d.html`.

## Por definir #pendiente
- Aprobar o corregir la hoja de personaje v5 (proporciones, ojos, colores, accesorio, tamaño)
- Textura de studs (se hará en Blender)
- Animaciones: hoy son por código con los Motor6D → [[Prototipo jugable v1]]

Ver: [[Deslizamiento]] · [[Vuelo]]
