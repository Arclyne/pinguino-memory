---
tipo: diseno
verificado: 2026-11-13 (reglas leídas del código del servidor en Studio; no se jugó; Angel no ha revisado cómo quedó → Q-01)
---
# Lobby y economía

Precios, premios y tiempos: `grep -n "EconomyConfig\|SkinCatalog\|WheelCatalog" place/valores.md`.

## Angel decidió
- El lobby es la meseta del nivel 1 (D-014). Debe dar mucha "dopamina", inspirado en el lobby de otro juego de Roblox.
- Un camino hacia la resortera con pista oscura, orillas amarillas y flechas blancas animadas, como el del juego de referencia.
- Los peces son la moneda y se recogen dispersos en cada nivel, estilo Subway Surfers (D-014).
- Las skins son fieles al pingüino original (D-020).
- La ruleta y la tabla de la primera versión "estaban muy básicas": se rediseñaron (v0.2).
- Precios en Robux: sin decidir; dejarlos configurables.

## Artefactos de diseño
- Lobby + GUIs v0.2: https://claude.ai/artifact/6D4F2runEPTEayZfYHJu3t
- Skins v0.2: https://claude.ai/artifact/Pe7uwboKuDS4ZQzbGKT4HL
- Ruleta y tabla v0.2: https://claude.ai/artifact/GYxitWNYj5v3AkEE4gX4bV
- Código de referencia: `archivo/artefactos/`.

## Objetos del lobby (N1 `Lobby`)
| Carpeta | Qué es | Al presionar E abre |
|---|---|---|
| `ChevronRoad` | Camino de flechas a la resortera (11 `ChevronArrow` animadas) | — |
| `LuckyWheel` | Ruleta 3D de 12 gajos (`LobbyWheel`) | panel `wheel` |
| `HallOfFame` | Tabla y podio con maniquíes (`LobbyLeaderboard`, `PodiumMannequin`) | panel `leaderboard` |
| `EventPedestal` | Pedestal de la skin del evento Avalancha | panel `event` (fachada) |
| `MostPopular` | Podio "Más populares" | panel `skins` |
| `LevelsPortal` | Portal de niveles | panel `levels` |
| `Shop` | Tienda | panel `shop` |
| `PenguinCampfire` | Fogata con pingüinos (agregada el 2026-11-13, sin registro → Q-25) | — |
Posiciones: `grep -n "Lobby:" place/mapa-place.md`. Construido por `ServerStorage.ClaudeBuild.BuildLobby`; después se movieron varios objetos a mano (Q-25). Hay un arco, dos iglús y tres pingüinos "cute" con animación propia, y el lobby tiene su propia exposición y bloom (`LobbyLighting`).

## HUD del lobby (visible solo en `Idle` y `Finished`)
| Botón | Tecla | Panel | Estado |
|---|---|---|---|
| ¡LANZAR! | R | — | funciona: monta en la resortera (D-021c); botón verde |
| Ruleta | P | `wheel` | funciona |
| Tienda | G | `shop` | funciona con peces (impulso, giros); Robux = "pronto" |
| Skins | K | `skins` | funciona: vista 3D, comprar y equipar |
| Regalo | Y | `gift` | funciona |
| Niveles | Q | `levels` | funciona: viaja a niveles desbloqueados |
| Impulso | B | `boost` | funciona |
| Tabla | L | `leaderboard` | funciona |
| Invitar | U | `invite` | abre la invitación de Roblox; premios por invitar = fachada |
| Pack inicial | H | `starter` | fachada (PRÓXIMAMENTE) |
| VIP | X | `vip` | fachada |
| Personalizar | C | `custom` | fachada |
| Renacer | Z | `rebirth` | fachada |
| Lanzarse con un amigo · x2 peces | F | `friend` | fachada |
| Próxima carrera | N | `race` | fachada |
| Evento Avalancha · pronto | — | `event` | fachada |
Arriba a la derecha: contador de peces y aviso de impulso activo.

## Reglas de la economía (como están en el servidor)
- **Peces en la pista:** el servidor los reparte al arrancar, en grupos sobre carriles, desde poco después de la resortera hasta poco antes de la meta; no pone peces sobre `Hazard` ni sobre carpetas con "Obstacle" en el nombre. La misma semilla por nivel da siempre el mismo reparto. Solo cuentan en `Racing`; cada pez se cobra una vez por carrera. Valen `EconomyConfig.Fish.ValuePerPickup`, o el doble con impulso activo.
- **Impulso x2:** se compra con peces; el tiempo se acumula. También sale en la ruleta.
- **Regalo diario:** una vez cada `DailyGift.CooldownSeconds`; la racha sube el premio según `DailyGift.Rewards` y se reinicia tras `StreakResetSeconds`.
- **Ruleta:** un giro gratis cada `Wheel.FreeSpinCooldownSeconds`; giros extra se compran con peces o salen de premio. Premios y probabilidades en `WheelCatalog`. El premio de skin es Inferno; si ya la tienes, da peces. El premio se entrega al terminar la animación.
- **Skins:** 5 en `SkinCatalog` (clásica gratis + Inferno, Glacial, Santa, Reno). Se compran con peces y se equipan; el servidor viste al personaje.
- **Tabla:** tres categorías: peces de la semana, carreras de la semana y mejor tiempo. La de tiempo solo cuenta el nivel 1 (Q-13). La semana se reinicia sola.
- **Progreso:** terminar un nivel guarda cuántas veces y el mejor tiempo; desbloquea el siguiente (Q-05).
- Todo lo que cuesta se valida en el servidor y cada remote tiene límite de frecuencia: [[sistemas]] § Economía.

## Skins (diseño v0.2, Claude eligió)
| Skin | id | Detalle |
|---|---|---|
| Inferno | `fire` | grietas de lava, cresta de llamas, bufanda de magma, ojos de brasa, anillo de fuego, chispas |
| Glacial | `ice` | todo de hielo con las manchas del pingüino, corona de cristales, fragmentos que orbitan, copos |
| Santa | `santa` | gorro con estrella, barba, bufanda a rayas, cinturón dorado, regalo, bastón de caramelo |
| Reno | `reindeer` | diadema de reno, astas con foquitos, nariz roja que brilla, cascabeles |
El artefacto ponía Glacial como premio del evento Avalancha; el evento no existe todavía.

## Sin definir
Precios en Robux, contenido del Pack inicial y VIP, qué es Renacer, cómo funciona "con un amigo", carreras programadas, evento Avalancha → [[PREGUNTAS]].
