---
tipo: decision
id: D-006
fecha: 2026-11-11
autor: v1
estado: vigente
tema: codigo, gui
---
# D-006 · Patrón MVP y estilo de código
- Angel decidió: todas las GUIs siguen MVP (Model–View–Presenter). Todo el código sigue SOLID, sin comentarios innecesarios (nombres declarativos) y en inglés.
- nota: el HUD de carrera (`Client.Gui`) sí está en MVP. El lobby (`LobbyHud`, `Panels`, `UiKit`) construye la GUI por código sin esa separación → Q-12.
