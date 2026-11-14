---
tipo: decision
id: D-033c
fecha: 2026-11-14
autor: ciervo
estado: vigente
tema: modos,eventos
---
# D-033c · Modo Avalancha cada 12 horas
- Ciervo decidió: el botón de arriba abre el Modo Avalancha, un mapa nuevo que te sube directo a su resortera. Es una bajada extrema de unos 4 minutos a 450 km/h con muchos peces. Los obstáculos son sobre todo barreras para saltar y algunos muros que se esquivan con A y D. Chocar no quita vida, solo frena y deja la avalancha muy cerca con la pantalla temblando; chocar dos veces seguidas hace que te alcance. Al final una rampa te lanza a un campo de distancias (como la imagen que mandó): más velocidad, más lejos. Se juega una vez cada 12 horas, lleva tormenta de nieve (pero se ve un poco más) y los obstáculos tienen aura para verlos de lejos. Difícil pero pasable.
- porqué: no lo dijo.
- Claude eligió (sin aprobar), porque Ciervo no contestó esas preguntas: piezas simples para llegar a 4 minutos; si la avalancha te alcanza termina la bajada y te quedas con los peces; se quita el evento Avalancha del servidor (D-032c) y solo queda la Nevada de peces. También eligió todos los números de `Shared.AvalancheModeConfig` y `Shared.AvalancheTrack`, la velocidad (`GameConfig.Slide.LevelTuning[2]`) y el valor de los peces del modo (`EconomyConfig.Fish.LevelOverrides`).
- descartado: el evento Avalancha programado para todo el servidor (reemplaza esa parte de D-032c).
- dónde vive: `Services.AvalancheModeService`, `Client.AvalancheModeClient`, `Workspace.AvalancheMode` → [[nivel-2]] y [[sistemas]] § Modo Avalancha.
