---
tipo: decision
id: D-011
fecha: 2026-11-12
estado: aceptada
---
# D-011 Iconos, menú del lobby, iluminación y puestos #decidido

## Iconos
- Angel: los emojis y los primeros iconos 3D se veían baratos. Se dibujaron iconos estilo simulador de Roblox (contorno grueso, degradados, brillo, destellos).
- Angel pidió rehacer: pez (quedó **pez dorado** con aletas de velo), renacer (**huevo dorado rompiéndose**), evento (**montaña con avalancha**), premio de fuego (**pingüino Inferno**).
- Dos hojas subidas a la cuenta de Angel: `rbxassetid://106021550852364` (17 iconos principales) y `rbxassetid://77665241141960` (34 extra). Fuentes en `05 Técnico/iconos/`.
- `IconText` cambia **cualquier emoji** de los textos del juego por su icono dibujado (lista en `HudIcons.KindByEmoji`).
- Los botones tienen vida (`HudLife`): saltitos, brillo, estrellitas en los NUEVO. ¡LANZAR! en modo clickbait (rayos, flechas que parpadean, "¡JUEGA YA!").

## Menú del lobby (por importancia)
- Izquierda, de grande a pequeño: RULETA, TIENDA / SKINS, REGALO / NIVELES, IMPULSO / TABLA, INICIAL, VIP.
- Derecha (botones alargados): PERSONALIZAR, RENACER (PRONTO), INVITAR.
- Ejemplo de Angel: ruleta = importante; invitar amigos = poco importante.

## Iluminación
- Viva pero sin saturar: sol de media tarde, sombras azuladas, bruma ligera, saturación +6 %, contraste +7 %, bloom solo en neón. Script: `05 Técnico/Iluminacion_v01.lua`.

## Puestos del lobby
- Diseño: [[Puestos del lobby]] · artefacto https://claude.ai/artifact/GRYqXN7gF3MqDQxUEKVo36
- Construcción: `05 Técnico/BuildStalls_v01.lua`.

## Relacionado
[[Lobby y skins]] · [[D-008 Lobby, economía y Festival de Faroles en Studio]]
