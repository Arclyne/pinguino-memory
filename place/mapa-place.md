---
tipo: mapa-place
generado: sí (ServerStorage.DevTools.PlaceMap; no editar a mano; ver herramientas/LEEME.md)
---
# Mapa de la place

Formato. scripts: `Nombre TipoLíneas | api | req | rem | tag | attr | key | svc` (M módulo, S script, L local; `+N` = N más sin listar). etiquetas: `Etiqueta total | por nivel | clases | atributos{valores}`. niveles: posiciones del mundo redondeadas a studs. Qué hace cada sistema: [[sistemas]].

# huella
place=Place2 placeId=76340917059535 universeId=10776032682 generado=2026-11-13 06:56
huella: scripts=136 lineas=18439 codigo=79f4e2ab instancias=61499 mundo=aead3f96
# scripts
## ReplicatedStorage.Shared
Cleaner M44 | api:clean,new
EconomyConfig M46
EconomyRemotes M22
GameConfig M79 | tag:BoostRamp
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
Main S19 | req:LevelFlowService,LevelService,PoseService,RaceService,ReturnService,RunStateService,SlingshotService
## ServerScriptService.Server.Services
FishService M189 | api:init | req:EconomyConfig,EconomyRemotes,LevelRegistry,PlayerDataService,RateLimiter,RunState,RunStateService | rem:FishCollectRequested | tag:FinishLine,FishPickup,Hazard,Slingshot | attr:PickupId
LeaderboardService M161 | api:init | req:EconomyConfig,EconomyRemotes,PlayerDataService,SkinCatalog | rem:LeaderboardChanged,LeaderboardRequested | svc:DataStore
LevelFlowService M70 | api:init | req:GameConfig,LevelRegistry,ReturnService,RunState,RunStateService,SlingshotGeometry,SlingshotService
LevelService M46 | api:init | req:LevelRegistry
PlayerDataService M205 | api:addFish,currentWeek,get,init,snapshot,spendFish,update | req:DataKit,EconomyConfig,EconomyRemotes,PlayerProfile,Signal | rem:ProfileChanged,ProfileRequested
PoseService M48 | api:init | req:Pose,RateLimiter,Remotes,RunState,RunStateService | rem:PoseChanged | attr:Pose
ProgressService M90 | api:init,isUnlocked | req:EconomyRemotes,GameConfig,LevelRegistry,PlayerDataService,RateLimiter,ReturnService,RunState,RunStateService | rem:LaunchPadRequested,LevelTravelRequested | tag:Slingshot | attr:DismountPosition
RaceService M147 | api:init | req:GameConfig,LevelRegistry,RateLimiter,Remotes,RunState,RunStateService | rem:CrashReported,RaceNotice | tag:FinishLine,Hazard | attr:HazardKind
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
## ServerStorage
ClaudeScriptDump M1270 | api:_crashInto,_holdFrame,_onRaceNotice,_playStretchFeedback,_setPhase,_step,_stepFlight,_stepSlide,_switchTo,_tumble,_updateHeading,clearFinish,detect,elapsedSeconds,+14 | req:AimCamera,AimHudPresenter,AimHudView,AimInput,AimModel,AimingMode,BodyMover,ChaseCamera,Cleaner,CrashSensor,DecorationController,DefaultCamera,FeedbackSounds,FinishPresenter,FinishView,FinishedMode,+26 | rem:AimChanged,CrashReported,DismountRequested,LaunchRequested,RaceNotice,RunStateChanged | tag:FinishLine,Hazard | attr:HazardKind
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
## StarterPlayer.StarterPlayerScripts.Client
AvalancheCinematic M981 | api:init | req:LevelRegistry,RunState,SlingshotGeometry | tag:AvalancheMountain,AvalancheSiren | attr:BaseRate,RunState
## StarterPlayer.StarterPlayerScripts.Client.Character
BodyMover M141 | api:destroy,face,holdAt,new,ragdoll,releaseControl,setLiftEnabled,stopHolding,takeControl,teleport | req:GameConfig
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
LevelsPanel M74 | api:build | req:EconomyRemotes,Feedback,ProfileStore,UiKit | rem:LevelTravelRequested
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
CameraOcclusion M74 | api:_firstBlockingHit,new,resolve
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
SlideMotor M188 | api:_speedCap,_updateHeading,boost,boostFraction,groundNormal,new,requestJump,resetHeading,step | req:BodyMover,GameConfig,GroundProbe,PenguinOrientation
SpeedEffects M223 | api:setBoost,start,stop | req:GameConfig
## StarterPlayer.StarterPlayerScripts.Client.Run.Modes
AimingMode M142 | api:_holdFrame,_playStretchFeedback,_step,enter,exit,new | req:AimCamera,AimInput,AimModel,Cleaner,FeedbackSounds,LaunchMath,LevelRegistry,LocalCharacter,LocalPose,PenguinOrientation,Pose,Remotes,SlingshotBandController,SlingshotGeometry,TrajectoryPreview | rem:AimChanged,DismountRequested,LaunchRequested
FinishedMode M59 | api:enter,exit,new | req:DefaultCamera,FeedbackSounds,GameConfig,LocalCharacter,LocalPose,Pose,RaceModel
IdleMode M36 | api:enter,exit,new | req:DefaultCamera,LocalCharacter,LocalPose,Pose
RacingMode M280 | api:_crashInto,_onRaceNotice,_setPhase,_step,_stepFlight,_stepSlide,_tumble,_updateFeel,enter,exit,new | req:BoostRampSensor,CameraFeel,ChaseCamera,Cleaner,CrashSensor,FeedbackSounds,GameConfig,GroundProbe,LocalCharacter,LocalPose,MoveInput,PenguinOrientation,Pose,RaceFeel,RaceModel,Remotes,+3 | rem:CrashReported,RaceNotice
## StarterPlayer.StarterPlayerScripts.Client.Run
RunController M54 | api:_switchTo,new,start | req:LocalCharacter,Remotes,RunState | rem:RunStateChanged
## StarterPlayer.StarterPlayerScripts.Client
StepAssist M111 | api:init | attr:RunState
UiKit M270 | api:badge,border,button,corner,cornerScale,formatClock,formatNumber,gradient,label,new,padding,pulse,ribbon,textStroke
WindowBreaker M477 | api:init | req:LevelRegistry,RunState | tag:BreakableWindow,HouseShell | attr:DisplayName,HouseIndex,LevelId,RunState,WindowCount,WorldZMax,WorldZMin
WorldBoardController M142 | api:init | req:LeaderboardStore,SkinAppearance,UiKit | tag:LobbyLeaderboard,PodiumMannequin | attr:Rank
WorldWheelController M163 | api:init | req:EconomyConfig,EconomyRemotes,WheelCatalog,WheelPanel | rem:WheelSpun | tag:LobbyWheel | attr:ChaseIndex
## StarterPlayer.StarterPlayerScripts
CuteDecorIdle L126 | tag:CuteArch,CuteIgloo,CutePenguin | attr:Role
LobbyMain L5 | req:name
## sin detalle
ServerStorage.DevTools.PlaceMap scripts=1 lineas=659
ServerStorage.Packages.DataKit scripts=16 lineas=2560
# etiquetas
AvalancheMountain 1 | N1=1 | Folder | PlateauEdge{140}
AvalancheSiren 1 | N1=1 | Part |
BoostRamp 5 | N1=1 N2=3 N3=1 | Part,WedgePart |
BreakableWindow 36 | N5=36 | Model | HouseIndex{18 valores}
ChaseBulb 493 | N1=243 N2=250 | Part | ChaseIndex{79 valores}
CheeringPenguin 237 | N1=194 N2=43 | Model | CheerMode{cheer/drum/music/shovel/wave} CheerPhase{234 valores} Cheers{false/true}
ChevronArrow 11 | N1=11 | Model | ChevronIndex{11 valores}
CuteArch 1 | N1=1 | Model |
CuteIgloo 2 | N1=2 | Model |
CutePenguin 3 | N1=3 | Model |
DragonParade 1 | N2=1 | Model | PathCenter{(5938,63.34,-1875)} PathRadiusX{22} PathRadiusZ{24} PathSpeed{0.45}
FinishLine 5 | N1=1 N2=1 N3=1 N4=1 N5=1 | Part |
FishPickup 0 | solo en ejecucion o sin usar
FlickeringFlame 39 | N1=39 | Part |
Hazard 256 | N1=3 N3=240 N4=7 N5=6 | Part | HazardKind{Pit/Water}
HouseShell 738 | N5=738 | Part,WedgePart |
LandingZone 1 | N1=1 | Part |
LobbyLeaderboard 1 | N1=1 | Model |
LobbyWheel 1 | N1=1 | Model | SegmentCount{12}
PlateauSpawn 5 | N1=1 N2=1 N3=1 N4=1 N5=1 | Part,SpawnLocation |
PodiumMannequin 3 | N1=3 | Model | Rank{1/2/3} SkinId{classic}
PulseGlow 71 | N1=39 N2=6 N3=6 N5=20 | Part | SpinSpeed{1.2}
ReturnPortal 5 | N1=1 N2=1 N3=1 N4=1 N5=1 | Part | DestinationLevel{2/3/4/5}
SkyLantern 28 | N2=28 | Model | RiseHeight{27 valores} RiseSpeed{28 valores}
Slingshot 5 | N1=1 N2=1 N3=1 N4=1 N5=1 | Model | AimPitch{0} AimPull{0} AimYaw{0} DismountPosition{(0,608.5,26)/(12000,608.5,26)/(18000,1208,26)/(24000,1208,26)/(6000,608.5,26)} LaunchForward{(0,0,-1)} SeatPosition{(0,638.8,20)/(12000,638.8,20)/(18000,1239,20)/(24000,1239,20)/(6000,638.8,20)}
SpinningDecor 21 | N1=16 N2=3 N5=2 | Model,Part | SpinAxis{Z} SpinSpeed{14 valores}
SwingingDecor 96 | N1=3 N2=93 | Model | SwingAmplitude{41 valores}
# niveles
## N1 PenguinSlingshotMap_v01 | instancias=11905 partes=8096 conColision=2504 | min(-607,-10,-2634) max(593,821,416)
hijos: AvalancheMountain[Folder]226 · Decoration[Folder]684 · FestiveDecoration[Folder]8263 · FinishArch[Model]19 · FinishPlaza[Folder]100 · Guides[Folder]2 · Lobby[Folder]1657 · Obstacles[Folder]205 · PlateauFence[Part]0 · PlateauFence[Part]0 · PlateauFence[Part]0 · PlateauSpawn[SpawnLocation]0 · ReturnPortalGate[Model]574 · SlingshotDecor[Model]52 · Slingshot[Model]61 · Terrain[Folder]32 · Track[Folder]12 · WaitingPenguins[Folder]0
PlateauSpawn: PlateauSpawn [SpawnLocation] pos(0,601,110) size(30,1,30)
Slingshot: Slingshot [Model] pos(0,614,20) AimPitch=0,AimPull=0,AimYaw=0,DismountPosition=(0,608.5,26),LaunchForward=(0,0,-1),SeatPosition=(0,638.8,20)
LandingZone: Guides.Guide_LandingZone [Part] pos(0,535,-110) size(100,2,145)
FinishLine: FinishArch.FinishLine [Part] pos(0,36,-1700) size(120,2,2)
ReturnPortal: ReturnPortalGate.ReturnPortalTrigger [Part] pos(0,41,-1849) size(11,22,2) DestinationLevel=2
BoostRamp: Obstacles.SnowMound [WedgePart] pos(-10,307,-800) size(20,4,16)
LobbyWheel: Lobby.LuckyWheel.LobbyWheel [Model] pos(-92,625,72) SegmentCount=12
LobbyLeaderboard: Lobby.HallOfFame.LobbyLeaderboard [Model] pos(101,626,62)
Hazard: Pit=2 Water=1
Lobby: ChevronRoad(0,600,66) · EventPedestal(-56,603,128) · HallOfFame(100,643,67) · LevelsPortal(0,637,150) · LuckyWheel(-104,603,70) · MostPopular(54,603,32) · PenguinCampfire(-43,605,54) · Shop(65,601,123)
## N2 PenguinSlingshotMap_Level2 | instancias=12009 partes=10226 conColision=3940 | min(5624,30,-1913) max(6378,642,139)
hijos: Decoration[Folder]2035 · FestivalDecoration[Folder]4310 · Gameplay[Folder]2 · Obstacles[Folder]971 · ReturnPortalGate[Model]574 · SlingshotDecor[Model]52 · Slingshot[Model]61 · Terrain[Folder]22 · Track[Folder]60 · Village[Folder]3911 · WaitingPenguins[Folder]0
PlateauSpawn: Gameplay.PlateauSpawn [Part] pos(6000,601,110) size(30,1,30)
Slingshot: Slingshot [Model] pos(6000,614,20) AimPitch=0,AimPull=0,AimYaw=0,DismountPosition=(6000,608.5,26),LaunchForward=(0,0,-1),SeatPosition=(6000,638.8,20)
FinishLine: Gameplay.FinishLine [Part] pos(6000,64,-1800) size(120,2,2)
ReturnPortal: ReturnPortalGate.ReturnPortalTrigger [Part] pos(6000,73,-1879) size(11,22,2) DestinationLevel=3
BoostRamp: Obstacles.Bridge.Plank [Part] pos(6000,228,-1216) size(16,1,5)
BoostRamp: Obstacles.Bridge.Plank [Part] pos(6000,229,-1221) size(16,1,5)
BoostRamp: Obstacles.Bridge.Plank [Part] pos(6000,226,-1210) size(16,1,5)
Hazard: ninguno
## N3 PenguinSlingshotMap_Level3 | instancias=9796 partes=9404 conColision=7366 | min(10776,-65,-3162) max(13363,667,544)
hijos: City[Folder]3269 · Decoration[Folder]194 · Gameplay[Folder]2 · Hazards[Folder]29 · Icicles[Folder]1350 · Obstacles[Folder]991 · ReturnPortalGate[Model]574 · SlingshotDecor[Model]52 · Slingshot[Model]61 · TrackBuildings[Folder]3263 · WaitingPenguins[Folder]0
PlateauSpawn: Gameplay.PlateauSpawn [Part] pos(12000,601,110) size(30,1,30)
Slingshot: Slingshot [Model] pos(12000,614,20) AimPitch=0,AimPull=0,AimYaw=0,DismountPosition=(12000,608.5,26),LaunchForward=(0,0,-1),SeatPosition=(12000,638.8,20)
FinishLine: Gameplay.FinishLine [Part] pos(12000,38,-2680) size(116,0,2)
ReturnPortal: ReturnPortalGate.ReturnPortalTrigger [Part] pos(12000,48,-2739) size(11,22,2) DestinationLevel=4
BoostRamp: Obstacles.ramp_39.Ramp [WedgePart] pos(12000,376,-1048) size(30,4,18)
Hazard: Pit=240
## N4 PenguinSlingshotMap_Level4 | instancias=8332 partes=7728 conColision=7142 | min(17000,-2,-3790) max(19000,1395,267)
hijos: CanyonWalls[Folder]562 · Decoration[Folder]159 · Forest[Folder]2300 · Gameplay[Folder]2 · Hazards[Folder]3 · Obstacles[Folder]1229 · PlaneWreck[Folder]466 · ReturnPortalGate[Model]574 · Ridges[Folder]390 · SlingshotDecor[Model]52 · Slingshot[Model]61 · Terrain[Folder]149 · WaitingPenguins[Folder]0 · Wildlife[Folder]2371
PlateauSpawn: Gameplay.PlateauSpawn [Part] pos(18000,1201,110) size(30,1,30)
Slingshot: Slingshot [Model] pos(18000,1214,20) AimPitch=0,AimPull=0,AimYaw=0,DismountPosition=(18000,1208,26),LaunchForward=(0,0,-1),SeatPosition=(18000,1239,20)
FinishLine: Gameplay.FinishLine [Part] pos(18000,202,-3440) size(124,0,2)
ReturnPortal: ReturnPortalGate.ReturnPortalTrigger [Part] pos(18000,209,-3529) size(11,22,2) DestinationLevel=5
Hazard: Pit=7
## N5 PenguinSlingshotMap_Level5 | instancias=19446 partes=18561 conColision=8604 | min(23000,100,-4800) max(25000,1495,149)
hijos: Decoration[Folder]5312 · Gameplay[Folder]26 · Hazards[Folder]6 · Houses[Folder]8164 · Mountains[Folder]135 · ReturnPortalGate[Model]574 · SlingshotDecor[Model]52 · Slingshot[Model]61 · Street[Folder]2512 · Terrain[Folder]33 · WaitingPenguins[Folder]0 · Yards[Folder]2559
PlateauSpawn: Gameplay.PlateauSpawn [Part] pos(24000,1201,110) size(30,1,30)
Slingshot: Slingshot [Model] pos(24000,1214,20) AimPitch=0,AimPull=0,AimYaw=0,DismountPosition=(24000,1208,26),LaunchForward=(0,0,-1),SeatPosition=(24000,1239,20)
FinishLine: Gameplay.FinishLine [Part] pos(24000,642,-4546) size(90,0,2)
ReturnPortal: ReturnPortalGate.ReturnPortalTrigger [Part] pos(24000,650,-4665) size(11,22,2)
Hazard: Pit=6
# mundo
workspace: StreamingEnabled=true MinRadius=64 TargetRadius=1024 IntegrityMode=PauseOutsideLoadedArea Gravity=196.2 FallenPartsDestroyHeight=-500
fuera de niveles: SpawnLocation[SpawnLocation](0,1,0) · Baseplate[Part](0,-8,0)
## prompts
N5 PenguinSlingshotMap_Level5.Slingshot.Frame.Trunk.MountPromptAttachment | Subirse · Resortera | tecla=E dist=24
N1 PenguinSlingshotMap_v01.Lobby.LuckyWheel.LobbyWheel.Base | Girar · Ruleta de la suerte | tecla=E dist=26 OpensPanel=wheel
N1 PenguinSlingshotMap_v01.Lobby.HallOfFame.PromptAnchor | Ver tabla · Salón de la fama | tecla=E dist=22 OpensPanel=leaderboard
N1 PenguinSlingshotMap_v01.Lobby.EventPedestal.PromptAnchor | Ver · Skin del evento | tecla=E dist=18 OpensPanel=event
N1 PenguinSlingshotMap_v01.Lobby.MostPopular.PromptAnchor | Ver skins · Más populares | tecla=E dist=18 OpensPanel=skins
N1 PenguinSlingshotMap_v01.Lobby.LevelsPortal.Swirl | Elegir nivel · Portal de niveles | tecla=E dist=18 OpensPanel=levels
N1 PenguinSlingshotMap_v01.Lobby.Shop.PromptAnchor | Abrir · Tienda | tecla=E dist=16 OpensPanel=shop
N1 PenguinSlingshotMap_v01.Slingshot.Frame.Trunk.MountPromptAttachment | Subirse · Resortera | tecla=E dist=24
N2 PenguinSlingshotMap_Level2.Slingshot.Frame.Trunk.MountPromptAttachment | Subirse · Resortera | tecla=E dist=24
N3 PenguinSlingshotMap_Level3.Slingshot.Frame.Trunk.MountPromptAttachment | Subirse · Resortera | tecla=E dist=24
N4 PenguinSlingshotMap_Level4.Slingshot.Frame.Trunk.MountPromptAttachment | Subirse · Resortera | tecla=E dist=24
## StarterGui
GameHud[ScreenGui] hijos: AimBar,RaceReadout,FinishReadout
## StarterCharacter
partes: Beak(0.3,0.18,0.24) · Body(2.4,2.8,2.12) · Cheek_L(0.16,0.1,0.02) · Cheek_R(0.16,0.1,0.02) · Eye_L(0.28,0.28,0.07) · Eye_R(0.28,0.28,0.07) · Flipper_L(0.3,1.4,0.6) · Flipper_R(0.3,1.4,0.6) · Foot_L(0.8,0.3,1) · Foot_R(0.8,0.3,1) · HumanoidRootPart(2.4,2.8,2)invisible · SlideCollider(2,2,2)invisible · Tail(0.3,0.3,0.25)
uniones: BeakWeld[Weld]:Body>Beak · Cheek_LWeld[Weld]:Body>Cheek_L · Cheek_RWeld[Weld]:Body>Cheek_R · Eye_LWeld[Weld]:Body>Eye_L · Eye_RWeld[Weld]:Body>Eye_R · LeftAnkle[Motor6D]:Body>Foot_L · LeftShoulder[Motor6D]:Body>Flipper_L · RightAnkle[Motor6D]:Body>Foot_R · RightShoulder[Motor6D]:Body>Flipper_R · RootJoint[Motor6D]:HumanoidRootPart>Body · SlideColliderWeld[Weld]:HumanoidRootPart>SlideCollider · TailJoint[Motor6D]:Body>Tail
Humanoid: RigType=R15 HipHeight=0.3 WalkSpeed=16 JumpPower=50 UseJumpPower=true RequiresNeck=false
## ajustes
Players: CharacterAutoLoads=true RespawnTime=2.5
StarterPlayer: WalkSpeed=16 JumpHeight=7.2 CameraMaxZoomDistance=128
Lighting: ClockTime=14.2 Brightness=2.4 hijos: __WORLDFX[Sky],PenguinAtmosphere[Atmosphere],PenguinColor[ColorCorrectionEffect],PenguinSunRays[SunRaysEffect],PenguinBloom[BloomEffect]
## ServerStorage
ClaudeScriptDump[ModuleScript]
BuildAvalancheMountains[ModuleScript]
BuildStalls[ModuleScript]
PluginCurves[Folder]
ClaudeBuild[Folder] BuildLevel2Festival,BuildLobby
Packages[Folder] DataKit
DevTools[Folder] PlaceMap
MountainLookBackup[Folder] Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakFront,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakBack,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakFront,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakBack,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.Flank,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakBack,+17
CuteModels[Folder] CutePenguinTall,CutePenguinStand,CuteArch,CutePenguinSit,CuteIgloo
CuteReplacedBackup[Folder] SittingPenguin,TallPenguin,LeftPenguin,Igloo,Igloo,WelcomeArch
