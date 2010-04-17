class PlayerShipObserver extends ShipObserver;

var Ship observed;
var SpaceGameplayInterfaceConcreteBase observingFor;

simulated function initialize(Ship newObserved, SpaceGameplayInterfaceConcreteBase observeFor)
{
  observed = newObserved;
  observingFor = observeFor;

  observed.addShipObserver(self);
}

simulated function cleanup()
{
  if (observed != none)
    observed.removeShipObserver(self);

  observed = none;
  observingFor = none;

  super.cleanup();
}

simulated function notifyShipDestroyed()                                    { observingFor.setPlayerShip(none, none); }

defaultproperties
{
}