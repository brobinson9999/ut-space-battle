class DFCB_GameSimulation extends UTSpaceBattleGameSimulation;

var float pointsPerKill;

var int reinforcementCount;
var float reinforcementStartingPoints;
var float minReinforcementPoints, maxReinforcementPoints;

var float flagshipStartingPoints;
var float minFlagshipPoints, maxFlagshipPoints;

simulated function bool setGameParameter(string parameterName, string parameterValue) {
  if (parameterName ~= "pointsPerKill") {
    pointsPerKill = float(parameterValue);
    return true;
  }

  if (parameterName ~= "reinforcementCount") {
    reinforcementCount = int(parameterValue);
    return true;
  }

  if (parameterName ~= "reinforcementStartingPoints") {
    reinforcementStartingPoints = float(parameterValue);
    return true;
  }

  if (parameterName ~= "minReinforcementPoints") {
    minReinforcementPoints = float(parameterValue);
    return true;
  }

  if (parameterName ~= "maxReinforcementPoints") {
    maxReinforcementPoints = float(parameterValue);
    return true;
  }

  if (parameterName ~= "flagshipStartingPoints") {
    flagshipStartingPoints = float(parameterValue);
    return true;
  }

  if (parameterName ~= "minFlagshipPoints") {
    minFlagshipPoints = float(parameterValue);
    return true;
  }

  if (parameterName ~= "maxFlagshipPoints") {
    maxFlagshipPoints = float(parameterValue);
    return true;
  }

  return super.setGameParameter(parameterName, parameterValue);
}

simulated function array<FleetOption> getFleets() {
  local array<FleetOption> result;

  result[result.length] = createFleetOption("Link_Pulse", class'LinkPulse');
  result[result.length] = createFleetOption("Link_Mixed", class'LinkMixed');
  result[result.length] = createFleetOption("Link_Plasma", class'LinkPlasma');

  result[result.length] = createFleetOption("ASMD_Balanced", class'ASMDBalanced');
  result[result.length] = createFleetOption("ASMD_Heavy", class'ASMDHeavy');
  result[result.length] = createFleetOption("ASMD_Defensive", class'ASMDDefensive');

  result[result.length] = createFleetOption("Rocket_Balanced", class'RocketBalanced');

  return result;
}

simulated protected function FleetOption createFleetOption(string fleetName, class<BaseUserLoader> fleetLoaderClass) {
  local FleetOption result;
  
  result.fleetName = fleetName;
  result.fleetLoaderClass = fleetLoaderClass;
  
  return result;
}
  
simulated function class<User> getNewUserClass() {
  return class'CB_BaseCarrierUser';
}

simulated function createdNewUser(User newUser) {
  local int i;
  local DFCB_PlayerInfo reinforcementPlayer;

  super.createdNewUser(newUser);

  setInitialFlagshipPoints(newUser);

  for (i=0;i<reinforcementCount;i++) {
    reinforcementPlayer = CB_BaseCarrierUser(NewUser).Team.AddPlayer();

    changePlayerPoints(reinforcementPlayer, reinforcementStartingPoints);
  }
}

simulated function class<SensorSimulationStrategy> getSensorSimulationStrategyClass() {
  return class'AlwaysDetectSensorSimulationStrategy';
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ***** Events and Notifications.

simulated function notifyShipKilled(Ship other, object destroyedBy) {
  super.notifyShipKilled(other, destroyedBy);

  if (UTSB_BaseUser(destroyedBy) != none)
    scoreShipKill(UTSB_BaseUser(destroyedBy), other);

  if (CB_BaseCarrierUser(other.getShipOwner()) != None && other == CB_BaseCarrierUser(other.getShipOwner()).flagship)
    flagshipDestroyed(other, destroyedBy);
}

simulated function flagshipDestroyed(Ship other, object destroyedBy) {
  playerKilled(other.getShipOwner(), destroyedBy);
}

simulated function setInitialFlagshipPoints(User other) {
  changePlayerPoints(CB_BaseCarrierUser(other).flagshipPlayer, flagshipStartingPoints);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function scoreShipKill(UTSB_BaseUser user, Ship other) {
  addPoints(user, pointsPerKill * other.radius);
}

simulated function addPoints(User user, float points) {
  local int i;
  local CB_BaseCarrierUser carrierUser;
  local float perPlayerPoints;

  carrierUser = CB_BaseCarrierUser(user);
  if (carrierUser == none) return;

  perPlayerPoints = points / (carrierUser.team.players.length+1);

  changePlayerPoints(carrierUser.flagshipPlayer, perPlayerPoints);

  for (i=0;i<carrierUser.team.players.length;i++)
    changePlayerPoints(carrierUser.team.players[i], perPlayerPoints);
}

simulated function changePlayerPoints(DFCB_PlayerInfo player, float delta) {
  if (player.bFlagship)  
    player.points = FClamp(player.points + delta, minFlagshipPoints, maxFlagshipPoints);
  else
    player.points = FClamp(player.points + delta, minReinforcementPoints, maxReinforcementPoints);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  pointsPerKill=2

  flagshipStartingPoints=0
  minFlagshipPoints=1500
  maxFlagshipPoints=10000

  reinforcementStartingPoints=0
  minReinforcementPoints=0
  maxReinforcementPoints=3000
}