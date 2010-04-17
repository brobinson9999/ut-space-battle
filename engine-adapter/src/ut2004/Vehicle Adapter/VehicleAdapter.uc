class VehicleAdapter extends Vehicle
  placeable;

defaultproperties
{
  DrawType=DT_Mesh
  Mesh=Mesh'ONSVehicles-A.AttackCraft'

  Health=300
  HealthMax=300
  DriverDamageMult=0.0
  CollisionHeight=+70.0
  CollisionRadius=150.0
  RanOverDamageType=class'DamTypeAttackCraftRoadkill'
  CrushedDamageType=class'DamTypeAttackCraftPancake'

  SoundVolume=160
  SoundRadius=200

  bShowDamageOverlay=True

  TPCamDistance=500
  TPCamLookAt=(X=0.0,Y=0.0,Z=0)
  TPCamWorldOffset=(X=0,Y=0,Z=200)

  bDrawDriverInTP=False
  bDrawMeshInFP=False
  bTurnInPlace=true
  bCanStrafe=true

  EntryPosition=(X=-40,Y=0,Z=0)
  EntryRadius=210.0

  ExitPositions(0)=(X=0,Y=-165,Z=100)
  ExitPositions(1)=(X=0,Y=165,Z=100)

  Begin Object Class=KarmaParamsRBFull Name=KParams0
    KStartEnabled=True
    KFriction=0.5
    KLinearDamping=0.0
    KAngularDamping=0.0
    KImpactThreshold=300
    bKNonSphericalInertia=True
        bHighDetailOnly=False
        bClientOnly=False
    bKDoubleTickRate=True
    bKStayUpright=True
    bKAllowRotate=True
    KInertiaTensor(0)=1.0
    KInertiaTensor(1)=0.0
    KInertiaTensor(2)=0.0
    KInertiaTensor(3)=3.0
    KInertiaTensor(4)=0.0
    KInertiaTensor(5)=3.5
    KCOMOffset=(X=-0.25,Y=0.0,Z=0.0)
    KActorGravScale=0.0
    bDestroyOnWorldPenetrate=True
    bDoSafetime=True
        Name="KParams0"
  End Object
  KParams=KarmaParams'KParams0'

  VehiclePositionString="in a Vehicle Adapter"
  VehicleNameString="Vehicle Adapter"
  GroundSpeed=2000
  bDriverHoldsFlag=false
  FlagOffset=(Z=80.0)
  FlagBone=PlasmaGunAttachment
  FlagRotation=(Yaw=32768)
  bCanCarryFlag=false

  MaxDesireability=0.6
}

