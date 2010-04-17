class CameraShipFactory extends PrototypeShipFactory;

simulated function Ship getPrototype() {
  if (prototype == none) {
    setPrototype(createPrototype());
  }
  
  return super.getPrototype();
}

simulated protected function Ship createPrototype() {
  local Ship newPrototype;
  
  newPrototype = Ship(allocateObject(class'DefaultShip'));

  newPrototype.acceleration          = 30000;
  newPrototype.rotationRate          = 100000;

  newPrototype.radius = 1;
  
  return newPrototype;
}
  
defaultproperties
{
}