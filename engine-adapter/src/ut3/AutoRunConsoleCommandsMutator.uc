class AutoRunConsoleCommandsMutator extends UTMutator abstract;

// dummy variables for compatibility with UT2004
var string groupName;
var string friendlyName;
var string description;

var bool bInitialized;
var array<string> commands;

simulated function tick(float delta) {
  super.tick(delta);
  
  if (!bInitialized && delta > 0) {
    attemptInitialization();
  }
}

simulated function attemptInitialization() {
  runConsoleCommands(getConsoleCommands());
  bInitialized = true;
}

simulated function runConsoleCommands(array<string> localCommands)
{
  local int i;

  for (i=0;i<localCommands.Length;i++)
    consoleCommand("gl "$localCommands[i]);
}

simulated function array<string> getConsoleCommands() {
  return commands;
}

defaultproperties
{
}
