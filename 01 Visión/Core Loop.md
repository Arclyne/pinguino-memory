---
tipo: vision
estado: borrador
---
# Core Loop

```mermaid
flowchart LR
    A[Apuntar dirección] --> B[Elegir fuerza]
    B --> C[Lanzar]
    C --> D[Vuelo]
    D --> E[Aterrizar en el acantilado]
    E --> F[Deslizarse esquivando estructuras]
    F --> G[Llegar abajo]
    F -. choque .-> X[Ragdoll y reaparecer arriba]
    X -.-> A
    G --> H{¿Qué sigue?}
    H -.-> A
```

## Por definir #pendiente
- Qué pasa al llegar abajo (puntaje, monedas, mejoras…)
- Cómo se cierra el ciclo y vuelve a empezar

Mecánicas: [[Resortera]] → [[Vuelo]] → [[Deslizamiento]] → [[Obstáculos]]
