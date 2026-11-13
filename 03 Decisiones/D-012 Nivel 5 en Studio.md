---
tipo: decision
id: D-012
fecha: 2026-11-13
estado: aceptada
---
# D-012 Nivel 5 en Studio #decidido

## Decisión
- Angel aprobó la v0.2 del [[Nivel 5 Vecindario navideño]]: "perfecto, agrégalo de la misma manera que los demás niveles y que las ventanas se puedan romper".
- Vive en el mismo place, en X +24000. Al entrar al portal del nivel 4 el jugador pasa al spawn del nivel 5.

## Cómo quedó (técnico)
- Folder `PenguinSlingshotMap_Level5` con `LevelId = 5` y `WindowCount = 36`. Tiene las carpetas Terrain, Houses, Yards, Street, Decoration, Gameplay, Hazards y Mountains, más la resortera, su decoración y los pingüinos en fila (clonados del nivel 1, +600 en Y).
- Meseta de salida a Y 1200. La calle baja **7°** en línea recta, así que la velocidad se queda en unos 70–80 studs/s, como en el artefacto.
  - Todo el vecindario está construido sobre esa pendiente: las casas también van inclinadas.
  - Al final hay una zona plana (la meta queda a Y ~642 y el portal a Y ~637).
- Pista: 4,600 studs desde la resortera hasta la meta (Z 4580). Tiene 17 casas de 2 o 3 cuartos y la mansión, con patios de ~103 studs entre ellas.
- **Casas:** 90 de ancho y 30 de alto por dentro (46 las que se ven de dos pisos y 42 la mansión).
  - Las paredes chocan solo hasta 18 studs de alto. Lo de arriba, el techo y el tejado no chocan y no reciben raycasts, para que la cámara de la carrera no se suba al techo.
  - Las puertas entre cuartos miden 44 de ancho.
- **Ventanas:** cada casa tiene un ventanal de 56 × 18 en la entrada y otro en la salida, desde el piso.
  - Son modelos `BreakableWindow` (tag) de vidrio sin colisión, así que el pingüino siempre pasa aunque no salte.
  - Hay una rampa de hielo antes de cada entrada y otra dentro del último cuarto antes de cada salida.
- **Obstáculos:** cada cuarto tiene un mueble grande de un lado y otro más chico del otro. Entre los dos queda un pasillo de unos 26 studs. Antes de cada puerta hay un obstáculo bajo que se salta.
  - Chocar con un mueble cuenta como choque normal del juego (la carrera termina).
- **Bordes:** hay paredes invisibles a los lados de toda la pista (sin raycast) para que nadie se salga a la colina. Muy abajo hay un piso con tag `Hazard`.
- **Tags:** `PlateauSpawn`, `FinishLine` (Z 4580) y `ReturnPortal`. Este último es el portal clonado en Z 4700, sin `DestinationLevel`. El portal del nivel 4 ahora tiene `DestinationLevel = 5`.
- **Nuevo módulo de cliente `WindowBreaker`** (se inicia desde `LobbyMain`). Solo corre en el nivel 5 mientras se juega la carrera.
  - Cuando el pingüino cruza un ventanal, el vidrio desaparece en ese cliente y salen esquirlas, destellos y sonido. Aparece "¡CRASH!", "¡CRACK!", etc., y el contador "VENTANAS n/36".
  - Muestra el nombre de la casa.
  - Hace transparentes las paredes y el techo que quedan entre la cámara y el pingüino.
  - Las ventanas vuelven a aparecer en cada intento.
- **Panel de Niveles:** se agregó la tarjeta 5 "VECINDARIO NAVIDEÑO" (5 tarjetas por fila, con la etiqueta NUEVO).
- Scripts: `05 Técnico/BuildLevel5_v01.lua` y `05 Técnico/WindowBreaker.lua`. Para instalar: `Level5Install_v02.rbxmx`.

## Cambios contra el artefacto
- No hay trampolín ni rebote en la cama. Las casas de "dos pisos" solo se ven así por fuera y se recorren por la planta baja, porque con la física real no se puede asegurar llegar a una ventana alta.
- La ventana redonda de la mansión quedó como ventanal grande con letrero "¡FELIZ NAVIDAD!".

## Probado (Play en Studio)
- Viajar al nivel 5, subirse a la resortera y lanzarse funciona.
- El pingüino rompe los ventanales: el contador sube (1/36, 2/36…), sale el "¡CRASH!" y aparece el nombre de la casa.
- La velocidad dentro de las casas es de unos 70–79 studs/s.
- Pendiente: recorrer la pista completa esquivando con A/D. Desde aquí no se puede reaccionar a tiempo; en las pruebas el pingüino chocó con un mueble o con la orilla y la carrera terminó.

## Relacionado
[[Nivel 5 Vecindario navideño]] · [[D-005 Nivel 4 en Studio]] · [[Arquitectura]]
