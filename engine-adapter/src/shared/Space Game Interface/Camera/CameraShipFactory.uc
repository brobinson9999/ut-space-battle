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

  newPrototype.setShipMaximumAcceleration(30000);
  newPrototype.setShipMaximumRotationalAcceleration(100000);

  newPrototype.setShipRadius(1);
  
  return newPrototype;
}
  
defaultproperties
{
}