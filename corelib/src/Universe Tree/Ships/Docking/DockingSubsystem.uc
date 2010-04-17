class DockingSubsystem extends BaseObject;

simulated function bool attemptDock(Ship docker, Ship dockee);
simulated function bool acceptDock(Ship docker, Ship dockee);
simulated function bool attemptUndock(Ship docker, Ship dockee);
simulated function Ship getDockedTo();
simulated function addCargo(Ship newCargo);
simulated function removeCargo(Ship oldCargo);

defaultproperties
{
}