class UserInterfaceMediator extends BaseObject;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// This class mediates the interaction between the interface and a user.
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
  
  var SpaceGameplayInterface userInterface;

  var protected User playerUser;
  var UserInterfaceMediatorSensorObserver playerInterfaceSensorObserver;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function setUserInterface(SpaceGameplayInterface newInterface) {
    userInterface = newInterface;
  }
  
  simulated function User getPlayerUser() {
    return playerUser;
  }
  
  simulated function setPlayerUser(User newPlayerUser) {
    local bool bHadNoPlayerUserBefore;

    if (playerUser == newPlayerUser)
      return;
      
    if (playerInterfaceSensorObserver != none) {
      playerInterfaceSensorObserver.cleanup();
      playerInterfaceSensorObserver = none;
    }
    
    bHadNoPlayerUserBefore = (playerUser == none);
    if (playerUser != none)
      userInterface.notifyClearingPlayerUser(self);

    playerUser = newPlayerUser;
    
    if (newPlayerUser != none) {
      playerInterfaceSensorObserver = UserInterfaceMediatorSensorObserver(allocateObject(class'UserInterfaceMediatorSensorObserver'));
      playerInterfaceSensorObserver.initialize(newPlayerUser, self);
    }
    
    userInterface.notifySetPlayerUser(self);
    
    if (newPlayerUser != none && bHadNoPlayerUserBefore) {
      // use chase camera by default, but true "default" is strategic for spectators.
      userInterface.receivedConsoleCommand(self, "set_strategic_controls 0");
      userInterface.receivedConsoleCommand(self, "set_camera chase");
    }
  }
    
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool issueUserCommand(string command) {
    if (playerUser != none)
      return playerUser.receivedUserConsoleCommand(command);
    else  
      return false;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function array<Contact> filterContactsForDesignation(string designation, array<Contact> inputContacts) {
    local array<Contact> result;
    
    result = inputContacts;
    if (userInterface != none)
      result = userInterface.filterContactsForDesignation(self, designation, result);
    if (playerUser != none)
      result = playerUser.filterContactsForDesignation(designation, result);
    
    return result;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function array<SpaceWorker> getWorkersForDesignation(string workerDesignation) {
    local array<Contact> workerContacts;
    
    workerContacts = getContactsForDesignation(workerDesignation);
    return BaseUser(playerUser).workersFromContacts(workerContacts);
  }
  
  simulated function array<Contact> getContactsForDesignation(string designation) {
    local int i;
    local array<Contact> result;
    local array<Contact> interfaceContacts;
    local array<Contact> userContacts;
    local array<string> designationSegments;

    // Check for and handle multiple designation segments.
    designationSegments = class'SpaceGameplayInterfaceConcreteBaseBase'.static.splitString(designation, "<");
    if (designationSegments.length > 1) {
      return getContactsForMultipleDesignationSegments(designationSegments);
    }
    
    // Get results from the mediator, interface, and user.
    if (userInterface != none)
      interfaceContacts = userInterface.getContactsForDesignation(self, designation);
    if (playerUser != none)
      userContacts = playerUser.getContactsForDesignation(designation);
    
    // Combine all the results into one results array.
    for (i=0;i<interfaceContacts.length;i++)
      result[result.length] = interfaceContacts[i];
    for (i=0;i<userContacts.length;i++)
      result[result.length] = userContacts[i];
      
    // Return results.
    return result;
  }
  
  simulated function array<Contact> getContactsForMultipleDesignationSegments(array<string> designationSegments) {
    local int i;
    local array<Contact> result;
    
    result = getContactsForDesignation(designationSegments[designationSegments.length-1]);
    for (i=designationSegments.length-2;i>=0;i--) {
      result = filterContactsForDesignation(designationSegments[i], result);
    }
    
    return result;
  }
  
  simulated function issueManualOrders(array<SpaceWorker> Orderees, class<SpaceTask> Task_Class, object New_Target) {
    if (BaseUser(playerUser) != none)
      BaseUser(playerUser).issue_manual_orders(orderees, task_class, new_target);
  }

  simulated function scuttleWorkers(array<SpaceWorker> workers) {
    if (BaseUser(playerUser) != none)
      BaseUser(playerUser).scuttleWorkers(workers);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
  
  simulated function gainedContact(Contact contact) {
    if (userInterface != none)
      userInterface.gainedContact(contact);
  }

  simulated function lostContact(Contact contact) {
    if (userInterface != none)
      userInterface.lostContact(contact);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function SectorPresence getSectorPresenceForSector(Sector other) {
    if (playerUser != none)
      return playerUser.getSectorPresenceForSector(other);
    else
      return none;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function userOrderFailed(string reason) {
    if (userInterface != none)
      userInterface.userOrderFailed(reason);
  }
  
  simulated function userOrderIssued(class<SpaceTask> orderClass) {
    if (userInterface != none)
      userInterface.userOrderIssued(orderClass);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cleanup() {
    setPlayerUser(none);

    if (userInterface != none) {
      userInterface.cleanup();
      userInterface = none;
    }
    
    super.cleanup();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************


defaultproperties
{
}