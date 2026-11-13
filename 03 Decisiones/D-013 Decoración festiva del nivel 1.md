---
tipo: decision
id: D-013
fecha: 2026-11-12
estado: aceptada
---
# D-013 Decoración festiva del nivel 1 y público animado #decidido

## Decisión
- Angel aprobó toda la decoración del artefacto "Nivel 1 · Decoración v0.1" (https://claude.ai/artifact/YGbXEhC78CCans6p68xAeE) y pidió meterla al juego.
- Los pingüinos del público saltan y agitan las aletas con alegría, igual que en el artefacto.
- Todo queda fuera de la pista o sin colisión: la jugabilidad no cambia.

## Cómo quedó (técnico)
- Folder `PenguinSlingshotMap_v01.FestiveDecoration` con Entrance, Crowd, Lights, Crystals, WildlifeAndWaterfall, LivelyCamp, FinishParty y Landscape (~4,900 partes, 191 pingüinos).
- Pingüinos del público: tag `CheeringPenguin`, atributos `CheerPhase` y `Cheers`. El `Body` está anclado; las aletas usan `Weld` (`FlipperLeftWeld` / `FlipperRightWeld`).
- Aro de lanzamiento: tag `SpinningDecor` (`SpinSpeed`). Fogata: tag `FlickeringFlame`.
- Animación solo en cliente: `StarterPlayerScripts.Client.Decoration` (CheeringCrowd, SpinningDecor, FlameFlicker, DecorationController). `Client.Main` hace `DecorationController.init()` después de `PresentationController.init()`.
- Solo se animan los pingüinos a menos de 380 studs de la cámara.
- Scripts: `05 Técnico/BuildLevel1Decoration_v01.lua` y `05 Técnico/InstallDecorationAnimation_v01.lua`.

## Probado
- En Play, el cliente ve 117 pingüinos (streaming); el más cercano sube y baja (Y 602.5 → 603.4) y las aletas cambian de ángulo. Sin errores en Salida.
- Pendiente: revisar el rendimiento en celular.

## Relacionado
[[Mapa]] · [[D-009 Mapa base y controles]] · [[Arquitectura]]
