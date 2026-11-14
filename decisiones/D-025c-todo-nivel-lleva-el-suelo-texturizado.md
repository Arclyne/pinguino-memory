---
tipo: decision
id: D-025c
fecha: 2026-11-13
autor: ciervo
estado: vigente
tema: decoracion, niveles
---
# D-025c · Todo nivel lleva el suelo texturizado
- Ciervo decidió: el suelo con tonos de blanco (D-024c) va en todos los niveles, y todo nivel nuevo que se agregue tiene que incluirlo.
- porqué: que todos los niveles se vean igual de cuidados.
- Claude eligió (sin aprobar): un generador reutilizable, `ServerStorage.DevTools.GroundTexturer` (`require(...:Clone())(nivel, semilla)`). Pone parches en las caras de arriba de las partes y cuñas blancas o azul hielo con colisión (≥ 600 studs², inclinación ≤ ~41°), solo en una franja de ±100 studs alrededor de la X de la resortera del nivel; sin colisión ni consultas; borra y rehace la carpeta `GroundTexture` del nivel. Semillas usadas: N2 1002, N3 1003, N4 1004, N5 1005. Resultado: N2 611, N3 1347, N4 1633, N5 712 parches (~4,300 partes más). N1 se dejó con su versión de D-024c.
- descartado: texturizar todo el mapa (N3 y N4 daban más de 20,000 parches por las ciudades y montañas de fondo).
- dónde vive: `DevTools.GroundTexturer` y el paso final de "Para agregar un nivel" → [[sistemas]].
