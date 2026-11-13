---
tipo: decision
id: D-015
fecha: 2026-11-13
autor: v1
estado: vigente
tema: datos
---
# D-015 · DataKit para los datos del jugador
- Angel decidió: los datos del jugador se guardan con DataKit, su paquete (`Arclyne/data-kit`), en `ServerStorage.Packages.DataKit`.
- porqué: el `ProfileService` casero guardaba con `SetAsync` sin session lock y, si la carga fallaba, daba un perfil vacío que luego pisaba los datos reales. DataKit tiene lease en MemoryStore más fencing token, y este juego le sirve de segundo caso real.
- descartado: manejador casero (podía borrar datos). ProfileStore de loleris queda como plan B.
- consecuencias: si la carga falla o tarda más de 60 s se expulsa al jugador en vez de darle un perfil vacío; si otro servidor toma la sesión se le expulsa del viejo; si DataKit falla, lo arregla Angel en su paquete.
- dónde vive: [[sistemas]] § Datos.
