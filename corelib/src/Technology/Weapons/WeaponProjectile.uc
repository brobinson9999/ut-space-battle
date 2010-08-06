class WeaponProjectile extends BaseObject;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

const falloffFactor = 1.5;
const damageCoefficientMinThreshold = 0.05;

var     float       startTime, endTime;
var     vector      startLocation, endLocation;
var     Sector      sector;

var     Ship        target;
var     float       damage;
var     float       radius;

var     bool        bRendering;

var     array<ProjectileObserver> observers;

var     User        owner;
var     object      instigator;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function addProjectileObserver(ProjectileObserver newObserver) {
  observers[observers.length] = newObserver;
}

simulated function removeProjectileObserver(ProjectileObserver oldObserver) {
  local int i;

  for (i=0;i<observers.length;i++) {
    if (observers[i] == oldObserver) {
      observers.remove(i, 1);
      break;
    }
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function vector getProjectileLocation() {
  local vector worldLocation;
  local vector deltaLocation;
  local float  travelFraction;

  if (endTime == startTime)
    return endLocation;

  deltaLocation = (endLocation - startLocation);
  travelFraction = FMin((getCurrentTime() - startTime) / (endTime - startTime), 1);
  worldLocation = startLocation + (deltaLocation * travelFraction);

  return worldLocation;
}

simulated function vector getVelocity() {
  if (endTime == startTime)
    return Vect(0,0,0);

  return ((endLocation - startLocation) / (endTime - startTime));
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function impact()
{
  local float HitDistance;
  local float DamageCoefficient;

  // Check if Target still exists and is in the same sector.
  if (Target != None && Target.Sector != None && Target.Sector == Sector)
  {
    // Advance the Target to the current time.
    myAssert(target.getGameSimulation() != none, "Projectile impact but target.getGameSimulation() == none");
    target.updateShip();

    // Determine Damage.
    HitDistance = VSize(EndLocation - Target.getShipLocation());
    HitDistance = FMax(HitDistance - Radius, 0);

    if (HitDistance < Target.Radius)
    {
      notifyProjectileImpacted();

      damageCoefficient = (Target.Radius - HitDistance) / Target.Radius;

      damage *= damageCoefficient;
//      target.instigator = Instigator;
      target.applyDamage(damage, instigator);
//      target.instigator = None;
    } else {
      notifyProjectileMissed();
    }
  } else {
    notifyProjectileMissed();
  }

  // Destroy Projectile.
  destroy();
}

simulated function destroy() {
  freeAndCleanupObject(self);
}

simulated function cleanup()
{
  while (observers.length > 0) {
    errorMessage("cleaning up projectile with remaining observer: "$observers[0]);
    removeProjectileObserver(observers[0]);
  }

  if (sector != none)
    sector.projectileLeftSector(self);

  target = none;
  owner = none;
  instigator = none;
  sector = none;

  super.cleanup();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function notifyProjectileMissed() {
  local int i;

  for (i=observers.length-1;i>=0;i--)
    observers[i].notifyProjectileMissed();
}

simulated function notifyProjectileImpacted() {
  local int i;

  for (i=observers.length-1;i>=0;i--)
    observers[i].notifyProjectileImpacted();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}