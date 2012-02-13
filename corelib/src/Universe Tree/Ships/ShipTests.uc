class ShipTests extends AutomatedTest;

simulated function runTests() {
  local Ship ship;

  ship = Ship(allocateObject(class'Ship'));

  assertEqualVectors(ship.getShipLocation(), vect(0,0,0));
  ship.setShipLocation(vect(100,100,100));
  assertEqualVectors(ship.getShipLocation(), vect(100,100,100));
}