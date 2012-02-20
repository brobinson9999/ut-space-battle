class PartShipDamageSubsystem extends ShipDamageSubsystem;

simulated function applyDamage(Ship damaged, float damageAmount, object instigator) {
  local int i;
  local PartShip partShip;
  
  partShip = PartShip(damaged);

  // Abort if the ship is destroyed.
  if (partShip.numPartsOnline == 0)
    return;

  // Reduce damage, first by armor plating, then by number of online parts.
  damageAmount /= partShip.armor;
  damageAmount /= partShip.numPartsOnline;

  // All online parts have this chance to fail.
  for (i=0;i<partShip.parts.length;i++)
    if (partShip.parts[i].bOnline && ((damageAmount >= 1) || (FRand() <= damageAmount))) {
      partShip.damagePart(partShip.parts[i]);
    }

  // Check for total destruction.
  if (partShip.numPartsOnline == 0)
    partShip.shipCritical(instigator);
}

defaultproperties
{
}