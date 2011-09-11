class UnrealEngine2Adapter extends UnrealEngineAdapter abstract;

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

// Debugging.
var bool                                bDebugReferences;   // If true, check references when destroying GameInfo to entities that haven't been cleaned up.

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function initializeEngineAdapter()
{
//  bDebugReferences = true;
  
  setPawnClass("ClientScripts.PawnAdapter");
  setPlayerControllerClass("ClientScripts.BasicControlExtractingPlayerControllerAdapter");
//  setPlayerControllerClass("ClientScripts.PlayerControllerAdapter");
  setHUDClass("ClientScripts.HUDAdapter");
  
  gameSimulationAnchor = GameSimulationAnchor(spawnEngineObject(class'GameSimulationAnchor'));
  propogateGlobalsActor(self, gameSimulationAnchor);
}

simulated function setPawnClass(String pawnClass);
simulated function setPlayerControllerClass(String playerControllerClass);
simulated function setHUDClass(String HUDClass);

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

  // Give a dummy weapon to bots so they won't complain in the log about not having a weapon.
  if (Bot(other) != none) {
    WeaponAdapter(spawnEngineObject(class'WeaponAdapter')).giveTo(other.pawn);
    other.switchToBestWeapon();
  }

  controllerPossessPawn(other, other.pawn);
  
  super.restartPlayer(other);
}

simulated function controllerPossessPawn(Controller c, Pawn p) {
  c.possess(p);
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

  installCleanupWatcher();
  installHUDDriver();
  installInputDriver();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function installCleanupWatcher() {
  cleanupWatcher = LevelChangeInteraction(class'InteractionUtils'.static.getSingletonInteraction(pc, class'LevelChangeInteraction', "ClientScripts.LevelChangeInteraction"));
  cleanupWatcher.cleanupTargets[cleanupWatcher.cleanupTargets.length] = self;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function installHUDDriver() {
  HUD = HUDAdapter(PC.myHUD);
  HUD.setGameAdapter(self);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function installInputDriver() {
  inputDriver = class'InputDriver'.static.getSingletonInputDriver(pc);
//  inputDriver = class'InputDriver'.static.installNewInputDriver(pc);
  if (inputDriver == none)
    errorMessage("An error occurred while installing the input driver.");
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function addInputView(InputView newView)
{
  inputDriver.addObserver(newView);
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
    canvasObject.consoleFont = HUD.getConsoleFont(canvasObject.unrealCanvas);
    canvasObject.consoleColor = HUD.consoleColor;
  }
  
  return canvasObject;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function debugCountObjects(class<object> classFilter)
{
  local bool bRunaway;
  local int tallyCount;
  local Tallier tally;
  local Object o;

  tally = Tallier(allocateObject(class'Tallier'));

  foreach allObjects(classFilter, o)
  {
    // Prevent "runaway loop" error. Sometimes there is so many objects the system erroneously detects the loop as a runaway.
    tallyCount++;
    if (tallyCount > 100000)
    {
      bRunaway = true;
      break;
    }

    tally.add(o.class, 1);
  }

  errorMessage("Object Counts: (sorted)");
  if (bRunaway) errorMessage("Count was aborted before completion to avoid 'runaway loop' error. Results are not complete.");
  tally.sort();
  tally.print();
  tally.cleanup();
}

simulated function array<object> getReferencingObjects(object referencedObject)
{
  local array<object> result;
  
  getReferencers(referencedObject, result);
  
  return result;
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
    log("logMessage failed real-time display due to a lack of HUD.");

  // Print to console.
  if (PC != none && PC.Player != none && PC.Player.Console != none)
    PC.player.console.chat(message, 6.0, none);
  else
    log("logMessage failed real-time display due to a lack of Console.");

  // Print to log.
  log(message);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function playInterfaceSound(object engineSoundObject, float volume) {
    if (volume == 0)
      volume = 1;
  
    if (PC != none)
      PC.playOwnedSound(Sound(engineSoundObject),,volume);
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

  // Check for lingering references that should have been cleaned up.
  if (bDebugReferences) {
//    debugReferences();
    log("Checking for objects that are cleaned up, but still referenced, or still reference other objects...");
    debugCheckForCleanedUpObjectsStillReferenced();
    log("Cleaning up all BaseObjects...");
    cleanUpAllBaseObjects();
    log("Checking for references after cleanup...");
    debugCheckForCleanedUpObjectsStillReferenced();
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function debugReferences()
{
  local BaseObject referencersOf;
  
  log("Debugging References...");
  foreach AllObjects(class'BaseObject', referencersOf)
    debugPrintReferencers(referencersOf, false, 0);

  cleanUpAllBaseActors();
  cleanUpAllBaseObjects();
  
  foreach AllObjects(class'BaseObject', referencersOf)
    debugPrintReferencers(referencersOf, false, 0);
}

simulated function cleanUpAllBaseObjects() {
  local BaseObject e;

  foreach AllObjects(class'BaseObject', e) {
    if (e != self) {
      e.cleanup();
    }
  }
}

// debugCheckForCleanedUpObjectsStillReferenced: -> boolean
// Scans over all allocated objects to determine if any objects that have
// ostensibly been cleaned up still have references to or from them. Prints
// messages to the log on any instances found. If any instances are found,
// true is returned. Otherwise, false is returned.
simulated function bool debugCheckForCleanedUpObjectsStillReferenced() {
  local BaseObject E;
  local bool result;
  
  foreach AllObjects(class'BaseObject', E) {
    result = result || debugPrintReferencers(E, !debugHasObjectBeenCleanedUp(E), 0);
  }
  
  return result;
}

simulated function bool debugPrintReferencers(object referencersOf, bool bOnlyIfCleanedUp, int fanOut) {
  local int i;
  local array<object> referencers;
  local bool result;

  referencers = getReferencingObjects(referencersOf);
  for (i=0;i<referencers.length;i++) {
    if (!bOnlyIfCleanedUp || debugHasObjectBeenCleanedUp(referencers[i])) {
      log(getDebugStringFor(referencersOf)$" <- "$getDebugStringFor(referencers[i]));
      if (fanOut > 0) {
        log("fanOut "$fanOut$">>>");
        debugPrintReferencers(referencers[i], false, fanOut - 1);
        log("fanOut "$fanOut$"<<<");
      }
      result = true;
    }
  }
  
  return result;
}

simulated function string getDebugStringFor(object other) {
  if (BaseObject(other) != none) {
    if (debugHasObjectBeenCleanedUp(other))
      return "*"$BaseObject(other).getDebugString();
    else
      return BaseObject(other).getDebugString();
  } else {
    if (debugHasObjectBeenCleanedUp(other))
      return "*"$other;
    else
      return ""$other;
  }
}

simulated function bool debugHasObjectBeenCleanedUp(object other) {
//  if (BaseObject(other) != none)
//    return BaseObject(other).bDebugCleanedUp;

  if (Actor(other) != none)
    return Actor(other).bDeleteMe;

  return false;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function bool engineObjectsOnSameTeam(object engineObject1, object engineObject2) {
  if (Controller(engineObject1) == none || Controller(engineObject2) == none)
    return false;

  if (engineObject1 == engineObject2)
    return true;
    
  return Controller(engineObject1).sameTeamAs(Controller(engineObject2));
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float getTickSecondsPerRealSecond() {
  return getLevel().timeDilation;
}

simulated function LevelInfo getLevel();

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
  bDebugReferences=false
}