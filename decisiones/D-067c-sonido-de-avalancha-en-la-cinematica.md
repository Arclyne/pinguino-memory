---
tipo: decision
id: D-067c
fecha: 2026-11-18
autor: ciervo
estado: vigente
tema: nivel-1
---
# D-067c · Sonido de avalancha en la cinemática y anillos blancos
- Ciervo decidió (2026-11-18): al subirte a la resortera del lobby, durante la cinemática de la avalancha se quita la música y suena una avalancha, solo en la animación; en la bajada sigue la música normal. Los anillos que salen a alta velocidad pasan a ser blancos; los bordes arcoíris se quedan.
- porqué: la música del lobby tapaba la cinemática.
- Claude eligió (sin aprobar): retumbo de avalancha (ProSoundEffects 9113218938) que sube al romperse la cornisa, más un estruendo (9113216700); se apagan en 1 s al terminar la cinemática. La música del lobby también calla mientras apuntas (estado Aiming); vuelve si te bajas.
- dónde vive: `Client.AvalancheCinematic` (`cinematicSound`), `Client.LobbyMusic`, `Race.HyperSpeedFx` → [[nivel-1]].
