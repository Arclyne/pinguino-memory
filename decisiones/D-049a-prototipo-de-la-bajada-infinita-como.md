---
tipo: decision
id: D-049a
fecha: 2026-11-14
autor: angel
estado: reemplazada por D-050a
tema: progresion,niveles
---
# D-049a · Prototipo de la bajada infinita como nivel 6
- Angel decidió: 
- porqué: 
- Claude eligió (sin aprobar): 
- descartado: 
- dónde vive: 
- Angel pidió (2026-11-14): empezar la parte 1 (T-16a). Se construyó el primer paso: el mapa infinito ya se puede jugar con el bioma navideño, con frío, choques y obstáculos. Ficha: [[nivel-1]] (la del nivel 6 se borró con D-050a); código: [[sistemas]] § Bajada infinita.
- Claude eligió (sin aprobar):
  - Va como **nivel aparte (`LevelId` 6)** y se entra por el panel de niveles. La pista navideña (N1) no se tocó, para poder comparar y no romper nada. Falta decidir cuándo la reemplaza (Q-28a).
  - El 6 es para no pisar las fichas de nivel 3 a 5 (mapas del respaldo que serán biomas, D-047a).
  - Las piezas se cortan donde la pista navideña va recta hacia -Z, para encadenarlas solo moviéndolas (el adelante sigue siendo -Z). Son 8 piezas más la de salida; quedaron fuera la zona 7 (calle más ancha), el tramo más pesado del Pueblo y el Puente. Sin atajos.
  - Un bioma termina donde acaba una pieza, así que mide un poco más que el mínimo de D-048a.
  - La semilla es el número de semana de la tabla semanal.
  - El generador evita repetir la pieza anterior y corrige si la pista se va mucho hacia un lado.
  - Obstáculos: los 45 modelos de las zonas 1 a 6, uno cada ~170 a 240 studs, nunca sobre turbos, rampas o pilas de regalos de la pieza, ni en los primeros 650 studs.
  - La distancia se muestra en studs con la letra "m".
  - Al morir en este nivel reapareces en su meseta, con un letrero; todavía sin la pantalla de muerte de D-037a.
  - Caerse resta vida y te rescata, igual que en la pista navideña.
- porqué: probar que el mapa infinito funciona antes de meter huevos, tienda y lo demás (lo propuso Claude y Angel dijo "comienza").
- dónde vive: `Shared.EndlessConfig`, `EndlessCatalog`, `EndlessLayout`; `Services.EndlessRunService`; `Client.EndlessClient`, `Client.Endless.*`, `Client.Race.TrackGuide`; `ReplicatedStorage.EndlessPieces`; `Workspace.EndlessMode`.
