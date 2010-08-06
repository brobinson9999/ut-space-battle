class PrototypeShipFactory extends ShipFactory;

var Ship prototype;

simulated function Ship createShip() {
  return getPrototype().cloneShip();
}
  
simulated function Ship getPrototype() {
  return prototype;
}

simulated function setPrototype(Ship newPrototype) {
  prototype = newPrototype;
}

simulated function cleanup()
{
  if (prototype != none) {
    prototype.cleanup();
    setPrototype(none);
  }

  super.cleanup();
}
  
defaultproperties
{
}