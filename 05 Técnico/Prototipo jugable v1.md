---
tipo: tecnico
estado: borrador
---
# Prototipo jugable v1

Primer prototipo en la place **PINGUINO TEST**. Lo pedido por Angel está en [[D-007 Jugabilidad base del recorrido]]. Todo lo de esta nota son propuestas de Claude para hacerlo jugable: #idea hasta que Angel las apruebe o corrija.

## Cómo se juega
1. Caminar hasta la resortera y presionar **E** (Subirse). Se puede desde la base de los escalones.
2. **Mover el mouse** para apuntar: izquierda/derecha gira, arriba/abajo cambia el ángulo.
3. **Mantener clic y arrastrar hacia adelante** (arriba) para dar fuerza; **soltar** para lanzar. **X** para bajarse.
4. En el aire el pingüino vuela con las aletas abiertas y aterriza en la zona de aterrizaje.
5. Deslizándose: **A/D** o flechas para moverse, **Espacio** para saltar de panza.
6. Al cruzar la meta aparece el tiempo arriba, en pequeño; para volver se entra al portal.

## Propuestas implementadas #idea
- **Arrastre de fuerza:** "de atrás hacia adelante" se interpretó como arrastrar hacia arriba en pantalla. Se invierte con `DragForwardIncreasesPower` en `GameConfig`.
- **Rango de ángulos:** giro ±18°, elevación de 5° a 45° (respeta [[D-002 Límite de ángulo de la resortera]]).
- **Vuelo:** gravedad al 55 % mientras vuela, para que el arco dure ~1.8 s. Sin control en el aire durante el vuelo.
- **Choque:** #decidido en [[D-008 Choque mortal, sin puntos de control y GUI minimalista]]: ragdoll y muerte. Tras 1.2 s de ragdoll el servidor hace `LoadCharacter` (sin la muerte de Roblox). Roces de lado no cuentan.
- **Río y grietas:** caer al agua o a una grieta también te elimina. El río obliga a saltar.
- **Troncos atravesados:** se pasan saltando.
- **Velocidad:** tope de 120 studs/s; en pendiente se estabiliza cerca de 100.
- **Una sola persona en la resortera a la vez;** si no lanza en 45 s, se baja sola.
- **Meta:** el servidor cuenta el tiempo. Sin puntos de control.

## Animaciones (por código, con los Motor6D)
Parado, caminar, salto de pie, apuntando, volando, aterrizando, deslizándose (se inclina al girar), saltando, en el aire, chocado (gira) y festejando.

## Sonidos y partículas
- Partículas: nieve al deslizarse, nube al aterrizar, estrellas al chocar, estelas en las aletas al volar y saltar, salpicadura al caer al agua.
- Sonidos: liga estirándose, lanzamiento, viento, deslizamiento, salto, choque, aterrizaje, meta y agua. Los IDs están en `Client/Audio/SoundCatalog`; son audios gratuitos de la Creator Store y se pueden cambiar ahí.

## Pendiente #pendiente
- Controles en celular y consola (hoy solo teclado y mouse; el control de Xbox sirve para girar y saltar).
- El pingüino no sube escalones caminando (patas muy cortas): hay que saltar.
- Sin guardado de tiempos ni tabla de récords.
- Sin validación de velocidad en el servidor (anti-trampas básico solamente).

Ver [[Arquitectura]]
