class AutoRunConsoleCommandsMutator extends Mutator abstract;

// dummy variable for compatibility with UT3.
var array<string> groupNames;

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

simulated function runConsoleCommands(array<string> commands)
{
  local int i;

  for (i=0;i<commands.Length;i++)
    consoleCommand("gl "$commands[i]);
}


simulated function array<string> getConsoleCommands() {
  return commands;
}

defaultproperties
{
}
