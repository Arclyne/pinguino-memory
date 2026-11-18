---
tipo: mapa-place
generado: sí (ServerStorage.DevTools.PlaceMap; no editar a mano; ver herramientas/LEEME.md)
---
# Mapa de la place

Formato. scripts: `Nombre TipoLíneas | api | req | rem | tag | attr | key | svc` (M módulo, S script, L local; `+N` = N más sin listar). etiquetas: `Etiqueta total | por nivel | clases | atributos{valores}`. niveles: posiciones del mundo redondeadas a studs. Qué hace cada sistema: [[sistemas]].

# huella
place=Prueba de pingüino placeId=76340917059535 universeId=10776032682 generado=2026-11-17 19:20
huella: scripts=201 lineas=33380 codigo=01f75ebd instancias=20481 mundo=938b1853
# scripts
## ReplicatedStorage.Shared
AvalancheModeConfig M31
AvalancheTrack M96 | api:distanceOf,fieldEndZ,fieldTopY,forward,frameAtDistance,heightAtDistance,lipPosition,normal,rampBaseZ,widthAtDistance,zAt,zoneIndexAt
ChristmasTrack M313 | api:centerAt,distanceToRoad,frameAt,guideDirection,heightAt,normalAt,progressAt,rescueFrame,shortcutAt,tangentAt,widthAt,xAt,zoneIndexAt
Cleaner M44 | api:clean,new
EconomyConfig M55
EconomyRemotes M21
EggCatalog M49 | api:get,isValid,list,orderOf
EggConfig M90 | tag:BaseNest,PlayerBase | attr:NestIndex,PlotIndex,SpotIndex
EggField M147 | api:_eggsOfBiome,between,find,new,positionOf | req:EggCatalog,EggConfig,EndlessConfig,EndlessLayout
EggRemotes M14
EndlessCatalog M150 | api:theme | req:EndlessConfig | attr:Blocked,Exit,From,GuardLeft,GuardRight,Length,PathBank,PathStep,PathX,PathY,Role,To,Weight
EndlessConfig M114 | attr:PenguinHealth,PenguinMaxHealth
EndlessLayout M272 | api:_append,bankAt,biomeName,biomeSpanAt,centerAt,chunk,chunkAt,chunkWorldOrigin,distanceOf,forPlayer,forSeed,frameAt,guardAt,heightAt,+5 | req:EconomyConfig,EndlessCatalog,EndlessConfig
EventConfig M87 | attr:AvalancheEventRun
EventRemotes M11
GameConfig M107 | tag:BoostRamp | attr:JumpDistance,KeepSpeed
LaunchMath M49 | api:clampAim,direction,flightGravity,positionAt,pullOffset,speed,velocity | req:GameConfig
LevelRegistry M60 | api:arrivalFrame,firstTagged,levelOf,nextLevel,playerLevel | req:GameConfig | tag:PlateauSpawn,ReturnPortal | attr:DestinationLevel,LevelId
PenguinOrientation M16 | api:bellyDown
Pose M36 | api:isValid
Remotes M16
RunState M8
ShopRotation M58 | api:indexAt,offers,secondsLeft | req:EggCatalog,EggConfig
Signal M42 | api:Connect,Disconnect,Fire,new
SkinAppearance M461 | api:apply,clear | tag:ChaseBulb,FlickeringFlame,PulseGlow | attr:ChaseIndex,SkinBaseColor,SkinBaseMaterial,SkinBaseTransparency,SkinId
SkinCatalog M206 | api:get,hatchable,isValid,list,statsOf
SlingshotGeometry M39 | api:find,findAll,seatFrame | req:LevelRegistry | tag:Slingshot | attr:LaunchForward,SeatPosition
WheelCatalog M67 | api:chance,count,list,pick,totalWeight
## ServerScriptService
EconomyMain S5 | req:name
## ServerScriptService.Server.Data
PlayerProfile M158 | api:addEgg,addPenguin,currentWeek,newUid,rollWeek,sanitize | req:EconomyConfig,EggCatalog,SkinCatalog | svc:Http
## ServerScriptService.Server
Main S27 | req:AvalancheModeService,DeathService,EndlessRunService,LevelFlowService,LevelService,PoseService,RaceService,ReturnService,RunStateService,RunStatsService,SlingshotService
## ServerScriptService.Server.Services
AvalancheModeService M270 | api:absorbCrash,init | req:AvalancheModeConfig,AvalancheTrack,EventRemotes,LevelRegistry,PlayerDataService,Remotes,ReturnService,RunState,RunStateService,SlingshotGeometry,SlingshotService | rem:AvalancheModeRequested,RaceNotice
BaseService M280 | api:init,plotIndexOf | req:EggCatalog,EggConfig,EggRemotes,IncubationService,PlayerDataService,PlayerProfile,RateLimiter,RunState,SkinAppearance,SkinCatalog | rem:BaseTravelRequested,EggNotice | attr:RunState
DeathService M101 | api:handleElimination,init | req:EndlessRunService,GameConfig,RateLimiter,Remotes,RunStatsService | rem:DeathRespawnRequested,RaceNotice
EggCarryService M141 | api:init,slotsOf | req:EggConfig,EggField,EggRemotes,EndlessLayout,EndlessRunService,PlayerDataService,PlayerProfile,RateLimiter | rem:EggDropRequested,EggNotice,EggPickupRequested
EndlessRunService M303 | api:absorbCrash,absorbHazard,closeRun,deathKind,init | req:EndlessConfig,EndlessLayout,LevelRegistry,PlayerDataService,Remotes,RunState,RunStateService,Signal,SkinCatalog | rem:RaceNotice
EventService M405 | api:fishMultiplier,init | req:ChristmasTrack,EventConfig,EventRemotes,LaunchMath,LevelRegistry,PlayerDataService,Remotes,RunState,RunStateService,SlingshotGeometry | rem:EventPickupRequested,RaceJoinRequested,RaceNotice
FishService M221 | api:init | req:AvalancheTrack,ChristmasTrack,EconomyConfig,EconomyRemotes,EventService,LevelRegistry,PlayerDataService,RateLimiter,RunState,RunStateService | rem:FishCollectRequested | tag:FinishLine,FishEnd,FishPickup,Hazard,Slingshot | attr:PickupId
IncubationService M138 | api:hatch,incubate,init,interact,nestSlots,totalNests | req:EggCatalog,EggConfig,EggRemotes,PlayerDataService,PlayerProfile,RateLimiter,SkinCatalog | rem:EggNotice,NestActionRequested
LeaderboardService M161 | api:init | req:EconomyConfig,EconomyRemotes,PlayerDataService,SkinCatalog | rem:LeaderboardChanged,LeaderboardRequested | svc:DataStore
LevelFlowService M70 | api:init | req:GameConfig,LevelRegistry,ReturnService,RunState,RunStateService,SlingshotGeometry,SlingshotService
LevelService M46 | api:init | req:LevelRegistry
PlayerDataService M210 | api:addFish,currentWeek,get,init,snapshot,spendFish,update | req:DataKit,EconomyConfig,EconomyRemotes,PlayerProfile,Signal | rem:ProfileChanged,ProfileRequested
PoseService M48 | api:init | req:Pose,RateLimiter,Remotes,RunState,RunStateService | rem:PoseChanged | attr:Pose
ProgressService M96 | api:init,isUnlocked | req:AvalancheTrack,EconomyRemotes,GameConfig,LevelRegistry,PlayerDataService,RateLimiter,ReturnService,RunState,RunStateService,SlingshotService | rem:LaunchPadRequested,LevelTravelRequested | tag:Slingshot | attr:DismountPosition
RaceService M171 | api:init | req:AvalancheModeService,DeathService,EndlessRunService,GameConfig,LevelRegistry,RateLimiter,Remotes,RunState,RunStateService | rem:CrashReported,RaceNotice | tag:FinishLine,Hazard | attr:HazardKind,KillHeight
ReturnService M81 | api:init | req:LevelRegistry,RateLimiter,RunState,RunStateService,Signal | tag:ReturnPortal | attr:DestinationLevel
RewardService M58 | api:init | req:EconomyConfig,EconomyRemotes,PlayerDataService,RateLimiter | rem:BoostPurchaseRequested,DailyGiftClaimRequested
RunStateService M72 | api:get,init,reset,transition | req:Remotes,RunState,Signal | rem:RunStateChanged | attr:RunState
RunStatsService M78 | api:init,snapshot | req:GameConfig,PlayerDataService,RunState,RunStateService
ShopRotationService M51 | api:init | req:EggConfig,EggRemotes,PlayerDataService,PlayerProfile,RateLimiter,ShopRotation | rem:ShopOfferPurchaseRequested
SkinService M79 | api:grant,init,owns | req:EconomyRemotes,PlayerDataService,PlayerProfile,RateLimiter,SkinAppearance,SkinCatalog | rem:SkinEquipRequested
SlingshotService M202 | api:init,mountAtLevel | req:GameConfig,LaunchMath,LevelRegistry,RateLimiter,Remotes,RunState,RunStateService,SlingshotGeometry | rem:AimChanged,DismountRequested,LaunchRequested | attr:AimPitch,AimPull,AimYaw,DismountPosition
WheelService M102 | api:init | req:EconomyConfig,EconomyRemotes,PlayerDataService,RateLimiter,SkinService,WheelCatalog | rem:WheelSpinPurchaseRequested,WheelSpinRequested,WheelSpun
## ServerScriptService.Server.Util
RateLimiter M42 | api:allow,new
## ServerStorage
BuildAvalancheMountains M237 | req:SlingshotGeometry | tag:AvalancheMountain,AvalancheSiren,CheeringPenguin | attr:CheerMode,Cheers,ChunkIndex,LevelId,PlateauEdge
BuildStalls M532 | req:SkinAppearance | tag:ChaseBulb,PulseGlow,SpinningDecor,SwingingDecor | attr:ChaseIndex,OpensPanel,SpinSpeed,SwingAmplitude | key:E
## ServerStorage.ClaudeBuild
AvalancheModeBuild M439 | api:run | req:Clone | tag:AvalancheMountain,FinishLine,FishEnd,PlateauSpawn,ReturnPortal,Slingshot | attr:Bumper,DestinationLevel,DismountPosition,KeepSpeed,KillHeight,LevelId,PlateauEdge,SeatPosition,Side,TrackDistance
BuildBases M315 | api:run | req:EggConfig | attr:MovedToWings
BuildLevel2Festival M524 | tag:ChaseBulb,CheeringPenguin,DragonParade,SkyLantern,SpinningDecor,SwingingDecor | attr:ChaseIndex,CheerMode,CheerPhase,Cheers,PathCenter,PathRadiusX,PathRadiusZ,PathSpeed,RiseHeight,RiseSpeed,SegmentIndex,SpinAxis,SpinSpeed,SwingAmplitude
BuildLobby M485 | req:SkinAppearance,WheelCatalog | tag:ChaseBulb,ChevronArrow,LobbyLeaderboard,LobbyWheel,PodiumMannequin,PulseGlow,SpinningDecor | attr:ChaseIndex,ChevronIndex,Face,OpensPanel,Rank,SegmentCount,SpinSpeed | key:E
ChristmasBuild M706 | api:finishArea,zone1,zone2,zone3,zone4,zone5,zone6,zone7,zone8 | req:Clone | tag:FinishLine | attr:Bumper
ChristmasBuild2 M460 | api:clean,flyers,ground,shortcuts,track,world | req:Clone | tag:BoostRamp,FinishLine | attr:JumpDistance,JumpRamp,KeepSpeed
ChristmasKit M862 | api:ball,boostPad,buildRail,building,candyCane,car,conveyor,cyl,factory,fillSides,folder,gift,gingerHouse,house,+27 | req:Clone | tag:BoostRamp | attr:Bumper,JumpDistance,JumpRamp,KeepSpeed
ChristmasObstacles M465 | api:build | req:Clone | attr:Bumper,TrackDistance
EggDesignBuilder M157 | api:build,runAll | req:ServerStorage | attr:DisplayName,EggHeight,Rarity
EggDesignData M50
EndlessBiomeBuilder M1108 | api:run,themeNames | req:Clone | attr:Blocked,Bumper,Exit,From,Length,PathBank,PathStep,PathX,PathY,Role,SliceLength,Theme,To
EndlessGuardBuilder M179 | api:run,runAll | attr:Bumper,From,GuardLeft,GuardRight,Length,PathStep,PathX,PathY,To
EndlessObstacleBuilder M655 | api:run,runAll | attr:Builder,Weight
EndlessPieceCutter M554 | api:cut,cutObstacles,pieceIds | req:ChristmasTrack | attr:Blocked,Exit,From,Length,PathBank,PathStep,PathX,PathY,Role,SliceLength,SourceFrom,SourceTo,Theme,To,TrackDistance
RearrangeLobby M77 | api:run | attr:RearrangedForBases
## ServerStorage
ClaudeScriptDump M1270 | api:_crashInto,_holdFrame,_onRaceNotice,_playStretchFeedback,_setPhase,_step,_stepFlight,_stepSlide,_switchTo,_tumble,_updateHeading,clearFinish,detect,elapsedSeconds,+14 | req:AimCamera,AimHudPresenter,AimHudView,AimInput,AimModel,AimingMode,BodyMover,ChaseCamera,Cleaner,CrashSensor,DecorationController,DefaultCamera,FeedbackSounds,FinishPresenter,FinishView,FinishedMode,+26 | rem:AimChanged,CrashReported,DismountRequested,LaunchRequested,RaceNotice,RunStateChanged | tag:FinishLine,Hazard | attr:HazardKind
## ServerStorage.Respaldo_MapaViejo
ChristmasRunClient L496 | req:Audio,AvalancheTrack,ChristmasTrack,EndlessConfig,Feedback,Remotes | rem:RaceNotice | tag:BoostRamp | attr:JumpRamp,LevelId,Offset,RunState
ChristmasRunService M264 | api:absorbCrash,absorbHazard,closeRun,init,isOutOfHealth | req:ChristmasTrack,LevelRegistry,Remotes,RunState,RunStateService | rem:RaceNotice | attr:PenguinHealth,PenguinMaxHealth,RunZone
ChristmasTrack_v1_old M169 | api:centerAt,frameAt,heightAt,progressAt,rescueFrame,tangentAt,widthAt,xAt,zoneIndexAt
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
AvalancheCinematic M1034 | api:init | req:AvalancheModeConfig,AvalancheTrack,EndlessLayout,LevelRegistry,RunState,SlingshotGeometry | tag:AvalancheMountain,AvalancheSiren | attr:AvalancheEventRun,BaseRate,BaseTransparency,RunState
## StarterPlayer.StarterPlayerScripts.Client.AvalancheMode
AvalancheModeModel M44 | api:new | req:AvalancheModeConfig,AvalancheTrack
AvalancheModeView M102 | api:new | req:UiKit
## StarterPlayer.StarterPlayerScripts.Client
AvalancheModeClient M214 | api:init | req:AvalancheModeConfig,AvalancheModeModel,AvalancheModeView,AvalancheTrack,LevelRegistry,ProfileStore,Remotes,RunState,UiKit | rem:RaceNotice | attr:RunState,TrackDistance
BaseClient M263 | api:init | req:EggAppearance,EggCatalog,EggConfig,EggRemotes,EggText,Feedback,ProfileStore,SkinCatalog,UiKit | rem:EggNotice
## StarterPlayer.StarterPlayerScripts.Client.Character
BodyMover M153 | api:destroy,face,holdAt,new,ragdoll,recover,releaseControl,setLiftEnabled,stopHolding,takeControl,teleport | req:GameConfig
DefaultCamera M19 | api:restore
LocalCharacter M62 | api:get,init | req:BodyMover,Signal
LocalPose M29 | api:get,set | req:Pose,Remotes,Signal | rem:PoseChanged
## StarterPlayer.StarterPlayerScripts.Client.DeathScreen
DeathScreenModel M84 | api:countdownText,fromNotice,secondsUntilReturn | req:TimeFormatter,UiKit
DeathScreenView M220 | api:new | req:DeathScreenModel,HudIcons,UiKit
## StarterPlayer.StarterPlayerScripts.Client
DeathScreenClient M168 | api:init | req:DeathScreenModel,DeathScreenView,EconomyRemotes,Feedback,FeedbackSounds,LocalCharacter,Remotes,RunState | rem:DeathRespawnRequested,LaunchPadRequested,RaceNotice | attr:RunState | key:ButtonA,ButtonB,L,R
## StarterPlayer.StarterPlayerScripts.Client.Decoration
ChaseLights M56 | api:init,update | tag:ChaseBulb | attr:ChaseIndex
CheeringCrowd M122 | api:init,update | tag:CheeringPenguin | attr:CheerMode,CheerPhase,Cheers
DecorationController M38 | api:init | req:ChaseLights,CheeringCrowd,FlameFlicker,ParadeMotion,PulseGlow,SpinningDecor,SwingingDecor
FlameFlicker M63 | api:init,update | tag:FlickeringFlame
ParadeMotion M106 | api:init,update | tag:ChevronArrow,DragonParade | attr:ChevronIndex,Face,PathCenter,PathRadiusX,PathRadiusZ,PathSpeed,SegmentIndex
PulseGlow M49 | api:init,update | tag:PulseGlow
SpinningDecor M65 | api:init,update | tag:SpinningDecor | attr:SpinAxis,SpinSpeed
SwingingDecor M79 | api:init,update | tag:SkyLantern,SwingingDecor | attr:RiseHeight,RiseSpeed,SwingAmplitude
## StarterPlayer.StarterPlayerScripts.Client.Effects
WorldEffects M32 | api:splash
## StarterPlayer.StarterPlayerScripts.Client
EggRunClient M170 | api:init | req:EggCarryView,EggCatalog,EggConfig,EggField,EggFieldView,EggRemotes,EggText,EndlessConfig,EndlessLayout,Feedback,LevelRegistry,RunMessages,RunState,UiKit | rem:EggDropRequested,EggNotice,EggPickupRequested | attr:RunState | key:T
## StarterPlayer.StarterPlayerScripts.Client.Eggs
EggAppearance M147 | api:build,designFor | req:EggCatalog | attr:EggHeight,Rarity
EggAura M138 | api:attach,pulse | req:EggCatalog,EggText
EggCarryView M77 | api:new,render,setVisible | req:EggCatalog,UiKit
EggFieldView M100 | api:_show,clear,keyWithin,new,update | req:EggAppearance,EggAura,EggConfig,EggField
EggText M31 | api:count,duration,rarityName | req:EggCatalog
## StarterPlayer.StarterPlayerScripts.Client.Endless
BiomeAmbience M81 | api:nameOf,restore,show | req:EndlessConfig,EndlessLayout
BiomeArchView M123 | api:clear,new,update | req:EndlessConfig,EndlessLayout,UiKit
ChunkStreamer M208 | api:_buildWithin,_dismantleWithin,_enqueue,_pending,_release,clear,new,update | req:EndlessCatalog,EndlessConfig,EndlessLayout
EndlessHudModel M66 | api:crossedWarning,frostOf,isColdLoss,snapshot | req:EndlessConfig,EndlessLayout
EndlessHudView M107 | api:new | req:EndlessHudModel,UiKit
FrostEffect M49 | api:apply,clear,new
ObstacleMotion M126 | api:watch | attr:Face,Motion,SpinSpeed
RunMessages M85 | api:clear,show | req:UiKit
## StarterPlayer.StarterPlayerScripts.Client
EndlessClient M159 | api:init | req:BiomeAmbience,BiomeArchView,ChunkStreamer,EndlessConfig,EndlessHudModel,EndlessHudView,EndlessLayout,FrostEffect,LevelRegistry,ObstacleMotion,Remotes,RunMessages,RunState,SkinCatalog | rem:RaceNotice | attr:RunState
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
LobbyHud M349 | api:init,open | req:AvalancheModeConfig,EconomyConfig,EconomyRemotes,EggsPanel,EventConfig,EventRemotes,Feedback,HudIcons,HudLife,InfoPanel,LeaderboardPanel,LevelsPanel,PanelHost,ProfileStore,RunState,ShopPanel,+3 | rem:AvalancheModeRequested,LaunchPadRequested | attr:OpensPanel,RunState | key:B,C,Escape,F,G,H,J,K,L,P,R,U,X,Y,Z | svc:ProximityPrompt
LobbyLighting M73 | api:init
Main L65 | req:AimCamera,AimHudPresenter,AimHudView,AimInput,AimModel,AimingMode,CameraFeel,ChaseCamera,DecorationController,FinishPresenter,FinishView,FinishedMode,IdleMode,LocalCharacter,PresentationController,RaceHudPresenter,+7
PanelHost M125 | api:close,isOpen,new,open | req:HudIcons,ProfileStore,UiKit
## StarterPlayer.StarterPlayerScripts.Client.Panels
EggsPanel M204 | api:build | req:EggCatalog,EggConfig,EggRemotes,EggText,Feedback,ProfileStore,UiKit | rem:BaseTravelRequested,NestActionRequested
InfoPanel M186 | api:build | req:EconomyConfig,EconomyRemotes,Feedback,ProfileStore,UiKit | rem:BoostPurchaseRequested,DailyGiftClaimRequested | svc:Social
LeaderboardPanel M185 | api:build | req:Feedback,LeaderboardStore,PenguinViewport,ProfileStore,UiKit | attr:TabIndex
LevelsPanel M70 | api:build | req:EconomyRemotes,Feedback,ProfileStore,UiKit | rem:LevelTravelRequested
ShopPanel M156 | api:build | req:EconomyConfig,EconomyRemotes,EggCatalog,EggRemotes,EggText,Feedback,ProfileStore,ShopRotation,UiKit | rem:BoostPurchaseRequested,ShopOfferPurchaseRequested,WheelSpinPurchaseRequested
SkinsPanel M247 | api:build,request | req:EconomyRemotes,EggCatalog,Feedback,PenguinViewport,ProfileStore,SkinCatalog,UiKit | rem:SkinEquipRequested
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
ProfileStore M66 | api:get,init,now | req:EconomyRemotes,Signal | rem:ProfileChanged,ProfileRequested
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
TrackFence M56 | api:keepInside | req:EndlessConfig,EndlessLayout,LevelRegistry
TrackGuide M45 | api:at | req:EndlessConfig,EndlessLayout,LevelRegistry
## StarterPlayer.StarterPlayerScripts.Client.Run.Modes
AimingMode M142 | api:_holdFrame,_playStretchFeedback,_step,enter,exit,new | req:AimCamera,AimInput,AimModel,Cleaner,FeedbackSounds,LaunchMath,LevelRegistry,LocalCharacter,LocalPose,PenguinOrientation,Pose,Remotes,SlingshotBandController,SlingshotGeometry,TrajectoryPreview | rem:AimChanged,DismountRequested,LaunchRequested
FinishedMode M59 | api:enter,exit,new | req:DefaultCamera,FeedbackSounds,GameConfig,LocalCharacter,LocalPose,Pose,RaceModel
IdleMode M36 | api:enter,exit,new | req:DefaultCamera,LocalCharacter,LocalPose,Pose
RacingMode M470 | api:_absorbHit,_assistSteer,_bounceOff,_crashInto,_onRaceNotice,_recoverAt,_scheduleRecover,_setPhase,_step,_stepFlight,_stepSlide,_tumble,_updateFeel,enter,+2 | req:AvalancheModeConfig,AvalancheTrack,BoostRampSensor,CameraFeel,ChaseCamera,Cleaner,CrashSensor,FeedbackSounds,GameConfig,GroundProbe,LevelRegistry,LocalCharacter,LocalPose,MoveInput,PenguinOrientation,Pose,+8 | rem:CrashReported,RaceNotice | attr:Bumper
## StarterPlayer.StarterPlayerScripts.Client.Run
RunController M54 | api:_switchTo,new,start | req:LocalCharacter,Remotes,RunState | rem:RunStateChanged
## StarterPlayer.StarterPlayerScripts.Client
RunEvents M712 | api:init | req:ChristmasTrack,EventConfig,EventRemotes,LevelRegistry,Remotes,RunState | rem:EventPickupRequested,RaceNotice | attr:RunState,TrackDistance
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
AvalancheMountain 2 | N1=1 N2=1 | Folder | PlateauEdge{140/38160}
AvalancheSiren 2 | N1=1 N2=1 | Part |
BaseNest 72 | N1=72 | Part | NestIndex{6 valores}
BoostRamp 0 | solo en ejecucion o sin usar
BreakableWindow 0 | solo en ejecucion o sin usar
ChaseBulb 243 | N1=243 | Part | ChaseIndex{47 valores}
CheeringPenguin 17 | N1=16 N2=1 | Model | CheerMode{wave} CheerPhase{16 valores} Cheers{true}
ChevronArrow 11 | N1=11 | Model | ChevronIndex{11 valores}
CuteArch 1 | N1=1 | Model |
CuteIgloo 1 | N1=1 | Model |
CutePenguin 8 | N1=8 | Model |
DragonParade 0 | solo en ejecucion o sin usar
FinishLine 1 | N2=1 | Part |
FishEnd 1 | N2=1 | Part |
FishPickup 0 | solo en ejecucion o sin usar
FlickeringFlame 19 | N1=19 | Part |
Hazard 0 | solo en ejecucion o sin usar
HouseShell 0 | solo en ejecucion o sin usar
LobbyLeaderboard 1 | N1=1 | Model |
LobbyWheel 1 | N1=1 | Model | SegmentCount{12}
PlateauSpawn 2 | N1=1 N2=1 | Part,SpawnLocation |
PlayerBase 12 | N1=12 | Model | PlotIndex{12 valores}
PodiumMannequin 3 | N1=3 | Model | Rank{1/2/3} SkinId{classic}
PulseGlow 19 | N1=19 | Part |
ReturnPortal 1 | N2=1 | Part | DestinationLevel{1}
SkyLantern 0 | solo en ejecucion o sin usar
Slingshot 2 | N1=1 N2=1 | Model | AimPitch{0} AimPull{0} AimYaw{0} DismountPosition{(-20000,6552,38046)/(0,608.5,26)} LaunchForward{(0,0,-1)} SeatPosition{(-20000,6583,38040)/(0,638.8,20)}
SpinningDecor 12 | N1=12 | Model | SpinSpeed{12 valores}
SwingingDecor 3 | N1=3 | Model | SwingAmplitude{0.08/0.12}
# niveles
## N1 PenguinSlingshotMap_v01 | instancias=5747 partes=4718 conColision=2592 | min(-582,163,-10) max(501,821,416)
hijos: AvalancheMountain[Folder]226 · FestiveDecoration[Folder]1027 · Lobby[Folder]4367 · PlateauFence[Part]0 · PlateauFence[Part]0 · PlateauFence[Part]0 · SlingshotDecor[Model]52 · Slingshot[Model]61 · Terrain[Folder]4 · WaitingPenguins[Folder]0
PlateauSpawn: Lobby.PlateauSpawn [SpawnLocation] pos(0,601,110) size(30,1,30)
Slingshot: Slingshot [Model] pos(0,614,20) AimPitch=0,AimPull=0,AimYaw=0,DismountPosition=(0,608.5,26),LaunchForward=(0,0,-1),SeatPosition=(0,638.8,20)
LobbyWheel: Lobby.LuckyWheel.LobbyWheel [Model] pos(-78,625,139) SegmentCount=12
LobbyLeaderboard: Lobby.HallOfFame.LobbyLeaderboard [Model] pos(0,626,150)
Hazard: ninguno
Lobby: Bases(123,611,132) · ChevronRoad(5,600,66) · HallOfFame(-8,643,149) · LobbyDecor(-166,607,80) · LuckyWheel(-72,651,139) · MostPopular(64,602,32) · PenguinCampfire(-33,603,101) · PenguinCampfire2(35,603,99) · PlateauSpawn(0,601,110) · Shop(60,604,132)
## N2 AvalancheMode | instancias=14726 partes=14468 conColision=633 | min(-21080,-6437,-39376) max(-18911,6765,38436)
hijos: AvalancheMountain[Folder]226 · Finale[Model]127 · GroundTexture[Folder]9563 · Obstacles[Folder]1000 · Plateau[Folder]12 · ReturnPortalGate[Model]574 · Scenery[Folder]2636 · SlingshotDecor[Model]52 · Slingshot[Model]61 · Track[Folder]465
PlateauSpawn: Plateau.PlateauSpawn [Part] pos(-20000,6545,38120) size(30,1,30)
Slingshot: Slingshot [Model] pos(-20000,6558,38040) AimPitch=0,AimPull=0,AimYaw=0,DismountPosition=(-20000,6552,38046),LaunchForward=(0,0,-1),SeatPosition=(-20000,6583,38040)
FinishLine: Finale.FinishLine [Part] pos(-20000,-6430,-39376) size(220,1,2)
ReturnPortal: ReturnPortalGate.ReturnPortalTrigger [Part] pos(-20000,-6419,-38935) size(11,22,2) DestinationLevel=1
Hazard: ninguno
# mundo
workspace: StreamingEnabled=true MinRadius=64 TargetRadius=768 IntegrityMode=PauseOutsideLoadedArea Gravity=196.2 FallenPartsDestroyHeight=-9000
fuera de niveles: SpawnLocation[SpawnLocation](0,1,0) · Baseplate[Part](0,-8,0)
## prompts
N1 PenguinSlingshotMap_v01.Lobby.LuckyWheel.LobbyWheel.Base | Girar · Ruleta de la suerte | tecla=E dist=26 OpensPanel=wheel
N1 PenguinSlingshotMap_v01.Lobby.HallOfFame.PromptAnchor | Ver tabla · Salón de la fama | tecla=E dist=22 OpensPanel=leaderboard
N1 PenguinSlingshotMap_v01.Lobby.MostPopular.PromptAnchor | Ver skins · Más populares | tecla=E dist=18 OpensPanel=skins
N1 PenguinSlingshotMap_v01.Lobby.Shop.PromptAnchor | Abrir · Tienda | tecla=E dist=16 OpensPanel=shop
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base10.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base10.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base10.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base10.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base10.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base10.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base05.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base05.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base05.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base05.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base05.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base05.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base08.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base08.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base08.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base08.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base08.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base08.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base02.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base02.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base02.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base02.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base02.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base02.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base09.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base09.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base09.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base09.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base09.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base09.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base07.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base07.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base07.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base07.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base07.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base07.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base04.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base04.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base04.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base04.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base04.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base04.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base11.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base11.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base11.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base11.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base11.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base11.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base03.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base03.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base03.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base03.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base03.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base03.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base01.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base01.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base01.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base01.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base01.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base01.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base12.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base12.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base12.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base12.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base12.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base12.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base06.Nests.Nest6 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base06.Nests.Nest2 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base06.Nests.Nest1 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base06.Nests.Nest5 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base06.Nests.Nest4 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Lobby.Bases.Base06.Nests.Nest3 | Poner huevo · Nido | tecla=E dist=8
N1 PenguinSlingshotMap_v01.Slingshot.Frame.Trunk.MountPromptAttachment | Subirse · Resortera | tecla=E dist=24
N2 AvalancheMode.Slingshot.Frame.Trunk.MountPromptAttachment | Subirse · Resortera | tecla=E dist=24
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
ClaudeBuild[Folder] BuildLevel2Festival,BuildLobby,ChristmasKit,ChristmasBuild,ChristmasBuild2,ChristmasObstacles,+9
Packages[Folder] DataKit
DevTools[Folder] PlaceMap,GroundTexturer
MountainLookBackup[Folder] Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakFront,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakBack,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakFront,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakBack,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.Flank,Workspace.PenguinSlingshotMap_v01.AvalancheMountain.PeakBack,+17
CuteModels[Folder] CutePenguinTall,CutePenguinStand,CuteArch,CutePenguinSit,CuteIgloo,BlockPenguin,+2
CuteReplacedBackup[Folder] SittingPenguin,TallPenguin,LeftPenguin,Igloo,Igloo,WelcomeArch
LobbyDecorBackup[Folder] FencePennants,Pine,Pine,Pine,Pine,Guide_WaitingLine
LobbyQuitado[Folder] Jardin3,Jardin4,Jardin5,Jardin6,ArbolitoMaceta,ArbolitoMaceta,+98
Respaldo_MapaViejo[Folder] ChristmasTrack_v1_old,ChristmasRunService,ChristmasRunClient,Niveles2a5,Nivel1_Bajada_Terrain,Nivel1_Bajada,+11
