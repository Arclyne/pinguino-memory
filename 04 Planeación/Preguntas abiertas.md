---
tipo: plan
---
# Preguntas abiertas

Al resolver una pregunta, se crea su decisión en `03 Decisiones` y se tacha aquí.

## Juego
- [x] ¿Cuál es el objetivo? (distancia, puntaje, llegar abajo, carreras)
- [x] ¿Qué pasa al chocar con una estructura?
- [x] ¿Qué pasa al llegar abajo?
- [x] ¿Single player o multijugador?
- [x] ¿Hay progresión? (mejoras de resortera, skins de pingüino, nuevos acantilados)

## Controles
- [ ] ¿Cómo se apunta y se elige la fuerza?
- [x] ~~¿Control al deslizarse?~~ → [[D-002 Mapa base y controles]]
- [ ] ¿Control en el aire?

## Alcance
- [ ] ¿Qué entra en el MVP?
- [ ] ¿Monetización? (gamepasses, productos) — precios en Robux aún sin decidir (en el juego salen como "Próximamente")
- [ ] ¿Qué hacen Renacer, "Lanzarse con un amigo", Próxima carrera y el evento Avalancha? (botones visibles con "Próximamente")
- [ ] ¿Cuántos peces vale cada pez y cuánto cuestan las skins? (valores de prueba en `EconomyConfig` y `SkinCatalog`)
- [x] ~~¿El lobby es aparte o la meseta del nivel 1?~~ → meseta ([[D-007 Lobby en la meseta y peces como moneda]])
- [x] ~~¿Cómo se ganan los peces?~~ → dispersos en cada nivel, estilo Subway Surfers ([[D-007 Lobby en la meseta y peces como moneda]])

## Mapa
- [ ] ¿Qué pasa si el pingüino cae fuera de la pista al lanzarlo?
- [x] ¿Qué pasa al caer al río?
- [x] ¿Cuánto debe durar una bajada?
- [x] ¿El cañón va a media bajada o al final?
- [ ] ¿Los saltos del nivel 3 (huecos de 20–22 studs) se sienten justos con la física real? Hay que probarlo jugando.
- [x] ~~¿Qué hace el portal del nivel 3?~~ → lleva al nivel 4 ([[D-005 Nivel 4 en Studio]])
- [x] ~~¿Qué hace el portal del nivel 4?~~ → lleva al nivel 5 ([[D-012 Nivel 5 en Studio]])
- [ ] ¿Qué hace el portal del nivel 5? (por ahora regresa al inicio del nivel 5)
- [ ] ¿Los ciervos deben moverse (animación de cabeza y cola) en el juego?
- [ ] ¿Los niveles se desbloquean en orden o se pueden elegir? (por ahora en orden: el panel Niveles abre el siguiente al terminar el anterior) #idea

## Avalancha
- [ ] ¿El "Evento Avalancha" del lobby será un modo aparte? ¿Cómo se gana la skin Glacial? (hoy el botón dice "Próximamente")
- [ ] ¿La avalancha del nivel 1 debería poder eliminar al jugador algún día, o se queda solo visual?
- [ ] ¿La cinemática completa sale cada vez o solo la primera vez por sesión?

## Nivel 5 (vecindario navideño)
- [ ] ¿Los pasillos de ~26 studs entre muebles se sienten bien jugando, o los quieres más anchos o con menos muebles? Hay que recorrerlo completo con A/D.
- [ ] Chocar con un mueble o con la orilla hoy termina la carrera, como en los otros niveles. ¿Así se queda en este nivel, o solo debería frenar?
- [ ] ¿Algún día agregamos el trampolín al segundo piso y el rebote en la cama del artefacto? (con la física real hay que asegurar que el pingüino llegue a la ventana)
- [ ] ¿Dar premio por romper las 36 ventanas? (por ejemplo, peces extra) #idea
- [ ] Rendimiento: el nivel tiene ~18,500 partes y ~4,500 foquitos. ¿Se siente bien en celular?
