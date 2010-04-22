class PawnAdapter extends UTPawn;


simulated function AddVelocity(vector NewVelocity, vector HitLocation, class<DamageType> damageType, optional TraceHitInfo HitInfo) {}
//simulated function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser) {}
exec simulated function FeignDeath() {}

simulated function playerKilled(Controller Killer) {
	died(killer, class'DamageType', vect(0,0,0));
}

simulated function FinishedInterpolation() {}
simulated function JumpOffPawn() {}
simulated function BaseChange() {}
simulated function bool DoJump( bool bUpdating ) { return false; }

simulated function Tick(float Delta)
{
  Super.Tick(Delta);

  if (Physics != PHYS_None) SetPhysics(PHYS_None);
}

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
