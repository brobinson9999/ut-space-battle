class SimpleInputBindingObserver extends InputObserver;

var string targetKey;
var string targetAction;
var string consoleCommand;
var UnrealEngineAdapter engineAdapter;

simulated function bool KeyEvent(string Key, string Action, float Delta)
{
  if (MatchesBinding(Key, Action, Delta))
  {
    ExecuteBinding(Key, Action, Delta);
    return true;
  }

  return false;
}

simulated function bool MatchesBinding(string Key, string Action, float Delta)
{
  return (Key ~= TargetKey) && (Action ~= TargetAction);
}
  
simulated function ExecuteBinding(string Key, string Action, float Delta)
{
  local int i;
  local array<string> stringParts;

  // Split multiple values.
  StringParts = class'SpaceGameplayInterfaceConcreteBaseBase'.static.splitString(consoleCommand, "|");

  for (i=0;i<StringParts.Length;i++)
    engineAdapter.receivedConsoleCommand(stringParts[i]);
}

simulated function cleanup()
{
  engineAdapter = none;
  super.cleanup();
}


defaultproperties
{
}