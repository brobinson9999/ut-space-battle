class xTeamGameAdapter extends UnrealEngine2Adapter;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var xTeamGameFacade gameInfoFacade;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setPawnClass(String pawnClass) {
  gameInfoFacade.defaultPlayerClassName = pawnClass;
}

simulated function setPlayerControllerClass(String playerControllerClass) {
  gameInfoFacade.playerControllerClassName = playerControllerClass;
}

simulated function setHUDClass(String HUDClass) {
  gameInfoFacade.HUDType = HUDClass;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function Actor getGameInfoFacade() {
  return gameInfoFacade;
}

simulated function setGameInfoFacade(xTeamGameFacade other) {
  gameInfoFacade = other;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function PlayerController facadeLogin(string portal, string options, out string error) {
  return gameInfoFacade.superLogin(portal, options, error);
}

simulated event facadePostLogin(PlayerController newPlayer) {
  gameInfoFacade.superPostLogin(newPlayer);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanup() {
  super.cleanup();

  if (gameInfoFacade != none) {
    gameInfoFacade.cleanup();
    gameInfoFacade = none;
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function LevelInfo getLevel() {
  return gameInfoFacade.getLevel();
}

simulated function GameInfo getGameInfo() {
  return gameInfoFacade;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}