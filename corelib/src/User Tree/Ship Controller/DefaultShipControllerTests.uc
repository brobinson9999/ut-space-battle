class DefaultShipControllerTests extends AutomatedTest;

simulated function runTests() {
  local DefaultShipController shipController;
  local Ship ship;
  local PhysicsStateInterface physicsState;
  
  shipController = DefaultShipController(allocateObject(class'DefaultShipController'));
  ship = Ship(allocateObject(class'Ship'));
  physicsState = ship.getPhysicsState();
  
  ship.acceleration = 100;
  
  shipController.desiredAcceleration = vect(50,0,0);
  myAssert(shipController.getDesiredAcceleration(physicsState, 1) == vect(50,0,0), "specified desired acceleration");
  shipController.desiredAcceleration = vect(100,0,0);
  myAssert(shipController.getDesiredAcceleration(physicsState, 1) == vect(100,0,0), "specified desired acceleration");
  shipController.desiredAcceleration = vect(100,0,0);
  myAssert(shipController.getDesiredAcceleration(physicsState, 0.5) == vect(100,0,0), "specified desired acceleration with 0.5 delta");

  myAssert(shipController.getDesiredChangeRate(0.5, vect(0,0,0)) == vect(0,0,0), "getDesiredChangeRate - no change");
  myAssert(shipController.getDesiredChangeRate(0.5, vect(100,0,0)) == vect(200,0,0), "getDesiredChangeRate - full acceleration");
  myAssert(shipController.getDesiredChangeRate(1, vect(100,0,0)) == vect(100,0,0), "getDesiredChangeRate - full acceleration");
  myAssert(shipController.getDesiredChangeRate(1, vect(0,100,0)) == vect(0,100,0), "getDesiredChangeRate - full acceleration");
  myAssert(shipController.getDesiredChangeRate(2, vect(100,0,0)) == vect(50,0,0), "getDesiredChangeRate - excess time");

  shipController.bUseDesiredVelocity = true;
  shipController.desiredVelocity = vect(0,0,0);
  ship.velocity = vect(0,0,0);

  myAssert(shipController.getDesiredAcceleration(physicsState, 0.5) == vect(0,0,0), "desired velocity - no change");

  shipController.desiredVelocity = vect(100,0,0);
  myAssert(shipController.getDesiredAcceleration(physicsState, 0.5) == vect(200,0,0), "desired velocity - full acceleration");
  shipController.desiredVelocity = vect(100,0,0);
  myAssert(shipController.getDesiredAcceleration(physicsState, 1) == vect(100,0,0), "desired velocity - full acceleration");
  shipController.desiredVelocity = vect(0,100,0);
  myAssert(shipController.getDesiredAcceleration(physicsState, 1) == vect(0,100,0), "desired velocity - full acceleration");
  shipController.desiredVelocity = vect(100,0,0);
  myAssert(shipController.getDesiredAcceleration(physicsState, 2) == vect(50,0,0), "desired velocity - excess time");

  ship.rotationRate = 100;
  ship.rotation = rot(0,0,0);
  ship.rotationalVelocity = vect(0,0,0);

  shipController.bUseDesiredRotationRate = true;

  shipController.desiredRotationRate = vect(0,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 0.5) == vect(0,0,0), "desired rotation rate - no change");
  shipController.desiredRotationRate = vect(100,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 0.5) == vect(200,0,0), "desired rotation rate - full acceleration");
  shipController.desiredRotationRate = vect(100,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 1) == vect(100,0,0), "desired rotation rate - full acceleration");
  shipController.desiredRotationRate = vect(0,100,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 1) == vect(0,100,0), "desired rotation rate - full acceleration");
  shipController.desiredRotationRate = vect(100,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 2) == vect(50,0,0), "desired rotation rate - excess time");
  shipController.desiredRotationRate = vect(-100,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 1) == vect(-100,0,0), "desired rotation rate - reverse acceleration");

  ship.rotationalVelocity = vect(65500,0,0);
  shipController.desiredRotationRate = vect(100,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 1) == vect(136,0,0), "desired rotation rate - wraparound");

  ship.rotationalVelocity = vect(100,0,0);
  shipController.desiredRotationRate = vect(65500,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 1) == vect(-136,0,0), "desired rotation rate - reverse wraparound");

  myAssert(shipController.getDesiredChangeRateWithAcceleration(1, vect(50,0,0), 100) == vect(100,0,0), "getDesiredChangeRateWithAcceleration");
  myAssert(shipController.getDesiredChangeRateWithAcceleration(1, vect(50,0,0), 400) == vect(200,0,0), "getDesiredChangeRateWithAcceleration");

  shipController.bUseDesiredRotation = true;
  ship.rotationalVelocity = vect(0,0,0);
  shipController.desiredRotation = rot(50,0,0);
  shipController.useRotationRateFactor = 1;
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 1) == vect(0,100,0), "desired rotation");

// change rate with acceleration
// max change rate should be the rate that we can decelerate from within the allotted time
// in the case of velocity, there is only a limited distance in which to decelerate
// combined with velocity, this determines the maximum velocity we should accelerate to
// desired rate = sqrt(2 * change size * acceleration)

/*

  shipController.desiredRotation = rot(0,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 0.5) == rot(0,0,0), "desired rotation - no change");
  shipController.desiredRotation = rot(100,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 0.5) == rot(100,0,0), "desired rotation - full acceleration");
  shipController.desiredRotation = rot(100,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 1) == rot(100,0,0), "desired rotation - full acceleration");
  shipController.desiredRotation = rot(0,100,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 1) == rot(0,100,0), "desired rotation - full acceleration");
  shipController.desiredRotation = rot(100,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 2) == rot(50,0,0), "desired rotation - excess time");
  shipController.desiredRotation = rot(-100,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 1) == rot(-100,00,0), "desired rotation - reverse acceleration");

  ship.rotation = rot(65500,0,0);
  shipController.desiredRotation = rot(100,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 1) == rot(100,00,0), "desired rotation - wraparound");

  ship.rotation = rot(100,0,0);
  shipController.desiredRotation = rot(65500,0,0);
  myAssert(shipController.getDesiredRotationalAcceleration(physicsState, ship.rotationRate, 1) == rot(-100,00,0), "desired rotation - reverse wraparound");
  */
}