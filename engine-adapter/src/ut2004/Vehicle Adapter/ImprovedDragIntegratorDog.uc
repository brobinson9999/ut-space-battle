class ImprovedDragIntegratorDog extends IntegratorDog abstract;

var rangevector rotationalDrag3D;
var rangevector linearDrag3D;

simulated function vector multiplyRangeVector(vector base, rangevector multiplier) {
  local vector result;
  
  result.x = multiplyRange(base.x, multiplier.x);
  result.y = multiplyRange(base.y, multiplier.y);
  result.z = multiplyRange(base.z, multiplier.z);
  
  return result;
}

simulated function float multiplyRange(float base, range multiplier) {
  if (base > 0)
    return base * multiplier.max;
  else
    return base * multiplier.min;
}

simulated function vector applyRangeToVector(vector base, float multiplierScalar, rangevector multiplierRange, rotator relativeRotation) {
  local vector fwdBase;

  if (relativeRotation == rot(0,0,0))
    fwdBase = base;
  else
    fwdBase = base << relativeRotation;
    
  fwdBase = addVectorsWithoutCrossingZero(fwdBase, -multiplyRangeVector(fwdBase * multiplierScalar, linearDrag3D));
  
  if (relativeRotation == rot(0,0,0))
    return fwdBase;
  else
    return fwdBase >> relativeRotation;

}

simulated function applyDrag(PhysicsStateInterface physState, float delta) {
//  local vector fwdVelocity;
  
  if (rotationalDrag > 0) {
    physState.setRotationVelocity(applyRangeToVector(physState.getRotationVelocity(), rotationalDrag * delta, rotationalDrag3D, rot(0,0,0)));
  }
  
  if (linearDrag > 0) {
    physState.setVelocity(applyRangeToVector(physState.getVelocity(), linearDrag * delta, linearDrag3D, rotation));
  }
}

defaultproperties
{
  linearDrag3D=(X=(Min=1,Max=1),Y=(Min=1,Max=1),Z=(Min=1,Max=1))
  rotationalDrag3D=(X=(Min=1,Max=1),Y=(Min=1,Max=1),Z=(Min=1,Max=1))
}
