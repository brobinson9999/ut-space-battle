class PartShipRenderable extends ShipRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var RenderablePartShipObserver shipObserver;
var array<PartRenderable> partRenderables;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function initializeShipRenderable() {
  local int i;

  super.initializeShipRenderable();
    
  shipObserver = new class'RenderablePartShipObserver';
  shipObserver.initializeShipObserver(ship, self);
  
  setScale(getGlobalDrawscaleFactor());

  for (i=0;i<PartShip(ship).parts.length;i++)
    initializePartRenderable(PartShip(ship).parts[i]);
}

simulated function ShipObserver getShipObserver() {
  return shipObserver;
}

simulated function class<PartRenderable> getPartRenderableClass(Part part) {
//  local string shipTypeName;

//  if (part.ship != none)
//    shipTypeName = part.ship.shipTypeName;
    
  return class'FighterBPartRenderable';
}
  
simulated function initializePartRenderable(Part part) {
  local class<PartRenderable> partRenderableClass;
  local PartRenderable newPartRenderable;
  
  partRenderableClass = getPartRenderableClass(part);
  newPartRenderable = spawn(partRenderableClass,,,locationForPart(part), rotationForPart(part));
  propogateGlobals(newPartRenderable);
  newPartRenderable.setPart(part);
  positionPart(newPartRenderable, part);
  newPartRenderable.initializePartRenderable();

  partRenderables[partRenderables.length] = newPartRenderable;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function clearRenderData() {
  local int i;
  
  for (i=0;i<partRenderables.length;i++)
    partRenderables[i].clearPartRenderData();
    
  super.clearRenderData();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PartRenderable getPartRenderableForPart(Part part)
{
  local int i;
  
  for (i=0;i<partRenderables.length;i++)
    if (partRenderables[i].part == part)
      return partRenderables[i];
  
  return none;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function tick(float Delta) {
  super.tick(delta);
  
  positionParts();
}

simulated function positionParts() {
  local int i;
  
  for (i=0;i<partRenderables.length;i++)
    positionPart(partRenderables[i], partRenderables[i].part);
}

simulated function positionPart(PartRenderable partRenderable, Part part) {
  partRenderable.setRenderLocation(locationForPart(part));
  partRenderable.setRenderRotation(rotationForPart(part));
}

simulated function vector locationForPart(Part part) {
  return location + ((part.relativeLocation CoordRot rotation) * drawScale);
}

simulated function rotator rotationForPart(Part part) {
  return part.getPartRotation();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanup() {
  if (shipObserver != none) {
    shipObserver.cleanup();
    shipObserver = none;
  }
  
  while (partRenderables.length > 0) {
    if (partRenderables[partRenderables.length-1] != none)
      partRenderables[partRenderables.length-1].cleanup();
    partRenderables.remove(partRenderables.length-1,1);
  }
  
  super.cleanup();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ** Events.

simulated function notifyPartDamaged(Part part) {
  local PartRenderable partRenderable;
  
  partRenderable = getPartRenderableForPart(part);
  if (partRenderable != none)
    partRenderable.notifyPartDamaged();
}

simulated function notifyPartRepaired(Part part) {
  local PartRenderable partRenderable;
  
  partRenderable = getPartRenderableForPart(part);
  if (partRenderable != none)
    partRenderable.notifyPartRepaired();
}

simulated function notifyPartFiredWeapon(Part part, WeaponProjectile projectile) {
  local PartRenderable partRenderable;
  
  partRenderable = getPartRenderableForPart(part);
  if (partRenderable != none)
    partRenderable.notifyPartFiredWeapon(projectile);
}

simulated function notifyShipCritical() {
  local int i;
  
  for (i=0;i<partRenderables.length;i++)
    partRenderables[i].notifyShipCritical();
}

simulated function notifyShipDestroyed() {
  local int i;
  
  for (i=0;i<partRenderables.length;i++)
    partRenderables[i].notifyShipDestroyed();

  clearRenderData();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}