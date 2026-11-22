---
tipo: decision
id: D-070c
fecha: 2026-11-22
autor: ciervo
estado: vigente
tema: nivel-1
---
# D-070c · Vista suave sin neón y ramales cerrados
- Ciervo decidió (2026-11-18 y 2026-11-22): nadie debe poder salirse del mapa en los ramales y puentes "por ningún motivo"; arreglar la iluminación del lobby (las bases se veían quemadas de blanco); el juego tenía demasiada "epilepsia": quitar los colores saturados y dejar algo agradable a la vista, sin tanto efecto, en el mapa y en la pantalla.
- porqué: la pantalla y la pista cansaban la vista; en un ramal el pingüino salió al suelo entre la pista y el puente y se atoró.
- Claude eligió (sin aprobar):
  - Pantalla: `HyperSpeedFx` solo deja +6 de campo de visión y una estela blanca tenue (sin letreros de velocidad, destello, tinte, chispas ni luz de colores; reemplaza esa parte de D-063c y D-064c). `SpeedEffects` con menos líneas (14), más transparentes y sin color de turbo. Contorno de obstáculos fijo y tenue, sin latido (D-065c). Huevos con aura más suave (luz, chispas, columna, latido). Flechas de las rampas encendidas fijas, sin parpadeo. Ala delta del planeo sin neón y estela blanca. Escarcha y temblor de la avalancha más leves.
  - Mapa: `ClaudeBuild.EndlessSoftLook` cambia todo el neón de las piezas y obstáculos a plástico liso y baja la saturación de los colores (lo de más de 0.5 se acerca a 0.5; brillo máx. 0.92); 59,370 partes sin neón. El constructor lo aplica solo al rehacer biomas.
  - Luz: bloom 0.15, saturación −0.05, contraste 0.03; el tinte por bioma se aplica al 40 %.
  - Lobby: la zona donde baja la luz se agrandó a X ±200, Z −40..200 para cubrir las bases nuevas.
  - Ramales: pieza `<Tema>Paths` de 1,800 studs; el ramal corre 150 studs pegado a la pista antes de abrirse, punta inclinada donde se separan, piel con la altura real en cada orilla (antes había escalón de hasta 0.76), barandas y paredes invisibles de 45 de alto y 8 de grueso a los dos lados del ramal y de la pista; sin la pared diagonal automática en esa pieza; cerco por código (`TrackFence` + `EndlessLayout.spansAt` con atributos `Branch1`, `Branch2`).
- medido: 0 fugas en 203,580 rayos laterales (pista, ramales, alturas 2–40) en los 29 biomas; entradas libres.
- pendiente: en Play, empujando al pingüino hacia el ramal por código, no logró entrar (se queda en la orilla de la pista); no se encontró la causa.
- dónde vive: `Race.HyperSpeedFx`, `Race.SpeedEffects`, `Race.GlideWing`, `Endless.ObstacleAura`, `Endless.ObstacleMotion`, `Endless.BiomeAmbience`, `Eggs.EggAura`, `Client.AvalancheCinematic`, `Client.LobbyLighting`, `Race.TrackFence`, `Shared.EndlessLayout`, `Shared.EndlessCatalog`, `ClaudeBuild.EndlessSoftLook`, `ClaudeBuild.EndlessBiomeBuilder`, `ClaudeBuild.EndlessGuardBuilder` → [[nivel-1]].
