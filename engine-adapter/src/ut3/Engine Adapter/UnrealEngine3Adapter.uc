class UnrealEngine3Adapter extends UnrealEngineAdapter abstract;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// Engine Hooks.
var PlayerControllerAdapter             PC;
var InputDriver                         inputDriver;
var HUDAdapter                          HUD;
var LevelChangeInteraction              cleanupWatcher;
var GameSimulationAnchor                gameSimulationAnchor;
var protected UnrealEngineCanvasObject  canvasObject;

var class<HUD>                          defaultHUDClass;
var class<HUDAdapter>                   defaultHUDAdapterClass;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function initializeEngineAdapter()
{
  setPawnClass(class'PawnAdapter');
  setPlayerControllerClass(class'PlayerControllerAdapter');
  setHUDClass(getHUDClass());

  gameSimulationAnchor = GameSimulationAnchor(spawnEngineObject(class'GameSimulationAnchor'));
  propogateGlobalsActor(self, gameSimulationAnchor);
}

simulated function setPawnClass(class<Pawn> pawnClass);
simulated function setPlayerControllerClass(class<PlayerController> playerControllerClass);
simulated function setHUDClass(class<HUD> HUDClass);

simulated function class<HUD> getHUDClass() {
  return defaultHUDClass;
}

simulated function class<HUDAdapter> getHUDAdapterClass() {
  return defaultHUDAdapterClass;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setCameraLocation(vector newCameraLocation) {
  PC.setCameraLocation(newCameraLocation * class'UnrealEngineCanvasObject'.static.getGlobalPositionScaleFactor());  
}

simulated function setCameraRotation(rotator newCameraRotation) {
  PC.setCameraRotation(newCameraRotation);  
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function restartPlayer(Controller other) {
  other.pawn = Pawn(spawnEngineObject(class'PawnAdapter'));

  controllerPossessPawn(other, other.pawn);
  
  super.restartPlayer(other);
}

simulated function controllerPossessPawn(Controller c, Pawn p) {
  c.possess(p, false);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setPlayerControllerAdapter(PlayerControllerAdapter newPC) {
  PC = newPC;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// To be overridden in subclass.
simulated function PlayerController facadeLogin(string portal, string options, out string error);

simulated event PlayerController login(string portal, string options, out string error)
{
  local PlayerController superResult;

  // Get a reference to the new PC.
  superResult = facadeLogin(portal, options, error);
  setPlayerControllerAdapter(PlayerControllerAdapter(superResult));

  // Return the playercontroller.
  return superResult;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// To be overridden in subclass.
simulated event facadePostLogin(PlayerController newPlayer);

simulated function postLogin(PlayerController newPlayer) {
  facadePostLogin(newPlayer);

  newPlayerJoined(newPlayer);
}

// called from postLogin but also when a seamless level transition has occurred. (in which case, players do not "login" again)
simulated function newPlayerJoined(Controller newController)
{
  if (PlayerController(newController) == none) return;
  
  // this will already be set if it was set in login, but won't be if this was a seamless level transition.
  if (PC != newController)
    setPlayerControllerAdapter(PlayerControllerAdapter(newController));

  installCleanupWatcher();
  installHUDDriver();
  installInputDriver();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function installCleanupWatcher()
{
  // Create Level Change Interaction.
  cleanupWatcher = new class'LevelChangeInteraction';
  cleanupWatcher.cleanupTarget = self;

  // Install the interaction.
  // The position of this interaction is not important.
  if (LocalPlayer(PC.Player).viewportClient.insertInteraction(cleanupWatcher, -1) == -1)
    errorMessage("An error occurred while installing the level change interaction.");
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function installHUDDriver() {
  HUD = new getHUDAdapterClass();
  propogateGlobals(HUD);
  HUD.setGameAdapter(self);
  HUD.setHUDFacade(PC.myHUD);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function installInputDriver()
{
  // Create Input Interaction.
  inputDriver = new class'InputDriver';
  inputDriver.initializeInputDriver();

  // Put in Interaction List.
  // Insert after the console and UIController but before the player interaction.
  // A better way might be to scan the list instead of hardcoding a position.
  if (LocalPlayer(PC.player).viewportClient.insertInteraction(inputDriver, 2) == -1)
    errorMessage("An error occurred while installing the input driver.");
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function addInputView(InputView newView)
{
  inputDriver.view = newView;
  PC.inputView = newView;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function UnrealEngineCanvasObjectBase getCanvasObject(Canvas unrealCanvas) {
  if (canvasObject == none)
    canvasObject = UnrealEngineCanvasObject(allocateObject(class'UnrealEngineCanvasObject'));
    
  canvasObject.setUnrealCanvas(unrealCanvas);
  if (HUD != none) {
    canvasObject.consoleColor = HUD.getConsoleColor();
  }
  
  return canvasObject;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function logMessage(coerce string message)
{
  // Print to HUD.
  if (HUD != none)
    HUD.message(none, message, '');
  else
    `log("logMessage failed real-time display due to a lack of HUD.");

  // Print to console.
  if (PC != None && LocalPlayer(PC.player) != None && LocalPlayer(PC.player).viewportClient != None && LocalPlayer(PC.player).viewportClient.viewportConsole != none)
    LocalPlayer(PC.player).viewportClient.viewportConsole.outputText(message);
  else
    `log("logMessage failed real-time display due to a lack of Console.");

  // Print to log.
  `log(message);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanup()
{
  // Clear and cleanup object references.
  if (inputDriver           != none) inputDriver.cleanup();
  if (cleanupWatcher        != none) cleanupWatcher.cleanup();
  if (HUD                   != none) HUD.cleanup();
  if (PC                    != none) PC.cleanup();
  if (gameSimulationAnchor  != none) gameSimulationAnchor.destroy();
  
  if (canvasObject != none) {
    canvasObject.cleanup();
    canvasObject = none;
  }
  
  inputDriver               = none;
  cleanupWatcher            = none;
  HUD                       = none;
  PC                        = none;
  gameSimulationAnchor      = none;
  
  super.cleanup();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool engineObjectsOnSameTeam(object engineObject1, object engineObject2) {
    local int teamNum1, teamNum2;
    
    if (Controller(engineObject1) == none || Controller(engineObject2) == none)
      return false;

    if (engineObject1 == engineObject2)
      return true;
      
    teamNum1 = Controller(engineObject1).getTeamNum();
    teamNum2 = Controller(engineObject2).getTeamNum();
    
    return (teamNum1 != 255 && teamNum2 != 255 && teamNum1 == teamNum2);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float getTickSecondsPerRealSecond() {
  return getLevel().timeDilation;
}

simulated function WorldInfo getLevel();

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  defaultHUDClass=class'UTHUDFacade'
  defaultHUDAdapterClass=class'UTHUDAdapter'
}