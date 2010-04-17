class UnrealEngineAdapterGameObserver extends UTSpaceBattleGameSimulationObserver;

var UTSpaceBattleGameSimulation observed;
var UnrealEngineAdapter observingFor;

simulated function setAdapter(UnrealEngineAdapter newAdapter) {
  observingFor = newAdapter;
}

simulated function setGame(UTSpaceBattleGameSimulation newGame) {
  if (observed != none)
    observed.removeObserver(self);
    
  observed = newGame;
  
  if (observed != none)
    observed.addObserver(self);
}

simulated function gamePlayerKilled(object killedGameObject, object killerGameObject) {
  observingFor.gamePlayerKilled(killedGameObject, killerGameObject);
}

simulated function cleanup() {
  setAdapter(none);
  setGame(none);
  
  super.cleanup();
}
