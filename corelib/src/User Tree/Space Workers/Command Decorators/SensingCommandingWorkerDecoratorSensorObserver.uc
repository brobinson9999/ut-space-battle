class SensingCommandingWorkerDecoratorSensorObserver extends UserObserver;

var User observedUser;
var SensingCommandingWorkerDecorator observingFor;

simulated function initializeSensorObserver(User observeUser, SensingCommandingWorkerDecorator observeFor)
{
  observedUser = observeUser;
  observingFor = observeFor;

  observedUser.addUserObserver(self);
}

simulated function cleanup()
{
  if (observedUser != none)
    observedUser.removeUserObserver(self);

  observedUser = none;
  observingFor = none;

  super.cleanup();
}

simulated function gainedContact(Contact other)   { observingFor.gainedContact(other);      }
simulated function lostContact(Contact other)     { observingFor.lostContact(other);        }
  
defaultproperties
{
}