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
}