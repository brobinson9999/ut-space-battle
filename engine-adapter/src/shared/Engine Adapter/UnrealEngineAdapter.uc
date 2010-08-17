// This should be extended, but I have not made it abstract so that it can be used alone in tests.
class UnrealEngineAdapter extends BaseObject;


// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var protected bool bGameInitialized;
var protected EngineObjectMapping engineObjectMapping;

var float performanceTestTimer;
var string performanceTestDescription;

var InputView mainInputView;
var InterfaceInputObserver interfaceObserver;
var array<SimpleInputBindingObserver> keyBindObservers;
var SpaceGameplayInterface SGIinterface;
var UserInterfaceMediator interfaceMediator;

var UnrealEngineAdapterDelegatedForeignPolicy newUserForeignPolicy;

var UnrealEngineAdapterGameObserver gameObserver;

var BungeeMapActor bungeeMapActor;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function setEngineObjectMapping(EngineObjectMapping newMapping) {
  engineObjectMapping = newMapping;
}

simulated function EngineObjectMapping getEngineObjectMapping() {
  if (engineObjectMapping == none)
    engineObjectMapping = EngineObjectMapping(spawnEngineObject(class'EngineObjectMapping'));
 
  return engineObjectMapping;
}

simulated function ObjectAllocator getObjectAllocator() {
  local ObjectAllocator allocator;
  
  allocator = super.getObjectAllocator();
  if (allocator == none) {
    // We can't use allocateObject for the things that are set in propogateGlobals.
    // If we do, propogateGlobals will call this function again and create an infinite loop.
    allocator = new class'CompositeObjectPool';
    setObjectAllocator(allocator);
    propogateGlobals(allocator);
  }
  
  return allocator;
}

simulated function Logger getLogger() {
  local Logger result;
  
  result = super.getLogger();
  if (result == none) {
    // We can't use allocateObject for the things that are set in propogateGlobals.
    // If we do, propogateGlobals will call this function again and create an infinite loop.
    result = new class'UnrealEngineAdapterLogger';
    UnrealEngineAdapterLogger(result).adapter = self;
    setLogger(result);
    propogateGlobals(result);
  }
  
  return result;
}

simulated function Clock getClock() {
  local Clock result;
  
  result = super.getClock();
  if (result == none) {
    // We can't use allocateObject for the things that are set in propogateGlobals.
    // If we do, propogateGlobals will call this function again and create an infinite loop.
    result = new class'DefaultClock';
    setClock(result);
    propogateGlobals(result);
  }
  
  return result;
}

simulated function PerformanceThrottle getPerformanceThrottle() {
  local PerformanceThrottle result;
  
  result = super.getPerformanceThrottle();
  if (result == none) {
    // We can't use allocateObject for the things that are set in propogateGlobals.
    // If we do, propogateGlobals will call this function again and create an infinite loop.
    result = new class'DefaultPerformanceThrottle';
    setPerformanceThrottle(result);
    propogateGlobals(result);
  }
  
  return result;
}

simulated function UnrealEngineCanvasObjectBase getCanvasObject(Canvas unrealCanvas);

simulated function setGameSimulation(BaseObject other)  {
  super.setGameSimulation(other);

  if (other != none) {
    propogateGlobals(other);

    if (getObjectAllocator() != none)
      propogateGlobals(getObjectAllocator());
  }

  if (UTSpaceBattleGameSimulation(other) != none) {
    UTSpaceBattleGameSimulation(other).newUserForeignPolicy = getNewUserForeignPolicy();
  }
}

simulated protected function UserForeignPolicy getNewUserForeignPolicy() {
  if (newUserForeignPolicy == none) {
    newUserForeignPolicy = UnrealEngineAdapterDelegatedForeignPolicy(allocateObject(class'UnrealEngineAdapterDelegatedForeignPolicy'));
    newUserForeignPolicy.setAdapter(self);
  }
  
  return newUserForeignPolicy;
}

simulated protected function UTSpaceBattleGameSimulationObserver getGameObserver() {
  if (gameObserver == none) {
    gameObserver = UnrealEngineAdapterGameObserver(allocateObject(class'UnrealEngineAdapterGameObserver'));
    gameObserver.setAdapter(self);
    gameObserver.setGame(UTSpaceBattleGameSimulation(getGameSimulation()));
  }
  
  return gameObserver;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function cleanup() {
  local ObjectAllocator tempAllocator;
  
  if (bungeeMapActor != none) {
    bungeeMapActor.destroy();
    bungeeMapActor = none;
  }
  
  // Make sure that no actors have lingering references to any of the things we are about to clean up.
  cleanUpAllBaseActors();

  if (gameObserver != none) {
    gameObserver.cleanup();
    gameObserver = none;
  }

  while (keybindObservers.Length > 0) {
    keybindObservers[0].cleanup();
    keybindObservers.Remove(0,1);
  }

  if (newUserForeignPolicy != none) {
    newUserForeignPolicy.cleanup();
    newUserForeignPolicy = none;
  }

  if (mainInputView != none) {
    mainInputView.cleanup();
    mainInputView = none;
  }

  if (interfaceObserver != none) {
    interfaceObserver.cleanup();
    interfaceObserver = none;
  }

  if (interfaceMediator  != none) {
    interfaceMediator.cleanup();
    interfaceMediator = none;
  }

  if (SGIinterface != none) {
    SGIinterface.cleanup();
    SGIinterface = none;
  }

  if (engineObjectMapping != none) {
    engineObjectMapping.destroy();
    setEngineObjectMapping(none);
  }

  if (getGameSimulation() != none) {
    getGameSimulation().cleanup();
    setGameSimulation(none);
  }

  if (getPerformanceThrottle() != none) {
    getPerformanceThrottle().cleanup();
    setPerformanceThrottle(none);
  }
  
  if (getClock() != none) {
    getClock().cleanup();
    setClock(none);
  }

  if (getLogger() != none) {
    getLogger().cleanup();
    setLogger(none);
  }

  // The adapter is responsible for cleaning up the allocator, but super.cleanup() will remove the reference.
  tempAllocator = getObjectAllocator();
  super.cleanup();
  if (tempAllocator != none)
    tempAllocator.cleanup();
}

simulated function cleanUpAllBaseActors() {
  local BaseActor other;
  local Actor actorAnchor;
  
  actorAnchor = getGameInfoFacade();
  foreach actorAnchor.AllActors(class'BaseActor', other)
    other.cleanup();
}

simulated function Actor getGameInfoFacade();

simulated static function propogateGlobalsActor(BaseObject from, BaseActor to) {
  to.setGameSimulation(from.getGameSimulation());
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function tick(float delta) {
  if (!ensureInitialized(delta)) return;

  DefaultPerformanceThrottle(getPerformanceThrottle()).setTickSecondsPerRealSecond(getTickSecondsPerRealSecond());
  getPerformanceThrottle().updateThrottleFactor(delta);

  getClock().tick(delta);

  if (getGameSimulation() != none) {
//    getGameSimulation().cycle(delta);

    SGIinterface.updateCamera();
    setCameraLocation(SGIinterface.getCameraLocation());
    setCameraRotation(SGIinterface.getCameraRotation());

    // should this be before the above maybe?
    // on the other hand, it's probably better to draw the HUD after the camera has moved
    SGIinterface.cycle(mainInputView, Delta);
  }
}

simulated function setCameraLocation(vector newCameraLocation);
simulated function setCameraRotation(rotator newCameraRotation);

simulated function float getTickSecondsPerRealSecond() {
  return 1;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function bool ensureInitialized(float delta)
{
  // Initialize the game simulation on the first non-zero length tick.
  // The first non-zero tick ensures that all of the engine initialization has completed by this time.
  if (!bGameInitialized && delta > 0)
    initializeGameSimulation();

  return bGameInitialized;
}

simulated function initializeGameSimulation() {
  getGameObserver();

  // Install Input Hooks.
  mainInputView = InputView(allocateObject(class'InputView'));
  addInputView(mainInputView);

  // Install Observer for the Interface.
  interfaceObserver = InterfaceInputObserver(allocateObject(class'InterfaceInputObserver'));
  mainInputView.addObserver(interfaceObserver);

  createKeyBinding("IK_W", "IST_Press", "randomize_player_ship|focus ps");
//  createKeyBinding("IK_E", "IST_Press", "set_ai_control 0");
  createKeyBinding("IK_Q", "IST_Press", "toggle_ai_control");
//  createKeyBinding("IK_RightMouse", "IST_Press", "set_ai_control 1");
//  createKeyBinding("IK_RightMouse", "IST_Release", "set_ai_control 0");
//  createKeyBinding("IK_LeftMouse", "IST_Press", "set_bFire 1");
//  createKeyBinding("IK_LeftMouse", "IST_Release", "set_bFire 0");
//  createKeyBinding("IK_5", "IST_Press", "set_acceleration -1");
//  createKeyBinding("IK_6", "IST_Press", "set_acceleration -0.5");
//  createKeyBinding("IK_7", "IST_Press", "set_acceleration 0");
//  createKeyBinding("IK_8", "IST_Press", "set_acceleration 0.33");
//  createKeyBinding("IK_9", "IST_Press", "set_acceleration 0.66");
//  createKeyBinding("IK_0", "IST_Press", "set_acceleration 1");

  createKeyBinding("IK_R", "IST_Press", "set_hud_readout_delta 1");
  createKeyBinding("IK_Y", "IST_Press", "toggleShowAllHUDReadouts");
  createKeyBinding("IK_J", "IST_Press", "toggleRenderHUD");
  createKeyBinding("IK_K", "IST_Press", "toggleRenderProjectilesOnHUD");
  createKeyBinding("IK_L", "IST_Press", "toggleRenderWorld");
  createKeyBinding("IK_I", "IST_Press", "set_camera behindview|set_relative_controls 0|set_strategic_controls 0");
  createKeyBinding("IK_O", "IST_Press", "set_camera strategic|set_relative_controls 0|set_strategic_controls 1");
  createKeyBinding("IK_P", "IST_Press", "set_camera pilot|set_relative_controls 1|set_strategic_controls 0");

  createKeyBinding("IK_LeftBracket", "IST_Press", "set_camera chase|set_relative_controls 0|set_strategic_controls 0");

//  createKeyBinding("IK_MouseWheelDown", "IST_Press", "strategic_camera_distance_delta 50");
//  createKeyBinding("IK_MouseWheelUp", "IST_Press", "strategic_camera_distance_delta -50");

//  createKeyBinding("IK_SpaceBar", "IST_Press", "multiplyStrategicCameraDistance 100");
//  createKeyBinding("IK_SpaceBar", "IST_Release", "multiplyStrategicCameraDistance 0.01");

//  createKeyBinding("IK_Up", "IST_Press", "strategicCameraPanX 10000");
//  createKeyBinding("IK_Up", "IST_Release", "strategicCameraPanX 0");
//  createKeyBinding("IK_Down", "IST_Press", "strategicCameraPanX -10000");
//  createKeyBinding("IK_Down", "IST_Release", "strategicCameraPanX 0");
//  createKeyBinding("IK_Right", "IST_Press", "strategicCameraPanY 10000");
//  createKeyBinding("IK_Right", "IST_Release", "strategicCameraPanY 0");
//  createKeyBinding("IK_Left", "IST_Press", "strategicCameraPanY -10000");
//  createKeyBinding("IK_Left", "IST_Release", "strategicCameraPanY 0");

//  createKeyBinding("IK_T", "IST_Press", "o fts atk closestToCameraCenter<hostile<knownContactsInPlayerShipSector");
//  createKeyBinding("IK_C", "IST_Press", "o fts clr");
//  createKeyBinding("IK_D", "IST_Press", "o fts def ps");
//  createKeyBinding("IK_F", "IST_Press", "o fts atk pswt");
//  createKeyBinding("IK_1", "IST_Press", "set_friendly_targets owned<knownContactsInCameraSector");
//  createKeyBinding("IK_2", "IST_Press", "set_friendly_targets ps");
//  createKeyBinding("IK_3", "IST_Press", "set_friendly_targets carrier");
//  createKeyBinding("IK_4", "IST_Press", "set_friendly_targets fighters");
  createKeyBinding("IK_Backslash", "IST_Press", "setFleetDelta 1");
  
  interfaceMediator = UserInterfaceMediator(allocateObject(class'UserInterfaceMediator'));
  
  SGIinterface = SpaceGameplayInterface(allocateObject(class'SpaceGameplayInterfaceEngineSpecific'));
  SpaceGameplayInterfaceEngineSpecific(SGIinterface).engineAdapter = self;
  interfaceObserver.interface = SGIinterface;
  interfaceMediator.setUserInterface(SGIinterface);
  SGIinterface.initializeInterface(interfaceMediator);

  bungeeMapActor = BungeeMapActor(spawnEngineObject(class'BungeeMapActor',,,vect(0,0,0)));

  bGameInitialized = true;
}

simulated function addInputView(InputView newView);

simulated function SimpleInputBindingObserver createKeyBinding(string key, string action, string consoleCommand)
{
  local SimpleInputBindingObserver Result;

  result = SimpleInputBindingObserver(allocateObject(class'SimpleInputBindingObserver'));
  result.engineAdapter = self;
  result.targetKey = key;
  result.targetAction = action;
  result.consoleCommand = consoleCommand;

  keyBindObservers[keyBindObservers.length] = result;
  mainInputView.addObserver(result);

  return Result;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function debugCountObjects(class<object> classFilter);

simulated function bool receivedConsoleCommand(string command) {
  local array<string> stringParts;
    
  if (command ~= "startGarbageCollectionDaemon")
    spawnEngineObject(class'GarbageCollectionDaemon');
  else if (command ~= "debugCountActors")
    debugCountObjects(class'Actor');
  else if (command ~= "debugCountBaseActors")
    debugCountObjects(class'BaseActor');
  else if (command ~= "debugCountVisibleActors")
    debugCountVisibleActors(class'Actor');
  else if (command ~= "debugCountAllObjects")
    debugCountObjects(class'Object');
  else if (command ~= "debugCountGameObjects")
    debugCountObjects(class'BaseObject');
  else if (SGIinterface != none && SGIinterface.receivedConsoleCommand(interfaceMediator, command))
    return true;
  else {
    stringParts = class'SpaceGameplayInterfaceConcreteBaseBase'.static.splitString(command, " ");
    
    if (stringParts.length >= 2)
      return SpaceGameSimulation(getGameSimulation()).setGameParameter(stringParts[0], stringParts[1]);
    else
      return false;
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function debugCountVisibleActors(class<actor> classFilter)
{
  local bool bRunaway;
  local int tallyCount;
  local Tallier tally;
  local Actor o;

  tally = Tallier(allocateObject(class'Tallier'));

  foreach getGameInfo().allActors(classFilter, o)
  {
    // Prevent "runaway loop" error. Sometimes there is so many objects the system erroneously detects the loop as a runaway.
    tallyCount++;
    if (tallyCount > 100000)
    {
      bRunaway = true;
      break;
    }

    if (!o.bHidden)
      tally.add(o.class, 1);
  }

  errorMessage("Object Counts: (sorted)");
  if (bRunaway) errorMessage("Count was aborted before completion to avoid 'runaway loop' error. Results are not complete.");
  tally.sort();
  tally.print();
  tally.cleanup();
}

simulated function logMessage(coerce string message);

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

//simulated function startPerformanceTest(coerce string testDescription) {
//  performanceTestTimer = 0;
//  clock(performanceTestTimer);
//  performanceTestDescription = testDescription;
//}

//simulated function stopPerformanceTest() {
//  unClock(performanceTestTimer);
//  errorMessage(performanceTestDescription$": "$performanceTestTimer);
//}

//simulated function clock(out float clockTime) {
//  getGameInfo().clock(clockTime);
//}

//simulated function unClock(out float clockTime) {
//  getGameInfo().unClock(clockTime);
//}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function actor spawnEngineObject(class<actor> spawnClass, optional actor spawnOwner, optional name spawnTag, optional vector spawnLocation, optional rotator spawnRotation) {
  return getGameInfo().spawn(spawnClass, spawnOwner, spawnTag, spawnLocation, spawnRotation);
}

simulated function gamePlayerKilled(object killedGameObject, object killerGameObject) {
  local object killedEngineObject;
  local object killerEngineObject;

  if (killedGameObject != none) killedEngineObject = getEngineObjectForGameObject(killedGameObject);
  if (killerGameObject != none) killerEngineObject = getEngineObjectForGameObject(killerGameObject);

  if (killedEngineObject != none)
    enginePlayerKilled(killedEngineObject, killerEngineObject);
}

simulated function enginePlayerKilled(object killedEngineObject, object killerEngineObject) {
  local Controller killedController, killerController;

  killedController = Controller(killedEngineObject);
  killerController = Controller(killerEngineObject);

  if (killedController != none && PawnAdapter(killedController.pawn) != none)
    PawnAdapter(killedController.pawn).playerKilled(killerController);
}

simulated function restartPlayer(Controller other) {
  local object gamePlayerObject;
  
  if (UTSpaceBattleGameSimulation(getGameSimulation()) != none) {
    gamePlayerObject = getGameObjectForEngineObject(other);
    if (gamePlayerObject == none) {
      gamePlayerObject = UTSpaceBattleGameSimulation(getGameSimulation()).createGamePlayerObject(getPlayerNameForEngineObject(other), getSkillLevel(other), PlayerController(other) != none);
      setGameObjectForEngineObject(gamePlayerObject, other);
    }
    UTSpaceBattleGameSimulation(getGameSimulation()).restartPlayer(gamePlayerObject);
  }
  
  // if this is the human player represented by the interface...
  if (SGIinterface != none && PlayerController(other) != none) {
    interfaceMediator.setPlayerUser(BaseUser(getGameObjectForEngineObject(other)));
    SGIinterface.respawnedPlayer(interfaceMediator);
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function float getSkillLevel(object engineObject) {
  local float UTSkillLevel;

  // Get Skill Level in UT2004 Scale.
  if (AIController(engineObject) != none) {
    // Use bot skill for bot players.
    UTSkillLevel = AIController(engineObject).Skill;

    // The UT scale runs from 0 - 7.
    UTSkillLevel = FClamp(UTSkillLevel, 0, 7);
    return UTSkillLevel / 7;
  } else if (PlayerController(engineObject) != none) {
    // Use 0.5 for human players.
    return 0.5;
  } else {
    // Use 0.5 for others. (shouldn't be any normally)
    return 0.5;
  }
}

simulated function string getPlayerNameForEngineObject(object engineObject) {
  return Controller(engineObject).getHumanReadableName();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function worldSpaceOverlays();

simulated function postRender(Canvas canvas) {
  local UnrealEngineCanvasObjectBase canvasObject;
    
  if (getGameSimulation() != none && SGIinterface != none) { 
    canvasObject = getCanvasObject(canvas);
    SGIinterface.renderInterface(interfaceMediator, canvasObject);
    canvasObject.clearUnrealCanvas();
  }
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ** Used to map a game object representation of a player, to a game engine representation of a player.

simulated function object getEngineObjectForGameObject(object other) {
  return getEngineObjectMapping().getEngineObjectForGameObject(other);
}

simulated function object getGameObjectForEngineObject(object other) {
  return getEngineObjectMapping().getGameObjectForEngineObject(other);
}

simulated function setGameObjectForEngineObject(object gameObject, object engineObject) {
  getEngineObjectMapping().setGameObjectForEngineObject(gameObject, engineObject);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function bool isGameObjectHostile(object gameObject, object potentialHostileGameObject) {
  return isEngineObjectHostile(getEngineObjectForGameObject(gameObject), getEngineObjectForGameObject(potentialHostileGameObject));
}

simulated function bool isGameObjectFriendly(object gameObject, object potentialFriendlyGameObject) {
  return isEngineObjectFriendly(getEngineObjectForGameObject(gameObject), getEngineObjectForGameObject(potentialFriendlyGameObject));
}

simulated function bool engineObjectsOnSameTeam(object engineObject1, object engineObject2) {
  return false;
}

simulated function bool isEngineObjectHostile(object engineObject, object potentialHostileEngineObject) {
  if (engineObject == none)
    return false;

  return !engineObjectsOnSameTeam(engineObject, potentialHostileEngineObject);
}

simulated function bool isEngineObjectFriendly(object engineObject, object potentialFriendlyEngineObject) {
  if (engineObject == none)
    return false;

  return engineObjectsOnSameTeam(engineObject, potentialFriendlyEngineObject);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function playInterfaceSound(object engineSoundObject, float volume);
simulated function array<object> getReferencingObjects(object referencedObject);
simulated function GameInfo getGameInfo();

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}