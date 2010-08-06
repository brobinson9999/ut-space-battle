class ShipFactoryMapActor extends BaseMapActor;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var() string userUniqueID;
  var() string shipTypeID;
  
  var() name createdEvent;
  var() name destroyedEvent;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function trigger(Actor other, Pawn eventInstigator) {
  local BaseUser user;
  local ShipProxyActor shipActorReference;
  local Ship shipResult;
  
  user = BaseUser(getUser());
  if (user == none) {
    errorMessage(self$" triggered but user with ID "$userUniqueID$" could not be found.");
    return;
  }
  
  // spawn the ship.
  shipActorReference = none;
  shipResult = SpaceGameSimulation(getGameSimulation()).createShip_OpenSpace(user, SpaceGameSimulation(getGameSimulation()).getGlobalSector(), location / getGlobalPositionScaleFactor(), user.blueprintFromID(shipTypeID));
  shipActorReference = spawn(class'ShipProxyActor');
  shipActorReference.setShip(shipResult);
  shipActorReference.destroyedEvent = destroyedEvent;

  triggerEvent(createdEvent, shipActorReference, eventInstigator);
}

simulated function User getUser() {
  local SpawnUserMapActor suma;
  
  foreach DynamicActors(class'SpawnUserMapActor', suma) {
    if (suma.userUniqueID == userUniqueID) {
      return suma.getUser();
    }
  }
  
  return none;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}
