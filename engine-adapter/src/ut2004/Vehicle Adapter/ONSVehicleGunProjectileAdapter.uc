class ONSVehicleGunProjectileAdapter extends ONSPlasmaProjectile;

var vector lastLocation;
var float lastDelta;
var vector lastCenterMassLocation;
var vector currentCenterMassLocation;

simulated function postBeginPlay() {
  super.postBeginPlay();
  
  // setup initial velocity
  lastLocation = location - (vector(rotation) * speed);
  lastCenterMassLocation = lastLocation;
  currentCenterMassLocation = location;
  lastDelta = 1;
}

simulated function tick(float delta) {
  if (delta > 0) {
    updateConstraints(delta);
    updateIntegrator(delta);
    lastDelta = delta;
  }

  super.tick(delta);
}

simulated function explode(vector hitLocation, vector hitNormal) {}

simulated function updateConstraints(float delta) {
  // center mass can't leave the radius
  if (vsize(currentCenterMassLocation - location) > collisionRadius)
    currentCenterMassLocation = location + (normal(currentCenterMassLocation - location) * collisionRadius);
}

simulated function updateIntegrator(float delta) {
  local vector newLocation;
//  local vector newCenterMassLocation;

//  newCenterMassLocation = integrateVector(lastCenterMassLocation, currentCenterMassLocation, lastDelta, delta);
//  newLocation = (0.9 * newCenterMassLocation) + (0.1 * (integrateVector(lastLocation, location, lastDelta, delta)));
  newLocation = integrateVector(lastLocation, location, lastDelta, delta);
  
  lastLocation = location;
//  lastCenterMassLocation = currentCenterMassLocation;
  
//  setLocation(newLocation);
  velocity = vectorRateOfChange(location, newLocation, delta);
  setRotation(rotator(velocity));
//  currentCenterMassLocation = newLocation;
}

simulated function vector vectorRateOfChange(vector oldValue, vector newValue, float delta) {
  if (delta == 0)
    return vect(0,0,0);
    
  return (newValue - oldValue) / delta;
}

simulated function vector integrateVector(vector oldValue, vector currentValue, float oldDelta, float currentDelta) {
  return (currentValue + (vectorRateOfChange(oldValue, currentValue, oldDelta) * currentDelta));
}

defaultproperties
{
    ExplosionDecal=class'LinkBoltScorch'
    Lifespan=1.6
    MomentumTransfer=4000
    
    Physics=PHYS_Projectile
    
    DrawType=DT_Projectile
    Style=STY_Additive
    AmbientGlow=100
    
    MyDamageType=class'DamTypeAttackCraftPlasma'
    PlasmaEffectClass=class'Onslaught.ONSRedPlasmaFireEffect'
    HitEffectClass=class'Onslaught.ONSPlasmaHitRed'
    Damage=25
    DamageRadius=200.0
    Speed=25000
    MaxSpeed=25000
}
