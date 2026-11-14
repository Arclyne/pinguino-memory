---
tipo: decision
id: D-022c
fecha: 2026-11-13
autor: ciervo
estado: vigente
tema: resortera, controles
---
# D-022c · Tensar la resortera arrastrando hacia atrás
- Ciervo decidió: la fuerza se carga arrastrando el mouse hacia atrás (abajo en pantalla), como al estirar una liga; arrastrar hacia arriba ya no tensa. La dirección sigue con el mouse (D-005).
- porqué: arrastrar hacia arriba para tensar no era lógico.
- Claude eligió (sin aprobar): cambiar solo `GameConfig.Slingshot.DragForwardIncreasesPower` a falso (el código ya tenía las dos opciones) y el texto de ayuda `StarterGui.GameHud.AimBar.Hint` a "Clic y arrastra hacia atrás · X para bajar".
- descartado: nada.
- dónde vive: `AimInput` → [[sistemas]]; valor en [[valores]].
