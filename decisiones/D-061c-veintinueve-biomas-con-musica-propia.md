---
tipo: decision
id: D-061c
fecha: 2026-11-18
autor: ciervo
estado: vigente
tema: nivel-1
---
# D-061c · Veintinueve biomas con música propia
- Ciervo decidió (2026-11-18): 15 biomas más en la bajada (29 en total), con los mismos tipos de obstáculos que ya hay (fijos y en movimiento); música "movida y dopamínica" distinta en cada bioma; en la pista los huevos ya no llevan el letrero "HUEVO <RAREZA>", solo el aura, el tamaño grande y la columna de luz (cambia D-059c en eso).
- porqué: más variedad al bajar; el letrero sobraba porque el aura y el rayo ya dicen que es un huevo y su rareza.
- Claude eligió (sin aprobar):
  - Temas: Glaciar azul, Pradera florida, Arrecife de coral, Tierra de juguetes, Fábrica robótica, Valle jurásico, Bahía pirata, Reino medieval, Cielo arcoíris, Noche embrujada, Nebulosa galáctica, Parque de diversiones, Mina de oro, Cocina gigante y Sabana africana. Cada uno con 3 piezas, suelo con textura y parches (D-025c), adornos, monumentos de fondo, ambiente de luz, 2 obstáculos fijos y 3 en movimiento.
  - Orden fijo mezclando viejos y nuevos: Navideño, Desierto, Pradera, Selva, Juguetes, Volcán, Arrecife, Playa, Pirata, Otoño, Embrujada, Cañón, Sabana, Pantano, Jurásico, Hongos, Arcoíris, Dulces, Cocina, Cristal, Mina, Cerezos, Medieval, Neón, Fábrica, Feria, Glaciar, Luna, Nebulosa.
  - Música: una pista de la biblioteca pública de Roblox por bioma (IDs en `EndlessConfig.Biome.Music`), con cambio suave al entrar a otro bioma; se apaga al salir de la bajada. Se eligieron por título y género, sin escucharlas; las 29 cargan.
- sin decidir: si las pistas suenan bien (nadie las ha escuchado), si alguna trae voz, y si el lobby lleva música.
- dónde vive: `ClaudeBuild.EndlessBiomeBuilder` y `ClaudeBuild.EndlessObstacleBuilder` (`run(tema)`), `Shared.EndlessConfig` (`ThemeRotation`, `DisplayNames`, `Looks`, `Music`), `Client.Endless.BiomeMusic`, `Client.Eggs.EggAura` → [[nivel-1]].
