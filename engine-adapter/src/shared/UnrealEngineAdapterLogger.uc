class UnrealEngineAdapterLogger extends Logger;

var UnrealEngineAdapter adapter;

// logMessage: string ->
// Writes a message to the log.
simulated function logMessage(string message) {
  adapter.logMessage(message);
}

simulated function cleanup() {
  adapter = none;
  
  super.cleanup();
}

defaultproperties
{
}