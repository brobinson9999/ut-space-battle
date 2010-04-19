class KarmaDog extends FlyingDog placeable;

simulated function PostNetBeginPlay()
{
  Super.PostNetBeginPlay();

  // If this is not 'authority' version - don't destroy it if there is a problem.
  // The network should sort things out.
  if(Role != ROLE_Authority)
    KarmaParams(KParams).bDestroyOnSimError = False;
}

defaultproperties
{
  Physics=PHYS_Karma
  Begin Object Class=KarmaParamsRBFull Name=KParams0
    KActorGravScale=0
    KInertiaTensor(0)=20
    KInertiaTensor(1)=0
    KInertiaTensor(2)=0
    KInertiaTensor(3)=30
    KInertiaTensor(4)=0
    KInertiaTensor(5)=48
    KCOMOffset=(X=0.8,Y=0.0,Z=-0.7)
    KStartEnabled=True
    KFriction=1.6
    KLinearDamping=1
    KAngularDamping=10
    bKNonSphericalInertia=False
    bHighDetailOnly=False
    bClientOnly=False
    bKDoubleTickRate=True
    Name="KParams0"
  End Object
  KParams=KarmaParams'KParams0'
}
