class SelfRepairPartShipSystem extends ShipSystem;

var float lastUpdatedTime;
var float repairRate;

simulated function addedToShip(Ship other) {
  super.addedToShip(other);
  lastUpdatedTime = getCurrentTime();
}
  
simulated function updateShipSystem() {
  local float delta;
  
  if (bEnabled) {
    delta = getCurrentTime() - lastUpdatedTime;
    repair(repairRate * delta);
  }

  lastUpdatedTime = getCurrentTime();
}

simulated function repair(float repairAmount) {
  local int i;

  if (PartShip(ship).numPartsOnline == PartShip(ship).parts.Length)
    return;

  repairAmount /= PartShip(ship).armor * (PartShip(ship).parts.length - PartShip(ship).numPartsOnline);

  for (i=0;i<PartShip(ship).parts.length;i++)
    if (!PartShip(ship).parts[i].bOnline && ((repairAmount >= 1) || (fRand() <= repairAmount))) {
      PartShip(ship).repairPart(PartShip(ship).parts[i]);
    }
}

simulated function initializeClonedSystem(ShipSystem clone) {
  super.initializeClonedSystem(clone);
  
  SelfRepairPartShipSystem(clone).lastUpdatedTime = lastUpdatedTime;
  SelfRepairPartShipSystem(clone).repairRate = repairRate;
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{

}