---
tipo: decision
id: D-069c
fecha: 2026-11-18
autor: ciervo
estado: vigente
tema: nivel-1
---
# D-069c · Ramales con puente alto y plataforma de planeo en cada bioma
- Ciervo decidió (2026-11-18): en vez de dividir la pista en opciones con letreros (D-068c), la pista tiene huecos en la baranda por donde salen ramales que el jugador toma si quiere, sin ningún cartel; puede salirse a los lados y todos los ramales regresan a la pista principal. Los puentes son altos de verdad. Cada cierto tiempo hay una plataforma que te lanza hacia arriba y te hace planear hacia adelante a máxima velocidad, y al caer no hay obstáculos.
- porqué: los 2 caminos con letrero (y luego 4 carriles con letrero) no eran lo que pedía; quería caminos libres, sin elegir en un cartel.
- Claude eligió (sin aprobar): pieza `<Tema>Paths` (1,500 studs, una por bioma, sale como 2.º tramo del bioma y también al azar): de la pista salen 2 ramales a los lados (hasta 150 studs), uno con **puente alto** de madera con pilares y luces y otro con **colinas** y 2 rampas al final; mientras tanto la pista principal baja a un valle de 58 studs, así que el puente queda ~60 studs sobre el suelo. Entre ramales y pista hay suelo libre con decoración. Pieza `<Tema>Glide` (1,400 studs, tramos 3 y 6 de cada bioma): plataforma rosa de neón que te lanza (75 studs de alto) y planeas 800 studs a 185 con ala delta de neón y estela arcoíris, pasando por 7 aros; aterrizaje suave sobre franjas marcadas. Sin obstáculos ni botiquines desde la plataforma hasta el final de la pieza. Ya no hay letreros (se quitó el de ¡A VOLAR!).
- medido en Play: planeo de 4.2 s, 781 studs, 73 de alto, aterriza a 186.
- reemplaza: la parte de caminos de D-068c (piezas `<Tema>Fork`, ya borradas).
- dónde vive: `ClaudeBuild.EndlessBiomeBuilder` (`buildPathsPiece`, `buildGlidePiece`, `runSpecials`), `ClaudeBuild.EndlessGuardBuilder` (usa `RoadHalf` en piezas `CustomSkin`), `Shared.EndlessCatalog` (`pathsPiece`, `glidePiece`), `Shared.EndlessLayout` (`biomeChunk`, `EndlessConfig.Layout.PathsChunk`/`GlideEvery`), `Race.SlideMotor` (planeo), `Race.GlideWing`, `Run.Modes.RacingMode` (`stopGlide`) → [[nivel-1]].
