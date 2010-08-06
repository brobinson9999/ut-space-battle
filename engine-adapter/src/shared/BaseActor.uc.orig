class BaseActor extends BaseEngineSpecificActor;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var BaseObject game;
var CameraShaker cameraShaker;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function propogateGlobals(BaseActor other) {
  other.setGameSimulation(game);
  other.cameraShaker = cameraShaker;
}

simulated function setGameSimulation(BaseObject newGameSimulation) {
  game = newGameSimulation;
}

simulated function debugMSG(coerce string message) {
  errorMessage(message);
}

simulated function errorMessage(coerce String message)
{
  if (game == none)
    game = getGameSimulation();

  if (game != none)
    game.errorMessage(message);
  else
  {
    Log("Undisplayable debug message from "$self$". As Follows:");
    Log(message);
  }
}

simulated function cameraShake(vector shakeOrigin, float shakeMagnitude) {
  if (cameraShaker != none)
    cameraShaker.cameraShake(shakeOrigin, shakeMagnitude);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function BaseActor spawnBaseActor(class<BaseActor> spawnClass, optional actor spawnOwner, optional name spawnTag, optional vector spawnLocation, optional rotator spawnRotation) {
  local BaseActor result;

  result = spawn(spawnClass, spawnOwner, spawnTag, spawnLocation, spawnRotation);
  if (result != none)
    propogateGlobals(result);

  return result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

final operator(23) vector CoordRot(vector A, rotator B)
{
  if (A == Vect(0,0,0) || B == Rot(0,0,0))
    return A;

  return A >> B;
}

final operator(23) vector UnCoordRot(vector A, rotator B)
{
  if (A == Vect(0,0,0) || B == Rot(0,0,0))
    return A;

  return A << B;
}

final operator(23) rotator CoordRot(rotator A, rotator B)
{
  local vector X, Y, Z;

  if (A == Rot(0,0,0))
    return B;

  if (B == Rot(0,0,0))
    return A;

  GetAxes(A, X, Y, Z);

  X = X CoordRot B;
  Y = Y CoordRot B;
  Z = Z CoordRot B;

  return OrthoRotation(X, Y, Z);
}

final operator(23) rotator UnCoordRot(rotator A, rotator B)
{
  local vector X, Y, Z;

  if (B == Rot(0,0,0))
    return A;

  GetAxes(A, X, Y, Z);

  X = X UnCoordRot B;
  Y = Y UnCoordRot B;
  Z = Z UnCoordRot B;

  return OrthoRotation(X, Y, Z);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function vector ClosestPointOnLine(vector LineStart, vector LineEnd, vector ComparePoint)
{
  local vector Line;
  local float  LineLength;

  local float U;
  local vector Intersection;

  // Setup
  Line = LineEnd - LineStart;
  LineLength = VSize(Line);

  // Find U.
  U = ( ((ComparePoint.X - LineStart.X) * Line.X) +
        ((ComparePoint.Y - LineStart.Y) * Line.Y) +
        ((ComparePoint.Z - LineStart.Z) * Line.Z) )
        / (LineLength ** 2);

  // Check for ends of line segment.
  if (U < 0)
    return LineStart;

  if (U > 1)
    return LineEnd;

  Intersection = LineStart + (U * Line);

  return Intersection;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function BaseObject getGameSimulation() {
  local GameSimulationAnchor anchor;
  
  if (game == none) {
    foreach DynamicActors(class'GameSimulationAnchor', anchor) {
      game = anchor.getGameSimulation();
      break;
    }
  }
  
  return game;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanup() {
  game = none;
  cameraShaker = none;
}

simulated function destroyed() {
  cleanup();

  super.destroyed();
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  bHidden=true
}
