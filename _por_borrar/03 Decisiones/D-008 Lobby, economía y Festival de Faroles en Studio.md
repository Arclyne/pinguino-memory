---
tipo: decision
id: D-008
fecha: 2026-11-12
estado: aceptada
---
# D-008 Lobby, economía y Festival de Faroles en Studio #decidido

## Contexto
Angel dijo "agrega lo que no agregamos": meter a Studio todo lo de [[Pendiente de agregar a Studio]].

## Qué se agregó
- **Lobby en la meseta del nivel 1** (`PenguinSlingshotMap_v01.Lobby`): camino oscuro con orillas amarillas y flechas blancas que se encienden en ola hasta la resortera, ruleta de la suerte 3D con postes de bastón y foquitos, "Salón de la fama" con pantalla, podio de 3 pingüinos y corona, tienda, pedestal del evento con el pingüino Glacial, podio "Más populares" (Inferno, Santa, Reno) y portal de niveles. Cada cosa abre su panel con **E**.
- **GUIs del lobby** con sus paneles: Skins, Tienda, Ruleta, Niveles, Tabla, Impulso, Regalo diario, Invitar, VIP, Inicial y Personalizar.
- **4 skins** (Inferno, Glacial, Santa y Reno) sobre el pingüino original, con efectos.
- **Economía con peces:** se recogen al deslizarse en todos los niveles (filas de 5, estilo Subway Surfers); se guardan en DataStore `PenguinProfile_v1`.
- **Ruleta:** 1 giro gratis cada 24 h, o 1,000 peces por giro. 12 premios (peces, cofre, x2, giro extra, skin Inferno, jackpot 10K).
- **Tabla semanal:** peces, carreras y mejor tiempo del nivel 1.
- **Festival de Faroles del nivel 2** (`PenguinSlingshotMap_Level2.FestivalDecoration`): humo en chimeneas, coronas en puertas, ventanas encendidas, faroles flotando sobre el pabellón, faroles que suben al cielo, guirnaldas de foquitos, mercado con carrusel y músico, pista de hielo con patinadores, faroles y búhos en el bosque, luciérnagas, cabaña, molino, dragón del desfile, tambores, gong, pagoda y serpentinas en la meta, público y luces de aldeas lejanas.

## Lo que queda como "Próximamente"
Precios en Robux, evento Avalancha, Renacer, "Lanzarse con un amigo", Próxima carrera, VIP, paquete Inicial y la pestaña Amigos de la tabla.

## Técnico
- Código: `ReplicatedStorage.Shared` (SkinCatalog, SkinAppearance, WheelCatalog, EconomyConfig, EconomyRemotes), `ServerScriptService.Server.Services` (Profile, Skin, Fish, Wheel, Reward, Progress, Leaderboard) arrancados por `ServerScriptService.EconomyMain`, y `StarterPlayerScripts.Client` (LobbyHud, paneles, controladores) arrancados por `StarterPlayerScripts.LobbyMain`.
- Cambios a scripts existentes: `RunStateService.Changed` ahora manda el payload y `ReturnService` exporta `sendToLevel`.
- Instalación: `05 Técnico/ClaudeInstall_v02.rbxmx` + `Place_v01.lua`; mundo: `BuildLobby_v01.lua` y `BuildLevel2Festival_v01.lua`.
- En Studio los DataStores marcan error si no está activado "Acceso de Studio a servicios de API"; el juego sigue funcionando en memoria.

## Relacionado
[[D-007 Lobby en la meseta y peces como moneda]] · [[Lobby y skins]] · [[Nivel 2 - Decoración Festival de Faroles]]
