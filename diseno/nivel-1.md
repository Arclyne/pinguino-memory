---
tipo: nivel
nivel: 1
nombre: Bajada infinita
folder: Workspace.PenguinSlingshotMap_v01
origen_x: 0
base_y: 600
verificado: 2026-11-18 (frío reencendido por Angel, D-061a: en Play con bot la vida bajó con la distancia, 0.625 cada 100 studs con la skin Inferno en el bioma 1; lo demás sigue como el 17: pista cerrada probada en Play con bot: ~4,100 m girando a los lados, saltando y empujado de lado a 400 studs/s sin salir; obstáculos en movimiento e huevos vistos en Play; biomas nuevos y frío apagado por ciervo: trazado de 15 biomas revisado con el generador en modo edición y piezas vistas en Play desde una cámara fija; no se bajó por ellos jugando. Antes, 2026-11-14, escrito y probado en Play: lanzamiento desde el lobby, ~5,800 studs con bot, choques, frío, cambio de bioma, pantalla de muerte, REINTENTAR y regreso solo al lobby, estadísticas de la skin Glacial y avisos de frío; obstáculos y props revisados con rayos sobre las 9 piezas; huevos levantados, tirados y asegurados con bot; nadie lo jugó a mano)
---
# Nivel 1 · Bajada infinita (D-045a, D-050a)

Es la bajada del juego: sale de la resortera del lobby (D-050a). La pista navideña de antes (D-027c) está guardada en `ServerStorage.Respaldo_MapaViejo.ChristmasRun`; su ficha anterior está en el historial de git. En Workspace el nivel solo tiene la meseta, el lobby (D-014), la resortera y la montaña de la avalancha.

## Cómo se juega
- La pista no existe en el servidor. Cada cliente la arma alrededor del jugador (`EndlessConfig.Streaming`) con piezas de `ReplicatedStorage.EndlessPieces` y la borra al pasar. Desde el lobby se ve el inicio. El orden sale de la semilla de la semana, igual para todos (D-045a).
- Empieza en `EndlessConfig.WorldOrigin`, el mismo punto donde empezaba la pista navideña, y baja hacia -Z. Sin meta ni portal.
- La vida máxima es la Vida de la skin puesta, sin curación (D-048a). El frío está encendido (D-061a; ciervo lo apagó el 17 solo para ver los biomas, D-058c; interruptor `EndlessConfig.Cold.Enabled`): quita `Cold.DamagePerStud` por stud y crece `Cold.GrowthPerBiome` en cada bioma (D-038a). Choque: `Damage.Crash`. Caída: `Damage.Fall` y rescate sobre la pista. Nada quita vida hasta aterrizar del lanzamiento (D-030c).
- Sin vida: pantalla de muerte (D-037a) con la causa (choque, caída o frío), bioma, distancia, tiempo, peces, velocidad máxima y golpes; REINTENTAR o LOBBY.
- HUD propio: distancia, barra de vida, bioma y velocidad. Los mensajes (bioma nuevo, te estás congelando, huevos) son solo texto, sin fondo, y salen de uno en uno (D-053a).
- Cada bioma termina en un arco que cruza la calle con el nombre del siguiente bioma; al cruzarlo tus huevos quedan a salvo (D-047a, D-053a). No hay último bioma: siguen sin fin. Al cruzar cambia el ambiente (hora, luz y tinte): cada tema nuevo trae el suyo en `EndlessConfig.Biome.Looks` (D-058c); si no tiene, sale del ciclo de `EndlessConfig.Ambience` (D-054a). En el lobby vuelve al normal.
- Para que el frío se note: una línea dice cuánta vida quita cada 100 m, cada punto perdido flota junto a la barra, sale "¡TE ESTÁS CONGELANDO!" al cruzar `EndlessConfig.Cold.WarningFractions`, y bajo `Cold.FrostStartsBelow` la pantalla se escarcha por los bordes y el pingüino se pone azulado, más mientras menos vida queda.
- Un bioma mide al menos `EndlessConfig.Biome.MinimumLength` y termina donde acaba una pieza. Orden fijo de 14 temas (`Biome.ThemeRotation`, nombres en `Biome.DisplayNames`, D-058c): Navideño, Desierto Dorado, Selva Salvaje, Volcán de Lava, Playa Tropical, Bosque de Otoño, Cañón del Oeste, Pantano Sombrío, Bosque de Hongos, Tierra de Dulces, Cueva de Cristal, Jardín de Cerezos, Ciudad Neón, La Luna; luego se repite.
- Las estadísticas del pingüino (D-039a) salen de la skin puesta (`SkinCatalog`, campo `stats`): Vida, Abrigo (menos frío) y Resistencia (menos daño por choque; la caída no cambia). Con 100 de Abrigo o Resistencia el daño baja a la mitad. Los valores de las 5 skins son de Claude, sin aprobar (Q-27a). El Impulso de la resortera no existe todavía.
- La avalancha (D-029c) sigue: cinemática al subirse y ola que persigue al inicio.

## Huevos en la bajada (D-040a, D-041a, D-042a)
- En cada bioma salen de `EggConfig.Spawn.MinimumPerBiome` a `Spawn.MaximumPerBiome` huevos, flotando sobre la pista con uno de los diseños aprobados de su rareza (D-060c), grandes y con aura de su color (D-059c): burbuja que late, anillo en el piso, columna de luz de 220 de alto, chispas, contorno visible a través de todo y letrero con la rareza. La rareza sale de `EggConfig.RarityWeightsByBiome`: en el bioma 1 todos comunes, y más lejos se van quitando las rarezas bajas.
- Se levanta al pasar cerca (`EggConfig.Pickup.Radius`). Llevas `EggConfig.Carry.BaseSlots` a la vez (el gamepass dará más); se ven abajo a la izquierda. T, o el botón TIRAR, tira el que llevas para poder levantar otro.
- Al entrar al siguiente bioma los huevos que llevas quedan asegurados y pasan a tu base. Si te quedas sin vida antes, se pierden.
- Claude eligió (sin aprobar): los huevos de cada bajada se sortean al lanzarte (posición, cuántos y rareza), no salen de la semilla de la semana, para que nadie se aprenda dónde sale el raro; la tabla de probabilidades; la tecla T.
- Falta: el gamepass de cupo y la tecla en control.

## Piezas del bioma navideño
Cortadas de la pista navideña en puntos donde iba recta hacia -Z (las crestas de las curvas), para encadenarlas solo moviéndolas. Cada pieza va partida en rebanadas de 100 studs.

| Pieza | Studs de la pista navideña | Zonas |
|---|---|---|
| Start (solo al inicio) | 0–1305 | Colina, con la zona ancha de aterrizaje |
| CandyForestEntry | 1305–2243 | Colina → Bosque |
| CandyForest | 2243–3159 | Bosque |
| TownSquare | 5684–6423 | Pueblo → Centro |
| Downtown | 6423–7255 | Centro |
| DowntownGarage | 7255–8193 | Centro → Garaje |
| SantaGarage | 8193–9109 | Garaje |
| GarageWorkshop | 9109–9774 | Garaje → Taller |
| ToyWorkshop | 9774–10698 | Taller |

- Llevan calle, rieles, suelo, edificios, decoración, turbos, topes, rampas y pilas de regalos. No llevan atajos (los huecos del riel se rellenaron), arcos de zona ni los obstáculos sueltos.
- Fuera: la zona 7 (calle más ancha), el tramo 3159–5684 (el más pesado) y el Puente.
- Obstáculos: 45 modelos de las zonas 1 a 6. El generador los reparte según `EndlessConfig.Obstacles` y evita los turbos, rampas y pilas de cada pieza. La calle navideña tiene peralte en las curvas: cada obstáculo se apoya inclinado igual que la calle (antes quedaban volando de un lado).
- Peso: ~38,400 instancias en `ReplicatedStorage`; en juego hay ~6,000 armadas a la vez. Workspace bajó de ~107,000 a ~19,800 instancias.

## No se puede salir de la pista (D-059c)
- Cada pieza lleva paredes invisibles `GuardWall` (rebotan, `Bumper`) justo afuera del borde de su calle y rieles, medido con rayos; la pieza guarda ese borde en `GuardLeft` y `GuardRight`. Las arma `ClaudeBuild.EndlessGuardBuilder` (`run(tema)`, `runAll()`); hay que correrlo otra vez si se rehace una pieza.
- Además, el cliente revisa cada cuadro que el pingüino no pase ese borde (`EndlessConfig.Fence`); si lo pasa, lo regresa y le quita la velocidad hacia afuera.
- Antes había huecos de riel en 7 de las 9 piezas navideñas y la zona ancha del aterrizaje no tenía bordes.

## Obstáculos en movimiento (D-059c)
- Cada bioma tiene 4 obstáculos más (`ClaudeBuild.EndlessObstacleBuilder`), casi todos en movimiento, y salen más seguido que los viejos (atributo `Weight`). Movimientos (atributo `Motion`): cruzar la calle de lado a lado mirando a donde va, avanzar hacia el jugador (rodando si es bola o tronco), saltar, girar como molinete o columpiarse; los mueve `Client.Endless.ObstacleMotion` solo cerca de la cámara, con la hora del servidor.
- Navideño: trineo, bola de nieve, reno y muñeco patinador. Desierto: camello, rodadora, escorpión, sarcófago. Selva: tronco rodante, serpiente, mono en liana, rinoceronte. Volcán: bola de lava, golem, roca que salta, chorro de lava. Playa: cangrejo, pelota, carrito de helados, tortuga. Otoño: calabaza rodante, tractor, remolino de hojas, carretilla. Cañón: diligencia, vagoneta, rodadora, cactus. Pantano: cocodrilo, rana gigante, tronco flotante, tocón. Hongos: hongo saltarín, caracol, molinete, hongo azul. Dulces: dona rodante, gomita, bastón giratorio, pastel. Cristal: péndulo, vagoneta, cristal flotante, estalagmita. Cerezos: rickshaw, dragón de papel, farol giratorio, linterna. Ciudad Neón: auto, taxi, moto, dron. La Luna: rover, meteorito, ovni, antena.

## Biomas nuevos (D-058c)
Los arma `ServerStorage.ClaudeBuild.EndlessBiomeBuilder` (`run("Desert")`, `themeNames()`; rehace `ReplicatedStorage.EndlessPieces.<Tema>`). Claude eligió (sin aprobar) todo lo de esta sección.
- 3 piezas `Run` por tema (780–920 studs), curva suave a un lado (dos a ±300 y una corta a ±130, para que el generador pueda corregir el rumbo) y bajada de ~0.25 por stud; sin peralte, sin turbos ni rampas. Ninguna es `Start`: el catálogo usa la primera `Run` si falta.
- Cada pieza: calle de 64 con raya central (de neón en los temas de noche), rieles `Bumper` con franja de color, banquetas, suelo de 1000 de ancho con el material del tema y manchas de otro color (D-025c), postes con luz cada 36 studs, props cerca (60–190) y más grandes lejos (190–340), y paisaje al fondo (pirámides, volcanes, faro, rascacielos, la Tierra en el cielo…). ~1,300–2,200 instancias por pieza; ~61,000 en total.
- Obstáculos propios (4–5 por tema, con `Hitbox` invisible): p. ej. cactus gigante y escarabajo (Desierto), tótem y cabeza de piedra (Selva), géiser y cráter de lava (Volcán), cangrejo y sombrilla (Playa), auto y conos (Ciudad Neón), robot y satélite (La Luna).

## Lo que ya no hay (D-050a, Q-33a)
Meta, portal de regreso, premios por zona y por llegar, peces en la bajada, atajos, curación, el mar y las montañas del fondo, el HUD navideño (cronómetro grande, récord de velocidad, trucos en el aire). Eventos de la bajada y carrera programada: en pausa.

## Falta (T-16a)
Peces repartidos por el generador, música por bioma (D-047a), tienda, Impulso de la resortera, gamepasses y récord de distancia.

## Sin probar
- Bajar por los biomas nuevos (choques con sus obstáculos, arco, ambiente, huevos más allá del bioma 2); el bot murió a ~4,100 m, todavía en el navideño. Si los obstáculos en movimiento se pueden esquivar bien a mano. El letrero del huevo no salió en las capturas y el peso en celular de ~61,000 instancias más.
- Jugado a mano, con control y en celular. Dos jugadores a la vez. La caída con rescate. El cambio de semana con alguien bajando.
- Más allá de ~6,000 studs. Límites lejanos: `FallenPartsDestroyHeight` (-9000) se alcanza cerca de los 40,000 studs y la precisión falla hacia los 100,000 (D-048a).
- Rendimiento en celular: en la Mac fue 60 fps y el cuadro más lento 21–64 ms.

## Reconstrucción de las piezas
```lua
local cutter = require(game.ServerStorage.ClaudeBuild.EndlessPieceCutter:Clone())
for _, id in cutter.pieceIds() do cutter.cut(id) end
cutter.cutObstacles()
```
Rehace `ReplicatedStorage.EndlessPieces.Christmas` desde `ServerStorage.Respaldo_MapaViejo.ChristmasRun`. Si se borra ese respaldo ya no se pueden cortar más piezas navideñas.
