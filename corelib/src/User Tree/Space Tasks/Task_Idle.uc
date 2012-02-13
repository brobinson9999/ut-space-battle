class Task_Idle extends SpaceTask;

// Task that doesn't do anything.

simulated function bool Is_Relevant() {
  return true;
}

defaultproperties
{
  priority=1
}