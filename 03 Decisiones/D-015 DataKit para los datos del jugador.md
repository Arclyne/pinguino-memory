---
tipo: decision
id: D-015
fecha: 2026-11-13
estado: aceptada
---
# D-015 DataKit para los datos del jugador #decidido

## Decisión
- Los datos del jugador (peces, skins, ruleta, regalo diario, impulso, metas y mejores tiempos) se guardan con **DataKit**, el paquete propio de Angel (GitHub `Arclyne/data-kit`), en vez del manejador hecho a mano.
- DataKit vive en `ServerStorage.Packages.DataKit` (la misma ruta que usa wally).

## Contexto
- El `ProfileService` casero que había en la place guardaba con `SetAsync` sin session lock, y si la carga fallaba le daba al jugador un perfil vacío que luego se escribía encima de sus datos reales.
- Angel prefirió ProfileStore o DataKit. Se eligió DataKit: lease en MemoryStore más fencing token durable, tests contra servicios reales, y sirve como segundo juego real del paquete.

## Alternativas descartadas
- Manejador casero (`ProfileService` de la place): podía borrar datos.
- ProfileStore (loleris): sigue siendo la opción segura si DataKit da problemas; el cambio sería igual de simple.

## Consecuencias
- Si la carga falla o tarda más de 60 s, se saca al jugador con un mensaje en vez de darle un perfil vacío.
- Si otro servidor toma la sesión, se saca al jugador del servidor viejo.
- Si DataKit falla, el arreglo lo hace Angel en su paquete.

## Relacionado
- [[Arquitectura]]
