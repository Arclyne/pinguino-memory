---
tipo: diseno
verificado: 2026-11-17 (huevo de los nidos cambiado al diseño aprobado, sin verlo en un nido; antes, 2026-11-14: HUD del lobby y eventos leídos del código y probados en Play; bases, nidos y panel de huevos probados en Play el 14; botón del Modo Avalancha probado en Play)
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
| `MostPopular` | Podio "Más populares" | panel `skins` |
| `LevelsPortal` | Portal de niveles | panel `levels` |
| `Shop` | Tienda | panel `shop` |
| `PenguinCampfire` | Fogata con pingüinos (la agregó ciervo el 2026-11-13) | — |
Desde D-054a el Salón de la Fama está al fondo al centro y la ruleta al fondo a la izquierda, para no tapar las bases; el portal de niveles, el pedestal del evento y los pedestales de skins de la tienda se retiraron (guardados en `Respaldo_MapaViejo.LobbyRetirado`), igual que el botón NIVELES y la tarjeta de Próxima carrera. Si alguna fila de esta tabla habla de ellos, ya no aplica.

Posiciones: `grep -n "Lobby:" place/mapa-place.md`. Construido por `ServerStorage.ClaudeBuild.BuildLobby`; después ciervo movió varios objetos a mano el 2026-11-13. Hay un arco, dos iglús y tres pingüinos "cute" con animación propia, y el lobby tiene su propia exposición y bloom (`LobbyLighting`).

## Puestos (D-034a)
Diseño del vault viejo (2026-11-12); no se ha comparado con lo que hay hoy en Studio. Artefacto: https://claude.ai/artifact/GRYqXN7gF3MqDQxUEKVo36 (código en `archivo/construccion/PuestosLobby_artefacto_v01.html`).
- **Chocolate** (`ChocolateStall`, donde estaba el `CocoaStand`): cabaña de troncos con repisas de frascos y galletas, postes de bastón de dulce, toldo rojo y crema con nieve y carámbanos, letrero "CHOCOLATE" con foquitos que corren y taza gigante que gira, olla de cobre con vapor, pingüino chef, faroles que se mecen.
- **Tienda** (`Lobby.Shop`, E abre la tienda): puesto turquesa y blanco con adornos dorados, letrero "TIENDA" con foquitos y diamante flotando, vitrina con gemas que giran, pedestales con el Inferno y el Glacial bajo un haz de luz, vendedor con sombrero de copa.
- Correcciones que quizá no se aplicaron: T-15a.

## HUD del lobby (visible solo en `Idle` y `Finished`)
| Botón | Tecla | Panel | Estado |
|---|---|---|---|
| ¡LANZAR! | R | — | funciona: monta en la resortera (D-021c); botón verde |
| Ruleta | P | `wheel` | funciona |
| Tienda | G | `shop` | funciona con peces (huevos de la hora, impulso, giros; la tarjeta Resorteras abre su panel); Robux = "pronto" |
| Skins | K | `skins` | funciona: vista 3D y equipar; ya no se compran (D-052a) |
| Mi base | J | `eggs` | funciona: nidos, huevos guardados, incubar, abrir e ir a tu base (D-052a) |
| Regalo | Y | `gift` | funciona |
| Impulso | B | `boost` | funciona |
| Tabla | L | `leaderboard` | funciona |
| Invitar | U | `invite` | abre la invitación de Roblox; premios por invitar = fachada |
| Pack inicial | H | `starter` | fachada (PRÓXIMAMENTE) |
| VIP | X | `vip` | fachada |
| Personalizar | C | `custom` | fachada |
| Renacer | Z | `rebirth` | fachada |
| Lanzarse con un amigo · x2 peces | F | `friend` | fachada |
| Modo Avalancha (arriba) | — | — | funciona: "¡JUGAR!" o cuánto falta; al tocarlo te sube a la resortera del modo (D-033c) |
Arriba a la derecha: contador de peces y aviso de impulso activo.

## Reglas de la economía (como están en el servidor)
- **Peces en la pista (solo Modo Avalancha desde D-050a; en la bajada infinita faltan, Q-33a):** el servidor los reparte al arrancar, en grupos sobre carriles, desde poco después de la resortera hasta poco antes de la meta; no pone peces sobre `Hazard` ni sobre carpetas con "Obstacle" en el nombre. La misma semilla por nivel da siempre el mismo reparto. Solo cuentan en `Racing`; cada pez se cobra una vez por carrera. Valen `EconomyConfig.Fish.ValuePerPickup`, o el doble con impulso activo.
- **Impulso x2:** se compra con peces; el tiempo se acumula. También sale en la ruleta.
- **Regalo diario:** una vez cada `DailyGift.CooldownSeconds`; la racha sube el premio según `DailyGift.Rewards` y se reinicia tras `StreakResetSeconds`.
- **Tienda rotativa (D-041a, D-054a):** arriba del panel TIENDA salen `EggConfig.Shop.OfferCount` huevos que cambian cada `Shop.RotationSeconds`, con cuenta regresiva; son los mismos para todos. Cada oferta se compra una vez por hora con peces (`Shop.Prices`) y el huevo va a MI BASE. Las rarezas altas salen poco (`Shop.Weights`). 
- **Música del lobby (D-065c):** 8 canciones nostálgicas, una al azar cada vez que reapareces o vuelves de la bajada; calla mientras apuntas en la resortera, donde suena la avalancha de la cinemática (D-067c).
- **Resorteras mejoradas (D-062c, D-064c, D-065c):** la que tienes puesta se ve en las resorteras del juego (cada quien ve la suya); botón RESORTERAS (tecla N) con su panel: cada tarjeta muestra la resortera girando en 3D con el color de su nivel; Ramita Novata 1,000 · Bronce Rebotón 3,000 · Plata Saltarina 8,000 · Pepita Dorada 20,000 · Diamante Escarchado 45,000 · Trineo Cohete 90,000 · Rayo Pingüinero 180,000 · Cometa Polar 350,000 · Aurora Arcoíris Suprema 700,000 peces (nombres de D-066c) (+400 a +28,000 m; desde la Turbo saltan biomas). Se compran en orden; la nueva queda puesta y puedes usar otra que ya tengas. Precios de Claude, sin aprobar.
- **Ruleta:** un giro gratis cada `Wheel.FreeSpinCooldownSeconds`; giros extra se compran con peces o salen de premio. Premios y probabilidades en `WheelCatalog`. El premio de skin es Inferno; si ya la tienes, da peces. El premio se entrega al terminar la animación.
- **Skins:** 12 en `SkinCatalog`: la clásica gratis y 11 que nacen de huevos según su rareza (campo `hatchesFrom`). Siete son provisionales (Bufanda, Gorrito, Orejeras, Elegante, Explorador, Aurora, Sombra; D-052a). Ya no se compran con peces: el panel dice de qué huevo sale cada una y cuántas copias tienes. Se equipan; el servidor viste al personaje. Cada una tiene Vida, Abrigo y Resistencia (D-039a; qué hacen: [[nivel-1]]) y el panel las muestra bajo la descripción; valores sin aprobar (Q-27a).
- **Tabla:** tres categorías: peces de la semana, carreras de la semana y mejor tiempo. La de tiempo solo cuenta el nivel 1 (Q-13). La semana se reinicia sola.
- **Progreso:** terminar un nivel guarda cuántas veces y el mejor tiempo; desbloquea el siguiente (Q-05).
- Todo lo que cuesta se valida en el servidor y cada remote tiene límite de frecuencia: [[sistemas]] § Economía.

## Bases (D-052a)
- Cada jugador recibe al entrar una de las 12 parcelas, en dos alas a los lados de la meseta (6 y 6). Todos ven las de todos. Al salir se libera.
- Cada parcela tiene letrero con el avatar y nombre del dueño, 6 nidos al fondo (3 abiertos y 3 con candado para el gamepass de incubadora, D-042a) y 8 pedestales donde se paran sus pingüinos más raros.
- Incubar: en tu nido, E pone tu huevo más raro; o desde el panel MI BASE eliges cuál. Sobre el nido se ve el huevo (el primer diseño aprobado de su rareza, D-060c) y el tiempo que falta (`EggConfig.IncubationSeconds`, D-048a); corre aunque no estés conectado. Cuando dice ¡LISTO!, E o ABRIR hacen nacer un pingüino al azar de esa rareza. Los repetidos se guardan como otra copia.
- El panel MI BASE (J) también tiene IR A MI BASE, que te lleva a tu parcela.
- Para encontrarlas desde el lobby (D-053a): letreros BASES a cada lado, un camino dorado en el piso desde el centro, portería con banderines en cada parcela, el nombre del dueño flotando encima y un haz dorado con TU BASE sobre la tuya.
- Claude eligió (sin aprobar): dónde van las alas y su tamaño, el aspecto de la parcela, que E ponga el huevo más raro, cuántos pingüinos se exhiben y cuáles, y las skins provisionales con sus estadísticas.
- Falta: multiplicador de incubación por eventos (D-041a), gamepass de incubadora, y que el servidor admita solo 12 jugadores (hoy 60; T-17a).

## Skins (diseño v0.2, Claude eligió)
| Skin | id | Detalle |
|---|---|---|
| Inferno | `fire` | grietas de lava, cresta de llamas, bufanda de magma, ojos de brasa, anillo de fuego, chispas |
| Glacial | `ice` | todo de hielo con las manchas del pingüino, corona de cristales, fragmentos que orbitan, copos |
| Santa | `santa` | gorro con estrella, barba, bufanda a rayas, cinturón dorado, regalo, bastón de caramelo |
| Reno | `reindeer` | diadema de reno, astas con foquitos, nariz roja que brilla, cascabeles |
El artefacto ponía Glacial como premio del evento Avalancha; ese evento se quitó (D-033c) y el Modo Avalancha premia con peces, no con el Glacial.

## Sin definir
Precios en Robux, contenido del Pack inicial y VIP, qué es Renacer, cómo funciona "con un amigo" → [[PREGUNTAS]]. Eventos y carrera programada: D-032c.
