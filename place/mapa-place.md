---
tipo: mapa-place
generado: sí (ServerStorage.DevTools.PlaceMap; no editar a mano; ver herramientas/LEEME.md)
---
# Mapa de la place

Formato. scripts: `Nombre TipoLíneas | api | req | rem | tag | attr | key | svc` (M módulo, S script, L local; `+N` = N más sin listar). etiquetas: `Etiqueta total | por nivel | clases | atributos{valores}`. niveles: posiciones del mundo redondeadas a studs. Qué hace cada sistema: [[sistemas]].

# huella
place=Prueba de pingüino placeId=76340917059535 universeId=10776032682 generado=2026-11-14 06:40
huella: scripts=144 lineas=22294 codigo=69f5fafc instancias=90545 mundo=e7464201
# scripts
## ReplicatedStorage.Shared
ChristmasTrack M328 | api:centerAt,distanceToRoad,frameAt,guideDirection,heightAt,normalAt,progressAt,rescueFrame,shortcutAt,tangentAt,widthAt,xAt,zoneIndexAt
Cleaner M44 | api:clean,new
EconomyConfig M46
EconomyRemotes M22
GameConfig M97 | tag:BoostRamp | attr:JumpDistance,KeepSpeed
LaunchMath M49 | api:clampAim,direction,flightGravity,positionAt,pullOffset,speed,velocity | req:GameConfig
LevelRegistry M60 | api:arrivalFrame,firstTagged,levelOf,nextLevel,playerLevel | req:GameConfig | tag:PlateauSpawn,ReturnPortal | attr:DestinationLevel,LevelId
PenguinOrientation M16 | api:bellyDown
Pose M36 | api:isValid
Remotes M15
RunState M8
Signal M42 | api:Connect,Disconnect,Fire,new
SkinAppearance M352 | api:apply,clear | tag:ChaseBulb,FlickeringFlame,PulseGlow | attr:ChaseIndex,SkinBaseColor,SkinBaseMaterial,SkinBaseTransparency,SkinId
SkinCatalog M90 | api:get,isValid,list
SlingshotGeometry M39 | api:find,findAll,seatFrame | req:LevelRegistry | tag:Slingshot | attr:LaunchForward,SeatPosition
WheelCatalog M67 | api:chance,count,list,pick,totalWeight
## ServerScriptService
EconomyMain S5 | req:name
## ServerScriptService.Server.Data
PlayerProfile M76 | api:currentWeek,rollWeek,sanitize | req:EconomyConfig,SkinCatalog
## ServerScriptService.Server
Main S21 | req:ChristmasRunService,LevelFlowService,LevelService,PoseService,RaceService,ReturnService,RunStateService,SlingshotService
## ServerScriptService.Server.Services
ChristmasRunService M202 | api:absorbCrash,absorbHazard,init,isOutOfHealth | req:ChristmasTrack,LevelRegistry,Remotes,RunState,RunStateService | rem:RaceNotice | attr:PenguinHealth,PenguinMaxHealth,RunZone
FishService M209 | api:init | req:ChristmasTrack,EconomyConfig,EconomyRemotes,LevelRegistry,PlayerDataService,RateLimiter,RunState,RunStateService | rem:FishCollectRequested | tag:FinishLine,FishPickup,Hazard,Slingshot | attr:PickupId
LeaderboardService M161 | api:init | req:EconomyConfig,EconomyRemotes,PlayerDataService,SkinCatalog | rem:LeaderboardChanged,LeaderboardRequested | svc:DataStore
LevelFlowService M70 | api:init | req:GameConfig,LevelRegistry,ReturnService,RunState,RunStateService,SlingshotGeometry,SlingshotService
LevelService M46 | api:init | req:LevelRegistry
PlayerDataService M205 | api:addFish,currentWeek,get,init,snapshot,spendFish,update | req:DataKit,EconomyConfig,EconomyRemotes,PlayerProfile,Signal | rem:ProfileChanged,ProfileRequested
PoseService M48 | api:init | req:Pose,RateLimiter,Remotes,RunState,RunStateService | rem:PoseChanged | attr:Pose
ProgressService M95 | api:init,isUnlocked | req:EconomyRemotes,GameConfig,LevelRegistry,PlayerDataService,RateLimiter,ReturnService,RunState,RunStateService,SlingshotService | rem:LaunchPadRequested,LevelTravelRequested | tag:Slingshot | attr:DismountPosition
RaceService M174 | api:init | req:ChristmasRunService,GameConfig,LevelRegistry,RateLimiter,Remotes,RunState,RunStateService | rem:CrashReported,RaceNotice | tag:FinishLine,Hazard | attr:HazardKind,KillHeight
ReturnService M81 | api:init | req:LevelRegistry,RateLimiter,RunState,RunStateService,Signal | tag:ReturnPortal | attr:DestinationLevel
RewardService M58 | api:init | req:EconomyConfig,EconomyRemotes,PlayerDataService,RateLimiter | rem:BoostPurchaseRequested,DailyGiftClaimRequested
RunStateService M72 | api:get,init,reset,transition | req:Remotes,RunState,Signal | rem:RunStateChanged | attr:RunState
SkinService M97 | api:grant,init,owns | req:EconomyRemotes,PlayerDataService,RateLimiter,SkinAppearance,SkinCatalog | rem:SkinEquipRequested,SkinPurchaseRequested
SlingshotService M202 | api:init,mountAtLevel | req:GameConfig,LaunchMath,LevelRegistry,RateLimiter,Remotes,RunState,RunStateService,SlingshotGeometry | rem:AimChanged,DismountRequested,LaunchRequested | attr:AimPitch,AimPull,AimYaw,DismountPosition
WheelService M102 | api:init | req:EconomyConfig,EconomyRemotes,PlayerDataService,RateLimiter,SkinService,WheelCatalog | rem:WheelSpinPurchaseRequested,WheelSpinRequested,WheelSpun
## ServerScriptService.Server.Util
RateLimiter M42 | api:allow,new
## ServerStorage
BuildAvalancheMountains M237 | req:SlingshotGeometry | tag:AvalancheMountain,AvalancheSiren,CheeringPenguin | attr:CheerMode,Cheers,ChunkIndex,LevelId,PlateauEdge
BuildStalls M532 | req:SkinAppearance | tag:ChaseBulb,PulseGlow,SpinningDecor,SwingingDecor | attr:ChaseIndex,OpensPanel,SpinSpeed,SwingAmplitude | key:E
## ServerStorage.ClaudeBuild
BuildLevel2Festival M524 | tag:ChaseBulb,CheeringPenguin,DragonParade,SkyLantern,SpinningDecor,SwingingDecor | attr:ChaseIndex,CheerMode,CheerPhase,Cheers,PathCenter,PathRadiusX,PathRadiusZ,PathSpeed,RiseHeight,RiseSpeed,SegmentIndex,SpinAxis,SpinSpeed,SwingAmplitude
BuildLobby M485 | req:SkinAppearance,WheelCatalog | tag:ChaseBulb,ChevronArrow,LobbyLeaderboard,LobbyWheel,PodiumMannequin,PulseGlow,SpinningDecor | attr:ChaseIndex,ChevronIndex,OpensPanel,Rank,SegmentCount,SpinSpeed | key:E
ChristmasBuild M745 | api:finishArea,zone1,zone2,zone3,zone4,zone5,zone6,zone7,zone8 | req:Clone | tag:FinishLine | attr:Bumper
ChristmasBuild2 M490 | api:clean,flyers,ground,shortcuts,track,world | req:Clone | tag:BoostRamp,FinishLine | attr:JumpDistance,JumpRamp,KeepSpeed
ChristmasKit M926 | api:ball,boostPad,buildRail,building,candyCane,car,conveyor,cyl,factory,fillSides,folder,gift,gingerHouse,house,+27 | req:Clone | tag:BoostRamp | attr:Bumper,JumpDistance,JumpRamp,KeepSpeed
## ServerStorage
ClaudeScriptDump M1270 | api:_crashInto,_holdFrame,_onRaceNotice,_playStretchFeedback,_setPhase,_step,_stepFlight,_stepSlide,_switchTo,_tumble,_updateHeading,clearFinish,detect,elapsedSeconds,+14 | req:AimCamera,AimHudPresenter,AimHudView,AimInput,AimModel,AimingMode,BodyMover,ChaseCamera,Cleaner,CrashSensor,DecorationController,DefaultCamera,FeedbackSounds,FinishPresenter,FinishView,FinishedMode,+26 | rem:AimChanged,CrashReported,DismountRequested,LaunchRequested,RaceNotice,RunStateChanged | tag:FinishLine,Hazard | attr:HazardKind
## ServerStorage.Respaldo_MapaViejo.Avalancha
AvalancheCinematic M981 | api:init | req:LevelRegistry,RunState,SlingshotGeometry | tag:AvalancheMountain,AvalancheSiren | attr:BaseRate,RunState
## ServerStorage.Respaldo_MapaViejo
ChristmasTrack_v1_old M169 | api:centerAt,frameAt,heightAt,progressAt,rescueFrame,tangentAt,widthAt,xAt,zoneIndexAt
## StarterPlayer.StarterPlayerScripts
ChristmasRunClient L530 | req:Audio,ChristmasTrack,Feedback,Remotes | rem:RaceNotice | tag:BoostRamp | attr:JumpRamp,Offset,RunState
## StarterPlayer.StarterPlayerScripts.Client.Aim
AimCamera M62 | api:new,start,stop | req:AimModel,LaunchMath
AimInput M141 | api:_beginCharge,_drag,_endCharge,_pointAt,new,start,stop | req:AimModel,Cleaner,GameConfig,Signal | key:X
AimModel M70 | api:isActive,new,reset,setActive,setDirection,setPower,toAim | req:GameConfig,LaunchMath,Signal
SlingshotBandController M110 | api:_resolveView,_targetOffset,_update,new,setLocalAimProvider,start | req:LaunchMath,LevelRegistry,SlingshotBandView,SlingshotGeometry | attr:AimPitch,AimPull,AimYaw
SlingshotBandView M81 | api:new,render
TrajectoryPreview M64 | api:hide,new,render | req:LaunchMath
## StarterPlayer.StarterPlayerScripts.Client.Audio
FeedbackSounds M38 | api:play | req:SoundCatalog
SoundCatalog M22
## StarterPlayer.StarterPlayerScripts.Client.Character
BodyMover M154 | api:destroy,face,holdAt,new,ragdoll,recover,releaseControl,setLiftEnabled,stopHolding,takeControl,teleport | req:GameConfig
DefaultCamera M19 | api:restore
LocalCharacter M62 | api:get,init | req:BodyMover,Signal
LocalPose M29 | api:get,set | req:Pose,Remotes,Signal | rem:PoseChanged
## StarterPlayer.StarterPlayerScripts.Client.Decoration
ChaseLights M56 | api:init,update | tag:ChaseBulb | attr:ChaseIndex
CheeringCrowd M122 | api:init,update | tag:CheeringPenguin | attr:CheerMode,CheerPhase,Cheers
DecorationController M38 | api:init | req:ChaseLights,CheeringCrowd,FlameFlicker,ParadeMotion,PulseGlow,SpinningDecor,SwingingDecor
FlameFlicker M63 | api:init,update | tag:FlickeringFlame
ParadeMotion M106 | api:init,update | tag:ChevronArrow,DragonParade | attr:ChevronIndex,PathCenter,PathRadiusX,PathRadiusZ,PathSpeed,SegmentIndex
PulseGlow M49 | api:init,update | tag:PulseGlow
SpinningDecor M65 | api:init,update | tag:SpinningDecor | attr:SpinAxis,SpinSpeed
SwingingDecor M79 | api:init,update | tag:SkyLantern,SwingingDecor | attr:RiseHeight,RiseSpeed,SwingAmplitude
## StarterPlayer.StarterPlayerScripts.Client.Effects
WorldEffects M32 | api:splash
## StarterPlayer.StarterPlayerScripts.Client
Feedback M112 | api:confetti,init,toast | req:UiKit
FishPickupController M135 | api:init | req:EconomyConfig,EconomyRemotes,RunState | rem:FishCollectRequested | tag:FishPickup | attr:PickupId,RunState
## StarterPlayer.StarterPlayerScripts.Client.Gui
AimHudPresenter M20 | api:bind | req:AimHudView,AimModel
AimHudView M35 | api:new,setVisible,showAngles,showPower
FinishPresenter M19 | api:bind | req:FinishView,RaceModel,TimeFormatter
FinishView M27 | api:hide,new,show
RaceHudPresenter M24 | api:bind | req:RaceHudView,RaceModel,TimeFormatter
RaceHudView M29 | api:new,setVisible,showProgress
TimeFormatter M12 | api:stopwatch
## StarterPlayer.StarterPlayerScripts.Client
HudIcons M184 | api:create,has,replaceTextIcon,setKind
HudLife M301 | api:launch,tile
IconText M194 | api:init | req:HudIcons | attr:EmojiPure
## StarterPlayer.StarterPlayerScripts.Client.Input
MoveInput M40 | api:steer | key:A,D,Left,Right,Thumbstick1
## StarterPlayer.StarterPlayerScripts.Client
LeaderboardStore M70 | api:init,rows,secondsUntilReset | req:EconomyRemotes,Signal | rem:LeaderboardChanged,LeaderboardRequested
LobbyHud M323 | api:init,open | req:EconomyConfig,EconomyRemotes,Feedback,HudIcons,HudLife,InfoPanel,LeaderboardPanel,LevelsPanel,PanelHost,ProfileStore,RunState,ShopPanel,SkinsPanel,UiKit,WheelPanel | rem:LaunchPadRequested | attr:OpensPanel,RunState | key:B,C,Escape,F,G,H,K,L,N,P,Q,R,U,X,Y,Z | svc:ProximityPrompt
LobbyLighting M73 | api:init
Main L65 | req:AimCamera,AimHudPresenter,AimHudView,AimInput,AimModel,AimingMode,CameraFeel,ChaseCamera,DecorationController,FinishPresenter,FinishView,FinishedMode,IdleMode,LocalCharacter,PresentationController,RaceHudPresenter,+7
PanelHost M125 | api:close,isOpen,new,open | req:HudIcons,ProfileStore,UiKit
## StarterPlayer.StarterPlayerScripts.Client.Panels
InfoPanel M186 | api:build | req:EconomyConfig,EconomyRemotes,Feedback,ProfileStore,UiKit | rem:BoostPurchaseRequested,DailyGiftClaimRequested | svc:Social
LeaderboardPanel M185 | api:build | req:Feedback,LeaderboardStore,PenguinViewport,ProfileStore,UiKit | attr:TabIndex
LevelsPanel M71 | api:build | req:EconomyRemotes,Feedback,ProfileStore,UiKit | rem:LevelTravelRequested
ShopPanel M80 | api:build | req:EconomyConfig,EconomyRemotes,Feedback,UiKit | rem:BoostPurchaseRequested,WheelSpinPurchaseRequested
SkinsPanel M227 | api:build,request | req:EconomyRemotes,Feedback,PenguinViewport,ProfileStore,SkinCatalog,UiKit | rem:SkinEquipRequested,SkinPurchaseRequested
WheelPanel M281 | api:build,recordWinner | req:EconomyConfig,EconomyRemotes,Feedback,HudIcons,ProfileStore,UiKit,WheelCatalog | rem:WheelSpinPurchaseRequested,WheelSpinRequested
## StarterPlayer.StarterPlayerScripts.Client
PenguinViewport M113 | api:_applyYaw,destroy,new,setSkin,spin | req:SkinAppearance
## StarterPlayer.StarterPlayerScripts.Client.Presentation
CharacterPresentation M100 | api:_measureTurnRate,destroy,new,update | req:PenguinAnimator,PenguinEffects,PenguinSounds
PenguinAnimator M302 | api:new,update | req:Pose
PenguinEffects M198 | api:destroy,new,onPoseChanged,update | req:PenguinAnimator,Pose
PenguinSounds M114 | api:destroy,new,onPoseChanged,update | req:PenguinAnimator,Pose,SoundCatalog
PresentationController M61 | api:init | req:CharacterPresentation,LocalPose,Pose | attr:Pose
## StarterPlayer.StarterPlayerScripts.Client
ProfileStore M61 | api:get,init,now | req:EconomyRemotes,Signal | rem:ProfileChanged,ProfileRequested
## StarterPlayer.StarterPlayerScripts.Client.Race
BoostRampSensor M46 | api:detect,new | req:GameConfig
CameraFeel M81 | api:addTrauma,kickFieldOfView,new,reset,sample,setFieldOfViewBias,setRoll,setRumble
CameraOcclusion M82 | api:_firstBlockingHit,new,resolve
ChaseCamera M111 | api:new,start,stop | req:CameraFeel,CameraOcclusion,GameConfig
CrashSensor M51 | api:detect,new | req:GameConfig
## StarterPlayer.StarterPlayerScripts.Client.Race.Feel
BoostEffects M125 | api:destroy,new,trigger,update | req:CameraFeel,FeedbackSounds,MotionSample,ParticleFactory,SpeedEffects
BrakeEffects M96 | api:destroy,new,update | req:CameraFeel,GameConfig,MotionSample,ParticleFactory,SoundCatalog
CarveEffects M93 | api:destroy,new,update | req:CameraFeel,GameConfig,MotionSample,ParticleFactory
MotionSample M22
ParticleFactory M70 | api:aimedAttachment,fading,groundTrail,snowPlume
RaceFeel M79 | api:_measureAcceleration,destroy,new,onBoost,update | req:BoostEffects,BrakeEffects,CameraFeel,CarveEffects,MotionSample,TopSpeedRumble
TopSpeedRumble M67 | api:_setHaptic,destroy,new,update | req:CameraFeel,GameConfig,MotionSample | svc:Haptic
## StarterPlayer.StarterPlayerScripts.Client.Race
GroundProbe M36 | api:new,probe | req:GameConfig
RaceModel M70 | api:clearFinish,elapsedSeconds,finish,new,reportSpeed,speed,start,stop | req:Signal
SlideMotor M250 | api:_speedCap,_updateHeading,boost,boostFraction,groundNormal,new,requestJump,resetHeading,step | req:BodyMover,GameConfig,GroundProbe,LevelRegistry,PenguinOrientation
SpeedEffects M223 | api:setBoost,start,stop | req:GameConfig
## StarterPlayer.StarterPlayerScripts.Client.Run.Modes
AimingMode M142 | api:_holdFrame,_playStretchFeedback,_step,enter,exit,new | req:AimCamera,AimInput,AimModel,Cleaner,FeedbackSounds,LaunchMath,LevelRegistry,LocalCharacter,LocalPose,PenguinOrientation,Pose,Remotes,SlingshotBandController,SlingshotGeometry,TrajectoryPreview | rem:AimChanged,DismountRequested,LaunchRequested
FinishedMode M59 | api:enter,exit,new | req:DefaultCamera,FeedbackSounds,GameConfig,LocalCharacter,LocalPose,Pose,RaceModel
IdleMode M36 | api:enter,exit,new | req:DefaultCamera,LocalCharacter,LocalPose,Pose
RacingMode M435 | api:_assistSteer,_bounceOff,_crashInto,_onRaceNotice,_recoverAt,_scheduleRecover,_setPhase,_step,_stepFlight,_stepSlide,_tumble,_updateFeel,enter,exit,+1 | req:BoostRampSensor,CameraFeel,ChaseCamera,ChristmasTrack,Cleaner,CrashSensor,FeedbackSounds,GameConfig,GroundProbe,LevelRegistry,LocalCharacter,LocalPose,MoveInput,PenguinOrientation,Pose,RaceFeel,+5 | rem:CrashReported,RaceNotice | attr:Bumper
## StarterPlayer.StarterPlayerScripts.Client.Run
RunController M54 | api:_switchTo,new,start | req:LocalCharacter,Remotes,RunState | rem:RunStateChanged
## StarterPlayer.StarterPlayerScripts.Client
StepAssist M111 | api:init | attr:RunState
UiKit M270 | api:badge,border,button,corner,cornerScale,formatClock,formatNumber,gradient,label,new,padding,pulse,ribbon,textStroke
WindowBreaker M477 | api:init | req:LevelRegistry,RunState | tag:BreakableWindow,HouseShell | attr:DisplayName,HouseIndex,LevelId,RunState,WindowCount,WorldZMax,WorldZMin
WorldBoardController M142 | api:init | req:LeaderboardStore,SkinAppearance,UiKit | tag:LobbyLeaderboard,PodiumMannequin | attr:Rank
WorldWheelController M163 | api:init | req:EconomyConfig,EconomyRemotes,WheelCatalog,WheelPanel | rem:WheelSpun | tag:LobbyWheel | attr:ChaseIndex
## StarterPlayer.StarterPlayerScripts
CuteDecorIdle L127 | tag:CuteArch,CuteIgloo,CutePenguin | attr:Role
LobbyMain L5 | req:name
## sin detalle
ServerStorage.DevTools.GroundTexturer scripts=1 lineas=157
ServerStorage.DevTools.PlaceMap scripts=1 lineas=659
ServerStorage.Packages.DataKit scripts=16 lineas=2560
# etiquetas
AvalancheMountain 0 | solo en ejecucion o sin usar
AvalancheSiren 0 | solo en ejecucion o sin usar
BoostRamp 46 | N1=46 | Part |
BreakableWindow 0 | solo en ejecucion o sin usar
ChaseBulb 243 | N1=243 | Part | ChaseIndex{47 valores}
CheeringPenguin 15 | N1=15 | Model | CheerPhase{15 valores} Cheers{true}
ChevronArrow 11 | N1=11 | Model | ChevronIndex{11 valores}
CuteArch 1 | N1=1 | Model |
CuteIgloo 1 | N1=1 | Model |
CutePenguin 8 | N1=8 | Model |
DragonParade 0 | solo en ejecucion o sin usar
FinishLine 1 | N1=1 | Part |
FishPickup 0 | solo en ejecucion o sin usar
FlickeringFlame 38 | N1=38 | Part |
Hazard 0 | solo en ejecucion o sin usar
HouseShell 0 | solo en ejecucion o sin usar
LobbyLeaderboard 1 | N1=1 | Model |
LobbyWheel 1 | N1=1 | Model | SegmentCount{12}
PlateauSpawn 1 | N1=1 | SpawnLocation |
PodiumMannequin 3 | N1=3 | Model | Rank{1/2/3} SkinId{classic}
PulseGlow 36 | N1=36 | Part |
ReturnPortal 1 | N1=1 | Part | DestinationLevel{1}
SkyLantern 0 | solo en ejecucion o sin usar
Slingshot 1 | N1=1 | Model | AimPitch{0} AimPull{0} AimYaw{0} DismountPosition{(0,608.5,26)} LaunchForward{(0,0,-1)} SeatPosition{(0,638.8,20)}
SpinningDecor 16 | N1=16 | Model | SpinSpeed{13 valores}
SwingingDecor 3 | N1=3 | Model | SwingAmplitude{0.08/0.12}
# niveles
## N1 PenguinSlingshotMap_v01 | instancias=90538 partes=84912 conColision=14900 | min(-2253,-4229,-20500) max(4000,1691,315)
hijos: ChristmasRun[Folder]85135 · FestiveDecoration[Folder]1027 · Lobby[Folder]3674 · PlateauFence[Part]0 · PlateauFence[Part]0 · PlateauFence[Part]0 · ReturnPortalGate[Model]574 · SlingshotDecor[Model]52 · Slingshot[Model]61 · Terrain[Folder]4 · WaitingPenguins[Folder]0
PlateauSpawn: Lobby.PlateauSpawn [SpawnLocation] pos(0,601,110) size(30,1,30)
Slingshot: Slingshot [Model] pos(0,614,20) AimPitch=0,AimPull=0,AimYaw=0,DismountPosition=(0,608.5,26),LaunchForward=(0,0,-1),SeatPosition=(0,638.8,20)
FinishLine: ChristmasRun.Meta_AldeaDeSanta.FinishLine [Part] pos(0,-3569,-16370) size(128,0,4)
ReturnPortal: ReturnPortalGate.ReturnPortalTrigger [Part] pos(0,-3575,-16648) size(11,22,2) DestinationLevel=1
BoostRamp: ChristmasRun.Zona1_ColinaNevada.Gameplay.Turbo.BoostPad [Part] pos(164,415,-660) size(30,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo10_salto.BoostPad [Part] pos(-22,-2950,-13281) size(16,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo4_callejon.BoostPad [Part] pos(-38,-655,-4721) size(16,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo9_salto.BoostPad [Part] pos(-74,-2566,-12008) size(16,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo1_pinos.BoostPad [Part] pos(-32,368,-871) size(16,1,22)
BoostRamp: ChristmasRun.Zona6_TallerDeJuguetes.Gameplay.Turbo.BoostPad [Part] pos(-115,-2023,-10075) size(24,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo6_parque.BoostPad [Part] pos(15,-1153,-6781) size(16,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo4_callejon.BoostPad [Part] pos(26,-602,-4478) size(16,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo2_hielo.BoostPad [Part] pos(52,10,-2201) size(16,1,22)
BoostRamp: ChristmasRun.Zona4_Centro.Gameplay.Turbo.BoostPad [Part] pos(-186,-1062,-6369) size(24,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo7_juguetes.BoostPad [Part] pos(-43,-1979,-9891) size(16,1,22)
BoostRamp: ChristmasRun.Zona5_GarajeDeSanta.Gameplay.Turbo.BoostPad [Part] pos(-212,-1532,-8327) size(24,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo5_callejon.BoostPad [Part] pos(18,-900,-5751) size(16,1,22)
BoostRamp: ChristmasRun.Zona5_GarajeDeSanta.Gameplay.Turbo.BoostPad [Part] pos(-176,-1457,-8060) size(30,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo5_callejon.BoostPad [Part] pos(34,-846,-5508) size(16,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo2_hielo.BoostPad [Part] pos(0,103,-1958) size(16,1,22)
BoostRamp: ChristmasRun.Zona8_PuenteDelPuerto.Gameplay.Turbo.BoostPad [Part] pos(0,-3376,-15150) size(30,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo3_hielo.BoostPad [Part] pos(-59,-217,-2988) size(16,1,22)
BoostRamp: ChristmasRun.Zona7_AutopistaPolar.Gameplay.Turbo.BoostPad [Part] pos(148,-2645,-12321) size(26,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo9_salto.BoostPad [Part] pos(36,-2624,-12251) size(16,1,22)
BoostRamp: ChristmasRun.Zona4_Centro.Gameplay.Turbo.BoostPad [Part] pos(32,-1195,-6970) size(30,1,22)
BoostRamp: ChristmasRun.Zona7_AutopistaPolar.Gameplay.Turbo.BoostPad [Part] pos(121,-2789,-12720) size(26,1,22)
BoostRamp: ChristmasRun.Zona3_PuebloNavideno.Gameplay.Turbo.BoostPad [Part] pos(208,-469,-3892) size(24,1,22)
BoostRamp: ChristmasRun.Zona2_BosqueDeBastones.Gameplay.Turbo.BoostPad [Part] pos(206,19,-2170) size(30,1,22)
BoostRamp: ChristmasRun.Zona8_PuenteDelPuerto.Gameplay.Turbo.BoostPad [Part] pos(-16,-3315,-14770) size(24,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo7_juguetes.BoostPad [Part] pos(1,-1920,-9648) size(16,1,22)
BoostRamp: ChristmasRun.Zona6_TallerDeJuguetes.Gameplay.Turbo.BoostPad [Part] pos(-37,-1884,-9500) size(30,1,22)
BoostRamp: ChristmasRun.Zona5_GarajeDeSanta.Gameplay.Turbo.BoostPad [Part] pos(21,-1609,-8600) size(30,1,22)
BoostRamp: ChristmasRun.Zona3_PuebloNavideno.Gameplay.Turbo.BoostPad [Part] pos(-143,-723,-4970) size(30,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo8_juguetes.BoostPad [Part] pos(46,-2215,-10678) size(16,1,22)
BoostRamp: ChristmasRun.Zona3_PuebloNavideno.Gameplay.Turbo.BoostPad [Part] pos(177,-468,-3888) size(24,1,22)
BoostRamp: ChristmasRun.Zona5_GarajeDeSanta.Gameplay.Turbo.BoostPad [Part] pos(-183,-1528,-8313) size(24,1,22)
BoostRamp: ChristmasRun.Zona8_PuenteDelPuerto.Gameplay.Turbo.BoostPad [Part] pos(0,-3424,-15450) size(30,1,22)
BoostRamp: ChristmasRun.Zona7_AutopistaPolar.Gameplay.Turbo.BoostPad [Part] pos(-169,-2450,-11546) size(26,1,22)
BoostRamp: ChristmasRun.Zona6_TallerDeJuguetes.Gameplay.Turbo.BoostPad [Part] pos(-145,-2025,-10084) size(24,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo6_parque.BoostPad [Part] pos(-77,-1099,-6538) size(16,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo8_juguetes.BoostPad [Part] pos(7,-2274,-10921) size(16,1,22)
BoostRamp: ChristmasRun.Zona7_AutopistaPolar.Gameplay.Turbo.BoostPad [Part] pos(-191,-2907,-13120) size(26,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo1_pinos.BoostPad [Part] pos(71,422,-628) size(16,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo10_salto.BoostPad [Part] pos(23,-2872,-13038) size(16,1,22)
BoostRamp: ChristmasRun.Zona7_AutopistaPolar.Gameplay.Turbo.BoostPad [Part] pos(192,-2644,-12318) size(26,1,22)
BoostRamp: ChristmasRun.Zona7_AutopistaPolar.Gameplay.Turbo.BoostPad [Part] pos(-210,-2444,-11533) size(26,1,22)
BoostRamp: ChristmasRun.Zona8_PuenteDelPuerto.Gameplay.Turbo.BoostPad [Part] pos(16,-3315,-14770) size(24,1,22)
BoostRamp: ChristmasRun.Atajos.Atajo3_hielo.BoostPad [Part] pos(-29,-281,-3231) size(16,1,22)
BoostRamp: ChristmasRun.Zona8_PuenteDelPuerto.Gameplay.Turbo.BoostPad [Part] pos(0,-3261,-14430) size(30,1,22)
BoostRamp: ChristmasRun.Zona4_Centro.Gameplay.Turbo.BoostPad [Part] pos(84,-959,-5950) size(30,1,22)
LobbyWheel: Lobby.LuckyWheel.LobbyWheel [Model] pos(-92,625,72) SegmentCount=12
LobbyLeaderboard: Lobby.HallOfFame.LobbyLeaderboard [Model] pos(101,626,62)
Hazard: ninguno
Lobby: ChevronRoad(5,600,66) · EventPedestal(-50,603,126) · HallOfFame(100,611,42) · LevelsPortal(-10,620,150) · LobbyDecor(-119,607,80) · LuckyWheel(-80,603,74) · MostPopular(44,602,32) · PenguinCampfire(-33,603,101) · PenguinCampfire2(35,603,99) · PlateauSpawn(0,601,110) · Shop(70,606,130)
# mundo
workspace: StreamingEnabled=true MinRadius=64 TargetRadius=768 IntegrityMode=PauseOutsideLoadedArea Gravity=196.2 FallenPartsDestroyHeight=-9000
fuera de niveles: Baseplate[Part](0,-8,0) · SpawnLocation[SpawnLocation](0,1,0)
## prompts
N1 PenguinSlingshotMap_v01.Lobby.LuckyWheel.LobbyWheel.Base | Girar · Ruleta de la suerte | tecla=E dist=26 OpensPanel=wheel
N1 PenguinSlingshotMap_v01.Lobby.HallOfFame.PromptAnchor | Ver tabla · Salón de la fama | tecla=E dist=22 OpensPanel=leaderboard
N1 PenguinSlingshotMap_v01.Lobby.EventPedestal.PromptAnchor | Ver · Skin del evento | tecla=E dist=18 OpensPanel=event
N1 PenguinSlingshotMap_v01.Lobby.MostPopular.PromptAnchor | Ver skins · Más populares | tecla=E dist=18 OpensPanel=skins
N1 PenguinSlingshotMap_v01.Lobby.LevelsPortal.Swirl | Elegir nivel · Portal de niveles | tecla=E dist=18 OpensPanel=levels
N1 PenguinSlingshotMap_v01.Lobby.Shop.PromptAnchor | Abrir · Tienda | tecla=E dist=16 OpensPanel=shop
N1 PenguinSlingshotMap_v01.Slingshot.Frame.Trunk.MountPromptAttachment | Subirse · Resortera | tecla=E dist=24
## StarterGui
GameHud[ScreenGui] hijos: AimBar,RaceReadout,FinishReadout
## StarterCharacter
partes: Beak(0.3,0.18,0.24) · Body(2.4,2.8,2.12) · Cheek_L(0.16,0.1,0.02) · Cheek_R(0.16,0.1,0.02) · Eye_L(0.28,0.28,0.07) · Eye_R(0.28,0.28,0.07) · Flipper_L(0.3,1.4,0.6) · Flipper_R(0.3,1.4,0.6) · Foot_L(0.8,0.3,1) · Foot_R(0.8,0.3,1) · HumanoidRootPart(2.4,2.8,2)invisible · SlideCollider(2,2,2)invisible · Tail(0.3,0.3,0.25)
uniones: BeakWeld[Weld]:Body>Beak · Cheek_LWeld[Weld]:Body>Cheek_L · Cheek_RWeld[Weld]:Body>Cheek_R · Eye_LWeld[Weld]:Body>Eye_L · Eye_RWeld[Weld]:Body>Eye_R · LeftAnkle[Motor6D]:Body>Foot_L · LeftShoulder[Motor6D]:Body>Flipper_L · RightAnkle[Motor6D]:Body>Foot_R · RightShoulder[Motor6D]:Body>Flipper_R · RootJoint[Motor6D]:HumanoidRootPart>Body · SlideColliderWeld[Weld]:HumanoidRootPart>SlideCollider · TailJoint[Motor6D]:Body>Tail
Humanoid: RigType=R15 HipHeight=0.3 WalkSpeed=16 JumpPower=50 UseJumpPower=true RequiresNeck=false
## ajustes
Players: CharacterAutoLoads=true RespawnTime=2.5
StarterPlayer: WalkSpeed=16 JumpHeight=7.2 CameraMaxZoomDistance=128
Lighting: ClockTime=14.2 Brightness=2.4 hijos: __WORLDFX[Sky],PenguinAtmosphere[Atmosphere],PenguinColor[ColorCorrectionEffect],PenguinBloom[BloomEffect],PenguinSunRays[SunRaysEffect]
## ServerStorage
ClaudeScriptDump[ModuleScript]
BuildAvalancheMountains[ModuleScript]
BuildStalls[ModuleScript]
PluginCurves[Folder]
ClaudeBuild[Folder] BuildLevel2Festival,BuildLobby,ChristmasKit,ChristmasBuild,ChristmasBuild2
Packages[Folder] DataKit
DevTools[Folder] PlaceMap,GroundTexturer
MountainLookBackup[Folder] Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakFront,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakBack,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakFront,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakBack,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.Flank,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakBack,+17
CuteModels[Folder] CutePenguinTall,CutePenguinStand,CuteArch,CutePenguinSit,CuteIgloo,BlockPenguin,+2
CuteReplacedBackup[Folder] SittingPenguin,TallPenguin,LeftPenguin,Igloo,Igloo,WelcomeArch
LobbyDecorBackup[Folder] FencePennants,Pine,Pine,Pine,Pine,Guide_WaitingLine
LobbyQuitado[Folder] Jardin3,Jardin4,Jardin5,Jardin6,ArbolitoMaceta,ArbolitoMaceta,+98
Respaldo_MapaViejo[Folder] ChristmasTrack_v1_old,Niveles2a5,Nivel1_Bajada_Terrain,Nivel1_Bajada,Nivel1_Festive_Crowd,Nivel1_Festive_Lights,+6
