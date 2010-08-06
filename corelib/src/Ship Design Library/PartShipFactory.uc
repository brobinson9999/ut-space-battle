class PartShipFactory extends PrototypeShipFactory;

simulated function Ship getPrototype() {
  if (prototype == none) {
    setPrototype(createPrototype());
  }
  
  return super.getPrototype();
}

simulated protected function Ship createPrototype() {
  return Ship(allocateObject(class'PartShip'));
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
 
simulated function recalcPrototypePhysics() {
  local int i;
  local float volume;
  local PartShip localPrototype;

  localPrototype = PartShip(getPrototype());

  // Sum of part radiuses = volume.
  // Volume = 4/3*pi*r^3
  // Constant part cancels out
  for (i=0;i<localPrototype.parts.length;i++)
    volume += (localPrototype.parts[i].radius ** 3);

  localPrototype.radius = volume ** (1.0/3.0);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function recalcPrototypePartPhysics(Part prototypePart)
{
  prototypePart.radius = 50 * prototypePart.physicalScale;

  // changes here can affect lost (lost? maybe it meant to say lots?)
  recalcPrototypePhysics();
}

simulated function Part prototypePartFromID(string targetID)
{
  local int i;
  local PartShip localPrototype;

  localPrototype = PartShip(getPrototype());

  for (i=0;i<localPrototype.parts.length;i++)
    if (localPrototype.parts[i].partID ~= targetID)
      return localPrototype.parts[i];

  return None;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}