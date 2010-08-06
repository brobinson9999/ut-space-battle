class PartShip extends DefaultShip;

var int                         numPartsOnline;
var array<Part>                 parts;
var private ShipDamageSubsystem damageSubsystem;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function addPart(Part newPart) {
  newPart.ship = self;
  parts[parts.length] = newPart;
  if (newPart.bOnline)
    numPartsOnline++;

  if (ShipWeapon(newPart) != none)
    weapons[weapons.length] = ShipWeapon(newPart);

  if (ShipHangar(newPart) != None)
    addLaunchBay(ShipHangar(newPart).getLaunchBay());
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function applyDamage(float damage, object instigator) {
  myAssert(!bCleanedUp, "PartShip.applyDamage when bCleanedUp");
  getDamageSubsystem().applyDamage(self, damage, instigator);
}

simulated protected function ShipDamageSubsystem getDamageSubsystem() {
  if (damageSubsystem == none) {
    damageSubsystem = ShipDamageSubsystem(allocateObject(class'PartShipDamageSubsystem'));
  }

  return damageSubsystem;
}

simulated function damagePart(Part other) {
  numPartsOnline--;
  other.damaged();
  notifyPartDamaged(other);
} 

simulated function repairPart(Part other) {
  numPartsOnline++;
  other.repaired();
  notifyPartRepaired(other);
}

simulated function shipCritical(object instigator)
{
  local int i;

  for (i=0;i<parts.length;i++)
    if (parts[i].bOnline) {
      damagePart(parts[i]);
    }

  for (i=shipObservers.length-1;i>=0;i--)
    shipObservers[i].notifyShipCritical();

  super.shipCritical(instigator);
}

simulated function destroyTimeElapsed()
{
  local int i;

  for (i=shipObservers.length-1;i>=0;i--)
    shipObservers[i].notifyShipDestroyed();

  super.destroyTimeElapsed();
}

simulated function notifyPartRepaired(Part part) {
  local int i;

  for (i=shipObservers.length-1;i>=0;i--)
    if (PartShipObserver(shipObservers[i]) != none)
      PartShipObserver(shipObservers[i]).notifyPartRepaired(part);
}

simulated function notifyPartDamaged(Part part) {
  local int i;

  for (i=shipObservers.length-1;i>=0;i--)
    if (PartShipObserver(shipObservers[i]) != none)
      PartShipObserver(shipObservers[i]).notifyPartDamaged(part);
}

simulated function notifyPartFiredWeapon(Part part, WeaponProjectile projectile) {
  local int i;

  for (i=shipObservers.length-1;i>=0;i--)
    if (PartShipObserver(shipObservers[i]) != none)
      PartShipObserver(shipObservers[i]).notifyPartFiredWeapon(part, projectile);
}

// ********************************************************************************************************************************************
// *******************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float Detection_Strength_Against(Contact Other)
{
  local int i;
  local float Total;

  for (i=0;i<Parts.Length;i++)
    if (ShipSensor(Parts[i]) != None)
      Total += ShipSensor(Parts[i]).Detection_Strength_Against(Other);

  return Total;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanup()
{
  while (parts.length > 0) {
    parts[0].cleanup();
    parts.remove(0,1);
  }

  if (damageSubsystem != none) {
    damageSubsystem.cleanup();
    damageSubsystem = none;
  }

  super.cleanup();
}

simulated function initializeClonedShip(Ship clone)
{
  local int i;
  local Part newPart;

  super.initializeClonedShip(clone);

  for (i=0;i<parts.length;i++) {
    newPart = parts[i].clonePart();
    PartShip(clone).addPart(newPart);
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}