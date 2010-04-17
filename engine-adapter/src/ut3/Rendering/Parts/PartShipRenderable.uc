class PartShipRenderable extends ShipRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var array<PartRenderable> partRenderables;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function initialize() {
  local int i;

  super.initialize();
  
  setScale(getGlobalDrawscaleFactor());

  for (i=0;i<PartShip(ship).parts.length;i++)
    initializePartRenderable(PartShip(ship).parts[i]);
}

simulated function initializePartRenderable(Part part) {
  local class<PartRenderable> partRenderableClass;
  local PartRenderable newPartRenderable;
  
  partRenderableClass = class<PartRenderable>(part.getRenderableClass());
  newPartRenderable = spawn(partRenderableClass,,,locationForPart(none, part), rotationForPart(none, part));
  propogateGlobals(newPartRenderable);
  newPartRenderable.setPart(part);
  positionPart(newPartRenderable, part);
  newPartRenderable.initialize();

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
  partRenderable.setRenderRotation(rotationForPart(partRenderable, part));
  partRenderable.setRenderLocation(locationForPart(partRenderable, part));
}

simulated function vector locationForPart(PartRenderable partRenderable, Part part) {
  local vector partLocation;
  local vector adjustedLocation;
  
  partLocation = part.getPartLocation();
  if (partRenderable != none)
    adjustedLocation = partLocation + ((partRenderable.locationOffset * partRenderable.drawScale * partRenderable.drawScale3D) CoordRot part.getPartRotation());
  else
    adjustedLocation = partLocation;

  return adjustedLocation;
}

simulated function rotator rotationForPart(PartRenderable partRenderable, Part part) {
  if (partRenderable != none)
    return (partRenderable.rotationOffset CoordRot part.getPartRotation());
  else
    return part.getPartRotation();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanup() {
  clearRenderData();
  
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

simulated function notifyPartFiredWeapon(Part part, Projectile projectile) {
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
    
  cleanup();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}