class DefaultShipControllerTests extends AutomatedTest;

simulated function runTests() {
  local DefaultShipController shipControlStrategy;
  local Ship ship;
  local PhysicsStateInterface physicsState;
  
  shipControlStrategy = DefaultShipController(allocateObject(class'DefaultShipController'));
  ship = Ship(allocateObject(class'Ship'));
  physicsState = ship.getPhysicsState();
  
  ship.setShipMaximumLinearAcceleration(100);
  
  shipControlStrategy.desiredAcceleration = vect(50,0,0);
  myAssert(shipControlStrategy.getShipThrust(1, physicsState, ship.getShipMaximumLinearAcceleration()) == vect(50,0,0), "specified desired acceleration");
  shipControlStrategy.desiredAcceleration = vect(100,0,0);
  myAssert(shipControlStrategy.getShipThrust(1, physicsState, ship.getShipMaximumLinearAcceleration()) == vect(100,0,0), "specified desired acceleration");
  shipControlStrategy.desiredAcceleration = vect(100,0,0);
  myAssert(shipControlStrategy.getShipThrust(0.5, physicsState, ship.getShipMaximumLinearAcceleration()) == vect(100,0,0), "specified desired acceleration with 0.5 delta");

  myAssert(shipControlStrategy.getDesiredChangeRate(0.5, vect(0,0,0)) == vect(0,0,0), "getDesiredChangeRate - no change");
  myAssert(shipControlStrategy.getDesiredChangeRate(0.5, vect(100,0,0)) == vect(200,0,0), "getDesiredChangeRate - full acceleration");
  myAssert(shipControlStrategy.getDesiredChangeRate(1, vect(100,0,0)) == vect(100,0,0), "getDesiredChangeRate - full acceleration");
  myAssert(shipControlStrategy.getDesiredChangeRate(1, vect(0,100,0)) == vect(0,100,0), "getDesiredChangeRate - full acceleration");
  myAssert(shipControlStrategy.getDesiredChangeRate(2, vect(100,0,0)) == vect(50,0,0), "getDesiredChangeRate - excess time");

  shipControlStrategy.bUseDesiredVelocity = true;
  shipControlStrategy.desiredVelocity = vect(0,0,0);
  ship.setShipVelocity(vect(0,0,0));

  myAssert(shipControlStrategy.getShipThrust(0.5, physicsState, ship.getShipMaximumLinearAcceleration()) == vect(0,0,0), "desired velocity - no change");

  shipControlStrategy.desiredVelocity = vect(100,0,0);
  myAssert(shipControlStrategy.getShipThrust(0.5, physicsState, ship.getShipMaximumLinearAcceleration()) == vect(200,0,0), "desired velocity - full acceleration");
  shipControlStrategy.desiredVelocity = vect(100,0,0);
  myAssert(shipControlStrategy.getShipThrust(1, physicsState, ship.getShipMaximumLinearAcceleration()) == vect(100,0,0), "desired velocity - full acceleration");
  shipControlStrategy.desiredVelocity = vect(0,100,0);
  myAssert(shipControlStrategy.getShipThrust(1, physicsState, ship.getShipMaximumLinearAcceleration()) == vect(0,100,0), "desired velocity - full acceleration");
  shipControlStrategy.desiredVelocity = vect(100,0,0);
  myAssert(shipControlStrategy.getShipThrust(2, physicsState, ship.getShipMaximumLinearAcceleration()) == vect(50,0,0), "desired velocity - excess time");

  ship.setShipMaximumRotationalAcceleration(100);
  ship.setShipRotation(rot(0,0,0));
  ship.setShipRotationalVelocity(vect(0,0,0));

  shipControlStrategy.bUseDesiredRotationRate = true;

  shipControlStrategy.desiredRotationRate = vect(0,0,0);
  myAssert(shipControlStrategy.getShipSteering(0.5, physicsState, ship.getShipMaximumRotationalAcceleration()) == vect(0,0,0), "desired rotation rate - no change");
  shipControlStrategy.desiredRotationRate = vect(100,0,0);
  myAssert(shipControlStrategy.getShipSteering(0.5, physicsState, ship.getShipMaximumRotationalAcceleration()) == vect(200,0,0), "desired rotation rate - full acceleration");
  shipControlStrategy.desiredRotationRate = vect(100,0,0);
  myAssert(shipControlStrategy.getShipSteering(1, physicsState, ship.getShipMaximumRotationalAcceleration()) == vect(100,0,0), "desired rotation rate - full acceleration");
  shipControlStrategy.desiredRotationRate = vect(0,100,0);
  myAssert(shipControlStrategy.getShipSteering(1, physicsState, ship.getShipMaximumRotationalAcceleration()) == vect(0,100,0), "desired rotation rate - full acceleration");
  shipControlStrategy.desiredRotationRate = vect(100,0,0);
  myAssert(shipControlStrategy.getShipSteering(2, physicsState, ship.getShipMaximumRotationalAcceleration()) == vect(50,0,0), "desired rotation rate - excess time");
  shipControlStrategy.desiredRotationRate = vect(-100,0,0);
  myAssert(shipControlStrategy.getShipSteering(1, physicsState, ship.getShipMaximumRotationalAcceleration()) == vect(-100,0,0), "desired rotation rate - reverse acceleration");

  ship.setShipRotationalVelocity(vect(65500,0,0));
  shipControlStrategy.desiredRotationRate = vect(100,0,0);
  myAssert(shipControlStrategy.getShipSteering(1, physicsState, ship.getShipMaximumRotationalAcceleration()) == vect(136,0,0), "desired rotation rate - wraparound");

  ship.setShipRotationalVelocity(vect(100,0,0));
  shipControlStrategy.desiredRotationRate = vect(65500,0,0);
  myAssert(shipControlStrategy.getShipSteering(1, physicsState, ship.getShipMaximumRotationalAcceleration()) == vect(-136,0,0), "desired rotation rate - reverse wraparound");

  myAssert(shipControlStrategy.getDesiredChangeRateWithAcceleration(1, vect(50,0,0), 100) == vect(100,0,0), "getDesiredChangeRateWithAcceleration");
  myAssert(shipControlStrategy.getDesiredChangeRateWithAcceleration(1, vect(50,0,0), 400) == vect(200,0,0), "getDesiredChangeRateWithAcceleration");

  shipControlStrategy.bUseDesiredRotation = true;
  ship.setShipRotationalVelocity(vect(0,0,0));
  shipControlStrategy.desiredRotation = rot(50,0,0);
  shipControlStrategy.useRotationRateFactor = 1;
  myAssert(shipControlStrategy.getShipSteering(1, physicsState, ship.getShipMaximumRotationalAcceleration()) == vect(0,100,0), "desired rotation");

// change rate with acceleration
// max change rate should be the rate that we can decelerate from within the allotted time
// in the case of velocity, there is only a limited distance in which to decelerate
// combined with velocity, this determines the maximum velocity we should accelerate to
// desired rate = sqrt(2 * change size * acceleration)

/*

  shipControlStrategy.desiredRotation = rot(0,0,0);
  myAssert(shipControlStrategy.getShipSteering(physicsState, ship.getShipMaximumRotationalAcceleration(), 0.5) == rot(0,0,0), "desired rotation - no change");
  shipControlStrategy.desiredRotation = rot(100,0,0);
  myAssert(shipControlStrategy.getShipSteering(physicsState, ship.getShipMaximumRotationalAcceleration(), 0.5) == rot(100,0,0), "desired rotation - full acceleration");
  shipControlStrategy.desiredRotation = rot(100,0,0);
  myAssert(shipControlStrategy.getShipSteering(physicsState, ship.getShipMaximumRotationalAcceleration(), 1) == rot(100,0,0), "desired rotation - full acceleration");
  shipControlStrategy.desiredRotation = rot(0,100,0);
  myAssert(shipControlStrategy.getShipSteering(physicsState, ship.getShipMaximumRotationalAcceleration(), 1) == rot(0,100,0), "desired rotation - full acceleration");
  shipControlStrategy.desiredRotation = rot(100,0,0);
  myAssert(shipControlStrategy.getShipSteering(physicsState, ship.getShipMaximumRotationalAcceleration(), 2) == rot(50,0,0), "desired rotation - excess time");
  shipControlStrategy.desiredRotation = rot(-100,0,0);
  myAssert(shipControlStrategy.getShipSteering(physicsState, ship.getShipMaximumRotationalAcceleration(), 1) == rot(-100,00,0), "desired rotation - reverse acceleration");

  ship.getShipRotation() = rot(65500,0,0);
  shipControlStrategy.desiredRotation = rot(100,0,0);
  myAssert(shipControlStrategy.getShipSteering(physicsState, ship.getShipMaximumRotationalAcceleration(), 1) == rot(100,00,0), "desired rotation - wraparound");

  ship.getShipRotation() = rot(100,0,0);
  shipControlStrategy.desiredRotation = rot(65500,0,0);
  myAssert(shipControlStrategy.getShipSteering(physicsState, ship.getShipMaximumRotationalAcceleration(), 1) == rot(-100,00,0), "desired rotation - reverse wraparound");
  */
}