class ImprovedDragIntegratorDog extends IntegratorDog;

var rangevector rotationalDrag3D;
var rangevector linearDrag3D;

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
