---
tipo: decision
id: D-054a
fecha: 2026-11-14
autor: angel
estado: vigente
tema: progresion,lobby,economia
---
# D-054a · Ambiente por bioma, lobby reacomodado y tienda rotativa
- Angel decidió: 
- porqué: 
- Claude eligió (sin aprobar): 
- descartado: 
- dónde vive: 
- Angel decidió (2026-11-14): hacer el **cambio de ambiente al cruzar el arco** (D-047a).
- Angel decidió: **mejorar el lobby**: la pantalla tapaba las bases y había cosas que ya no van. El **Salón de la Fama y la ruleta pasan al fondo** (no se agranda la meseta). Se **quitan**: el portal y el botón NIVELES, la tarjeta y el botón de Próxima carrera, el pedestal del evento y los pedestales de skins de la tienda. Todo queda guardado en `ServerStorage.Respaldo_MapaViejo.LobbyRetirado`.
- Angel decidió: hacer la **tienda rotativa con tiempo** (D-041a).
- descartado: agrandar la meseta; achicar la pantalla.
- porqué: no lo dijo.
- Claude eligió (sin aprobar): los ambientes (del bioma 2 en adelante ATARDECER, NOCHE y AURORA en ciclo; cambian hora, luz y tinte) y sin música porque el juego no tiene; en la tienda, solo huevos (no hay resorteras todavía), 6 ofertas por hora iguales para todos, una compra por oferta y por jugador en cada hora, y los pesos y precios de `EggConfig.Shop`; dónde quedaron exactamente el salón y la ruleta.
- pendiente: música por bioma; resorteras en la tienda; los caminos de hielo del piso siguen llevando a donde estaban la ruleta, el salón y el portal; `LevelsPanel` y el código de la carrera programada siguen en la place sin uso.
- dónde vive: [[sistemas]] (`BiomeAmbience`, `ShopRotation`, `ShopRotationService`, `RearrangeLobby`); [[nivel-1]]; [[lobby-economia]].
