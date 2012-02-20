class PawnAdapter extends xPawn;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function AddVelocity( vector NewVelocity) {}
simulated function DoDamageFX( Name boneName, int Damage, class<DamageType> DamageType, Rotator r ) {}
simulated function FinishedInterpolation() {}
simulated function JumpOffPawn() {}
simulated function BaseChange() {}
simulated function bool DoJump( bool bUpdating ) { return false; }
simulated function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType) {}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function tick(float delta)
{
  super.tick(delta);

  if (physics != PHYS_None)
    setPhysics(PHYS_None);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function playerKilled(Controller Killer) {
  died(Killer, class'DamageType', Vect(0,0,0));
}

// prevents KInitSkeletonKarma: Framework, but no world... from appearing in the log
function playDyingAnimation(class<DamageType> damageType, vector hitLoc) {}

//simulated function rawInput(float deltaTime, float aBaseX, float aBaseY, float aBaseZ, float aMouseX, float aMouseY, float aForward, float aTurn, float aStrafe, float aUp, float aLookUp) {
//  log("pawn: aBaseX: "$aBaseX$" aBaseY: "$aBaseY$" aBaseZ: "$aBaseZ$" aMouseX: "$aMouseX$" aMouseY: "$aMouseY$" aForward: "$aForward$" aTurn: "$aTurn$" aStrafe: "$aStrafe$" aUp: "$aUp$" aLookUp: "$aLookUp);
//}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************


defaultproperties
{
  bHidden=true
  Physics=PHYS_None
  
  bCollideActors = false
  bCollideWorld = false
  bBlockActors = false
  bProjTarget = false

  EyeHeight=0
  BaseEyeHeight=0
}

defaultproperties
{
  bBlockPlayers = false
  bBlockProjectiles = false
  bBlockZeroExtentTraces = false
  bBlockNonZeroExtentTraces = false
}
