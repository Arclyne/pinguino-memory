---
tipo: decision
id: D-058c
fecha: 2026-11-17
autor: ciervo
estado: vigente (el frío se reencendió en D-061a)
tema: progresion,niveles
---
# D-058c · Catorce biomas en la bajada y frío apagado
- Ciervo decidió (2026-11-17): agregar "muchísimos biomas, biomas de todo" a la bajada infinita (lava, desierto, selva y lo que se ocurra).
- Ciervo decidió: **quitar de momento** que el frío baje la vida con la distancia (D-038a). Se apaga, no se borra: `EndlessConfig.Cold.Enabled`.
- porqué: no lo dijo.
- Claude eligió (sin aprobar):
  - 13 biomas nuevos detrás del navideño, en este orden fijo: Desierto Dorado, Selva Salvaje, Volcán de Lava, Playa Tropical, Bosque de Otoño, Cañón del Oeste, Pantano Sombrío, Bosque de Hongos, Tierra de Dulces, Cueva de Cristal, Jardín de Cerezos, Ciudad Neón y La Luna. Después del 14 vuelve a empezar.
  - Cada bioma nuevo tiene su ambiente propio (hora, luz y tinte; p. ej. noche en Ciudad Neón y La Luna, niebla en el Pantano).
  - Las piezas nuevas no salen de mapas viejos: las arma un constructor con calle, rieles que rebotan, banquetas, suelo texturizado con manchas (D-025c), postes con luz, props y paisaje de fondo por tema, más 4–5 obstáculos propios por tema.
  - Sin frío no hay número de daño por distancia, ni escarcha, ni avisos de congelación; choque y caída siguen igual.
- cambia: D-047a (los biomas 2 y 3 iban a ser Ciudad Nevada y Valle del Avión, sacados del respaldo; no se hicieron). Arco y cambio de ambiente de D-047a siguen. Los 8 biomas del catálogo de huevos de D-056c ya no coinciden con estos nombres.
- sin decidir: si Angel está de acuerdo (D-047a era suya); si el orden debe cambiar por semana (D-045a habla de semilla, hoy el orden es fijo); si el frío vuelve y con qué valores (Q-29a).
- dónde vive: `Shared.EndlessConfig` (`Cold.Enabled`, `Biome.ThemeRotation`, `Biome.DisplayNames`, `Biome.Looks`), `ReplicatedStorage.EndlessPieces.<Tema>`, constructor `ServerStorage.ClaudeBuild.EndlessBiomeBuilder` → [[nivel-1]].
- Angel decidió (2026-11-18): el frío vuelve a encenderse y los 13 biomas quedan aprobados → D-061a.
