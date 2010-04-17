class SensingCommandingWorkerDecoratorSensorObserver extends UserSensorObserver;

var User observedUser;
var SensingCommandingWorkerDecorator observingFor;

simulated function initialize(User observeUser, SensingCommandingWorkerDecorator observeFor)
{
  observedUser = observeUser;
  observingFor = observeFor;

  observedUser.addSensorObserver(self);
}

simulated function cleanup()
{
  if (observedUser != none)
    observedUser.removeSensorObserver(self);

  observedUser = none;
  observingFor = none;

  super.cleanup();
}

simulated function gainedContact(Contact other)   { observingFor.gainedContact(other);      }
simulated function lostContact(Contact other)     { observingFor.lostContact(other);        }
  
defaultproperties
{
}