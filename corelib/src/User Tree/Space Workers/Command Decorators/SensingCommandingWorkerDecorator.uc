class SensingCommandingWorkerDecorator extends CommandingWorkerDecorator;

var SensingCommandingWorkerDecoratorSensorObserver sensorObserver;

simulated function initializeWorker() {
  super.initializeWorker();

  sensorObserver = SensingCommandingWorkerDecoratorSensorObserver(allocateObject(class'SensingCommandingWorkerDecoratorSensorObserver'));
  sensorObserver.initializeSensorObserver(user, self);
}

simulated function gainedContact(Contact other);
simulated function lostContact(Contact other);

simulated function cleanup()
{
  if (sensorObserver != none) sensorObserver.cleanup();
  sensorObserver = none;

  super.cleanup();
}

defaultproperties
{
}