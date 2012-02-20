class DefaultPhysicsIntegratorTests extends AutomatedTest;

simulated function runTests() {
  local DefaultPhysicsIntegrator physicsIntegrator;
  local StoredPhysicsState physicsState;
  
  physicsState = StoredPhysicsState(allocateObject(class'StoredPhysicsState'));
  physicsIntegrator = DefaultPhysicsIntegrator(allocateObject(class'DefaultPhysicsIntegrator'));

  physicsIntegrator.linearPhysicsUpdate(physicsState, 1, vect(0,0,0));
  myAssert(physicsState.getLocation() == vect(0,0,0), "no change in location with zero acceleration");
  myAssert(physicsState.getVelocity() == vect(0,0,0), "no change in velocity with zero acceleration");

  physicsIntegrator.linearPhysicsUpdate(physicsState, 1, vect(1,0,0));
  myAssert(physicsState.getVelocity() == vect(1,0,0), "velocity test 1");
  physicsIntegrator.linearPhysicsUpdate(physicsState, 2, vect(0,1,0));
  myAssert(physicsState.getVelocity() == vect(1,2,0), "velocity test 1");
  physicsIntegrator.linearPhysicsUpdate(physicsState, 1, vect(-1,0,0));
  myAssert(physicsState.getVelocity() == vect(0,2,0), "velocity test 1");

  physicsState.setVelocity(vect(0,0,0));
  physicsState.setLocation(vect(0,0,0));
  physicsIntegrator.linearPhysicsUpdate(physicsState, 1, vect(2,0,0));
  myAssert(physicsState.getLocation() == vect(1,0,0), "movement test 1");
  physicsIntegrator.linearPhysicsUpdate(physicsState, 1, vect(-2,0,0));
  myAssert(physicsState.getLocation() == vect(2,0,0), "movement test 2");
  physicsIntegrator.linearPhysicsUpdate(physicsState, 2, vect(0,1,0));
  myAssert(physicsState.getLocation() == vect(2,2,0), "movement test 3");
  physicsIntegrator.linearPhysicsUpdate(physicsState, 2, vect(0,1,0));
  myAssert(physicsState.getLocation() == vect(2,8,0), "movement test 4");

  /*
  myAssert(rot(1,0,0).pitch == 1, "pitch");
  myAssert(rot(0,1,0).yaw == 1, "yaw");
  myAssert(rot(0,0,1).roll == 1, "roll");
  
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(0,0,0), rot(0,0,0), rot(0,0,0)) == rot(0,0,0), "rotational velocity adjustment - no change");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(100,100,100), rot(0,0,0), rot(0,0,0)) == rot(100,100,100), "rotational velocity adjustment - no change");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(100,0,0), rot(0,0,0), rot(0,32768,0)) == rot(100,0,0), "rotational velocity adjustment - yaw change 1/2");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(0,0,100), rot(0,0,0), rot(0,32768,0)) == rot(0,0,100), "rotational velocity adjustment - yaw change 1/2");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(100,0,0), rot(0,0,0), rot(0,16384,0)) == rot(100,0,0), "rotational velocity adjustment - yaw change 1/4");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(0,0,100), rot(0,0,0), rot(0,16384,0)) == rot(0,0,100), "rotational velocity adjustment - yaw change 1/4");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(0,100,0), rot(0,0,0), rot(32768,0,0)) == rot(0,-100,0), "rotational velocity adjustment - pitch change 1/2");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(0,0,100), rot(0,0,0), rot(32768,0,0)) == rot(0,0,-100), "rotational velocity adjustment - pitch change 1/2");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(0,100,0), rot(0,0,0), rot(16384,0,0)) == rot(0,0,100), "rotational velocity adjustment - pitch change 1/4");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(0,0,100), rot(0,0,0), rot(16384,0,0)) == rot(0,-100,0), "rotational velocity adjustment - pitch change 1/4");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(100,0,0), rot(0,0,0), rot(0,0,32768)) == rot(-100,0,0), "rotational velocity adjustment - roll change 1/2");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(0,100,0), rot(0,0,0), rot(0,0,32768)) == rot(0,-100,0), "rotational velocity adjustment - roll change 1/2");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(100,0,0), rot(0,0,0), rot(0,0,16384)) == rot(0,-100,0), "rotational velocity adjustment - roll change 1/4");
  myAssert(physicsIntegrator.getNewRotationalVelocity(rot(0,100,0), rot(0,0,0), rot(0,0,16384)) == rot(100,0,0), "rotational velocity adjustment - roll change 1/4");
  */
  
// 1/2 is 32768
// 1/4 is 16384
// 1/8 is 8192
}