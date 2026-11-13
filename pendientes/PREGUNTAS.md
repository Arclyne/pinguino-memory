---
tipo: preguntas
verificado: 2026-11-13
---
# Preguntas abiertas

Solo lo que sigue abierto. Al resolverse: se borra de aquí y se crea o actualiza su `D-0xx` en [[REGISTRO]]. Los números no se reutilizan (siguiente libre: Q-26).

## Hallazgos de la revisión de la place (2026-11-13) que Angel debe confirmar
- **Q-25** Entre las 02:25 y las 06:50 del 2026-11-13 la place cambió sin que nada quedara en el vault: nivel 5 "Vecindario Navideño" (18 casas, ventanas que se rompen), fogata y decoración nueva en el lobby, objetos del lobby movidos, iluminación propia del lobby y montañas de N1 retocadas. ¿Quién lo hizo (tú, otra sesión de Claude, la otra computadora), qué pediste y qué quedó aprobado? Con eso escribo las decisiones y el diseño de N5.
- **Q-01** El lobby, sus GUIs, las skins, la ruleta, la tabla y el Festival de Faroles de N2 ya están en Studio, pero ninguna bitácora registra la sesión que los metió. ¿Los revisaste y quedan aprobados como están, o hay que compararlos contra los artefactos?
- **Q-02** Hay una cinemática de avalancha en N1 (montaña, sirena, ola que persigue, botón "Evento Avalancha · pronto") sin decisión ni diseño en el vault. ¿La pediste tú? ¿Se queda? ¿Qué es el evento Avalancha?
- **Q-05** El código desbloquea los niveles en orden (para ir al N hay que terminar el N-1). ¿Así lo quieres, o se pueden elegir libremente?
- **Q-06** N2 no tiene ninguna zona que elimine (ni arroyo ni caídas): solo se muere por choque. ¿Es intencional?
- **Q-12** El lobby (`LobbyHud`, paneles, `UiKit`) no sigue MVP como pide D-006. ¿Se rehace en MVP o se acepta como está?
- **Q-13** La tabla de "mejor tiempo" solo cuenta el nivel 1. ¿Una tabla por nivel, tiempo total, o así?
- **Q-14** En ServerStorage quedaron scripts de construcción y un volcado viejo (`ClaudeBuild`, `BuildStalls`, `BuildAvalancheMountains`, `ClaudeScriptDump`, `PluginCurves`), y en Workspace una `Baseplate` con un spawn apagado. Desde la madrugada también hay respaldos (`MountainLookBackup`, `CuteReplacedBackup`, `CuteModels`). ¿Los borro? (los constructores se pueden guardar antes en `archivo/construccion/`)
- **Q-22** La bitácora del 2026-11-13 habla de "tareas de Slogter". ¿Quién es y qué papel tiene en el proyecto?

## Juego
- **Q-15** ¿Cuál es el objetivo? (llegar abajo, tiempo, distancia, puntaje, carreras)
- **Q-16** ¿Single player, multijugador o competitivo? El HUD ya anuncia "lanzarse con un amigo" y "próxima carrera".
- **Q-03** ¿Qué pasa al terminar el último nivel (hoy N5)? Hoy se repite. ¿Otro nivel, regreso al lobby, pantalla final?
- **Q-19** ¿El jugador controla algo durante el vuelo de lanzamiento?
- **Q-20** ¿Qué pasa si el pingüino cae fuera de la pista al lanzarlo?
- **Q-23** Qué son en concreto: Renacer, Pack inicial, VIP, Personalizar, Lanzarse con un amigo (x2 peces), Próxima carrera. Hoy son botones con panel "próximamente".

## Alcance y dinero
- **Q-17** ¿Qué entra en el MVP?
- **Q-18** ¿Monetización? Precios en Robux de packs y pases (hoy `EconomyConfig.Robux.PricesDecided=false`).

## Controles
- **Q-07** Controles en celular y consola (apuntar, fuerza, moverse, saltar).
- **Q-08** ¿Apruebas el rango de la resortera que eligió Claude? (`GameConfig.Slingshot.MaxYawDegrees`, `MinPitchDegrees`, `MaxPitchDegrees`)

## Personaje
- **Q-09** ¿Se aprueba la hoja de personaje v5? ¿Cómo será la textura de studs? (se define en Blender)

## Niveles
- **Q-04** ¿Se agregan rampas de impulso al nivel 4? (no tiene)
- **Q-10** ¿Los huecos de 20–22 studs de N3, las grietas de N4 y el recorrido por las casas de N5 se sienten justos? Hace falta jugarlos.
- **Q-11** ¿Los ciervos deben moverse (cabeza, orejas, cola)?
- **Q-24** N2: ¿el hielo del arroyo cambia la física? ¿El portal lleva un estilo propio de aldea?

## Proyecto
- **Q-21** ¿Se puede dar por abandonado el place viejo "Lugar de Alucinarse: 11112026_1"? PINGUINO TEST ya tiene todo.
