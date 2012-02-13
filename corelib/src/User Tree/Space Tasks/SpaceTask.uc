class SpaceTask extends BaseObject;

var float priority;

simulated function bool Is_Relevant() {
  return true;
}

simulated function Recieve_Assignment_To(SpaceWorker Worker);

defaultproperties
{
  priority=1
}