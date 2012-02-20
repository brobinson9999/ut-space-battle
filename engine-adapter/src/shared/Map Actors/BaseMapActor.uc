class BaseMapActor extends BaseActor placeable;

simulated function executeConsoleCommand(string command) {
  consoleCommand("gl "$command);
}

simulated function executeConsoleCommands(array<string> consoleCommands) {
  local int i;

  for (i=0;i<consoleCommands.length;i++)
    executeConsoleCommand(consoleCommands[i]);
}

defaultproperties
{
}
