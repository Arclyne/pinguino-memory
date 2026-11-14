---
tipo: diseno
estado: en-studio
actualizado: 2026-11-12
---
# Avalancha del nivel 1 #decidido

> Solo nivel 1. Es **solo visual**: nunca elimina al jugador. → [[D-010 Avalancha del nivel 1]]

## Por qué es coherente (de dónde sale)
- **Montaña** detrás de la meseta del nivel 1 (`PenguinSlingshotMap_v01.AvalancheMountain`): ladera nevada con rocas y pinos, picos arriba.
- **Cornisa agrietada** en la cima: 10 bloques de nieve colgando con grietas oscuras. De ahí se desprende la avalancha.
- **Torre de vigilancia** al borde de la meseta: pingüino vigía, sirena naranja (tag `AvalancheSiren`) y letrero "⚠️ PELIGRO DE AVALANCHA".

## 1. Cinemática al subirse a la resortera (~3 s)
1. Barras de cine; la cámara enfoca la cima; retumbo y sirena parpadeando.
2. La cornisa se rompe con destello blanco; baja la ola por la ladera.
3. Letrero **"¡SOBREVIVE A LA AVALANCHA!"** / "¡Lánzate antes de que te alcance!": píldora azul escarchada, borde de hielo, luces roja y azul de sirena, copos girando, brillo que la recorre, entra rebotando.
4. Antes de que la ola entre al lobby, **corte con pantalla blanca** (como nube de nieve) y aparece la vista de la resortera.
5. Fuera de cámara la ola cruza la meseta y se queda retumbando ~75 studs detrás de la resortera.

## 2. Persecución durante la carrera
- Letrero "¡LA AVALANCHA VIENE DETRÁS!".
- Te sigue toda la carrera. **Dos acercones** (~2 s y ~6.5 s): "¡TE ESTÁ ALCANZANDO! ¡Más rápido!", más temblor, escarcha en las orillas de la pantalla y polvo de nieve que pasa por delante.
- Después se queda atrás (lejos) hasta la meta.

## 3. Final en la meta (~3.5 s)
- Barras de cine; la cámara voltea hacia la pendiente.
- La ola llega frenando, las bolas se encogen y se hunden, los escombros caen, último soplo de polvo.
- Letrero **"¡SOBREVIVISTE!"** / "La avalancha se quedó atrás".
- La cámara regresa al pingüino.
- Si chocas o caes antes, la avalancha desaparece sin final.

## Efectos de la ola
30 bolas de nieve en 3 filas (blanco y azul hielo), nubes de polvo gigantes, bloques de hielo y **pinos arrancados** rebotando delante, rocío de nieve a ras del suelo, destellos de hielo, sombra azulada en el suelo.

## Clics
Mientras corren la cinemática y el final, una capa invisible bloquea los clics (no te lanza ni presiona botones del lobby). El teclado no está bloqueado.

## Pendiente #pendiente
- Angel debe probar los acercones y el final en una carrera completa.
- El botón del lobby "Evento Avalancha · Próximamente" sigue sin definir → [[Preguntas abiertas]]

## Técnico
- Cliente: `StarterPlayerScripts.Client.AvalancheCinematic` (arrancado por `LobbyMain`). Escucha el atributo `RunState` del jugador: Aiming → cinemática, Racing → persecución, Finished → final, Idle → limpia.
- Mundo: `05 Técnico/BuildAvalancheMountains_v01.lua` (solo construye en el nivel 1). Marcadores: `WaveStart`, `WaveEnd`, `ShotCamera`; folder con tag `AvalancheMountain`.
- Código: `05 Técnico/AvalancheCinematic.lua`.
