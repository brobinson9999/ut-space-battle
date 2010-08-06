class LiftFighter extends ImperialThunderboltFighter;

var float liftFactor;

simulated function applyDrag(PhysicsStateInterface physState, float delta) {
  local vector fwdVel;
  
  if (liftFactor > 0) {
    fwdVel = physState.getVelocity() << physState.getRotation();
    fwdVel += liftFactor * delta * vsize(fwdVel) * vect(-1,1,0);
    physState.setVelocity(fwdVel >> physState.getRotation());
  }

//  physState.setVelocity(fwdVel >> physState.getRotation());
}

defaultproperties
{
  liftFactor=0.5
  controlMapperClass=class'ConventionalAircraftControlMapper'
}
