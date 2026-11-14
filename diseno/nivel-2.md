---
tipo: nivel
nivel: 2
nombre: Modo Avalancha
folder: Workspace.AvalancheMode
origen_x: -20000
base_y: 6500
verificado: 2026-11-14 (contra Studio en Play: entrada, 12 h, 450 km/h, saltos, choques, alcance, rampa y premio; place v154)
---
# Nivel 2 · Modo Avalancha (D-033c)

Usa el `LevelId` 2. El viejo N2 "Aldea Nevada" está descartado (D-027c) y guardado en `ServerStorage.Respaldo_MapaViejo.Niveles2a5`; su ficha anterior está en el historial de git.

## Cómo se juega
- Botón de arriba del lobby "MODO AVALANCHA · ¡JUGAR!" (o la cuenta de cuánto falta). Al tocarlo te sube directo a la resortera del modo. Una vez cada `AvalancheModeConfig.CooldownSeconds`, guardado en el perfil (`lastAvalancheMode`).
- No se puede llegar por el panel de niveles ni por portales (`ProgressService` lo bloquea).
- Bajada recta de `AvalancheTrack.Length` studs con pendiente `AvalancheTrack.Grade`, velocidad tope `GameConfig.Slide.LevelTuning[2].MaxSpeed` (~450 km/h). Con un bot dura unos 4 min 7 s.
- Se salta con espacio, de lado con A y D.
- La avalancha va detrás a `AvalancheModeConfig.StartGap`. Chocar con una barrera o muro: frena (`HitSpeedFactor`), la atraviesas, la avalancha queda a `HitGap` y la pantalla tiembla fuerte. Se recupera sola con el tiempo (`RecoverPerSecond`). Si chocas otra vez antes de que pase de `SecondHitGap`, te alcanza: pantalla blanca y vuelves al lobby con los peces que juntaste. Si vas muy lento mucho rato también se acerca.
- Sin vida ni daño en este modo; el HUD navideño no aparece.
- Al final, una rampa (`FinalRamp`) te lanza a un campo con marcas cada `AvalancheTrack.MarkerStep` (100 a 800, doradas desde 600). Premio: marca × `AvalancheModeConfig.RewardPerMarker` peces. A tope de velocidad se cae cerca de 500. Luego vuelves al lobby.

## Partes del mapa (`Workspace.AvalancheMode`)
| Parte | Qué es |
|---|---|
| Plateau | meseta con cartel, cercas y la resortera copiada del N1 |
| AvalancheMountain | copia de la montaña del N1 para la cinemática |
| Track | calle blanca, bancos, rieles rojos y muros invisibles (rebotan), rayas |
| Scenery | 6 zonas con arcos (Ladera Blanca, Bosque Helado, Cañón de Hielo, Glaciar Azul, Cumbres, Valle Final), pinos, picos de hielo, rocas, montañas lejanas |
| Obstacles | 60 `JumpBarrier` (de lado a lado, bajas) y 8 `DodgeWall` (tapan un lado); cada una con `TrackDistance`. Modelos `Persistent` |
| Finale | rampa, campo de distancias con números, letreros, pared final, `FinishLine` y `FishEnd`. Modelo `Persistent` |
| ReturnPortalGate | portal al lobby al final del campo |
| GroundTexture | parches de nieve (D-025c), 9,563 |

- ~2,000 peces en grupos (`EconomyConfig.Fish.LevelOverrides[2]`), hasta antes de la rampa.
- Tormenta (`StormDensity`) y aura roja en los `AuraLimit` obstáculos más cercanos dentro de `AuraRange`.

## Reconstrucción
`require(ServerStorage.ClaudeBuild.AvalancheModeBuild:Clone()).run()` y luego `require(ServerStorage.DevTools.GroundTexturer:Clone())(workspace.AvalancheMode, 1006)` (y borrar los parches que caigan en el campo).

## Sin probar
Con una persona real (solo con bot); en móvil; con varios jugadores a la vez (una sola resortera: si está ocupada te dice que esperes).
