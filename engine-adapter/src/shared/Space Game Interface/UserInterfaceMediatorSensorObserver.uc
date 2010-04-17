class UserInterfaceMediatorSensorObserver extends UserSensorObserver;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var User observedUser;
  var UserInterfaceMediator observingFor;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function initialize(User observeUser, UserInterfaceMediator observeFor)
  {
    observedUser = observeUser;
    observingFor = observeFor;
    
    observedUser.addSensorObserver(self);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function gainedContact(Contact other)   { observingFor.gainedContact(other);      }
  simulated function lostContact(Contact other)     { observingFor.lostContact(other);        }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cleanup()
  {
    if (observedUser != none)
      observedUser.removeSensorObserver(self);
      
    observedUser = none;
    observingFor = none;
    
    super.cleanup();
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}