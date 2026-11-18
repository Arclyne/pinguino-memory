---
tipo: decision
id: D-064c
fecha: 2026-11-18
autor: ciervo
estado: vigente
tema: economia
---
# D-064c · Panel de resorteras, peces de prueba y cinco canciones por bioma
- Ciervo decidió (2026-11-18): las resorteras tienen su propio apartado con vista previa y precio; solo él, probando desde Studio, recibe 3,000,000 de peces; el letrero de velocidad pasa del centro a arriba y a tamaño mediano; al menos 5 canciones por bioma, nostálgicas y acordes al juego (referencia: "Zzz" de Kyle Allen Music, banda sonora de Roblox High School), para que no se repitan al morir pronto.
- porqué: probar compras sin jugar horas; que la música no harte.
- Claude eligió (sin aprobar):
  - Botón RESORTERAS (tecla N) junto a IMPULSO y panel `slingshots`: 9 tarjetas con la resortera del lobby girando en 3D con el color y material de su nivel, nombre, metros extra, cuántos biomas salta y botón de precio, USAR o EQUIPADA. En la TIENDA queda solo una tarjeta "Resorteras · VER TODAS".
  - Peces de prueba: en Studio, al cargar el perfil del UserId 2843877121, los peces suben a 3,000,000 si hay menos. En el juego publicado no corre. Ojo: si Studio usa el DataStore real, esos peces quedan en ese perfil.
  - 145 canciones (5 por bioma, sin repetir entre biomas) de la biblioteca pública de Roblox, sobre todo de Joejoe Chow (funk, vaporwave, chiptune), Patte (niveles retro), Headphone Hero (arcade) y Willbe (espacio), elegidas por título y tema del bioma, sin escucharlas. Cada bioma las toca en orden aleatorio sin repetir hasta acabar las 5 y la siguiente empieza al terminar la anterior.
- sin decidir: si las canciones gustan (nadie las ha escuchado).
- dónde vive: `Panels.SlingshotPanel`, `LobbyHud`, `Panels.ShopPanel`, `Services.DevTestService`, `Shared.EndlessConfig` (`Biome.Music`: lista por tema), `Client.Endless.BiomeMusic`, `Client.Race.HyperSpeedFx` → [[lobby-economia]], [[nivel-1]].
