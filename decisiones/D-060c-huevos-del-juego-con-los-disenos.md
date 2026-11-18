---
tipo: decision
id: D-060c
fecha: 2026-11-17
autor: ciervo
estado: vigente
tema: huevos
---
# D-060c · Huevos del juego con los diseños aprobados
- Ciervo decidió (2026-11-17): los huevos del juego usan los diseños que ya se habían hecho (D-055c, D-056c), no el óvalo provisional ("esos huevos ¿qué?").
- porqué: el óvalo con manchas no era el diseño aprobado.
- Claude eligió (sin aprobar):
  - Los 47 diseños se pasaron pieza por pieza desde el artefacto (mismas formas, colores, brillo y adornos fijos; 5,745 piezas) a modelos en `ReplicatedStorage.EggDesigns`. Sin el contorno negro, sin las partículas del artefacto y sin sus animaciones (en el juego el huevo gira y flota).
  - En la bajada y en los nidos, cada huevo usa un diseño de su rareza; en la bajada se elige con la clave del huevo, así que varía; en el nido sale siempre el primero de su rareza.
  - El aura de D-059c sigue alrededor; la columna de luz ahora sale por encima del huevo para no taparlo.
- sin decidir: qué diseño corresponde a qué bioma del juego (los 8 biomas de D-056c no son los 14 de D-058c) y que cada huevo dé su pingüino propio (D-056c); por ahora la rareza decide todo.
- dónde vive: `ClaudeBuild.EggDesignData` (datos) y `ClaudeBuild.EggDesignBuilder` (`runAll()` rehace `EggDesigns`); `Client.Eggs.EggAppearance` (`build(rareza, escala, semilla)`, `designFor`) → [[nivel-1]], [[lobby-economia]].
