class SpaceGameplayInterface extends BaseObject;

simulated function initializeInterface(UserInterfaceMediator mediator);
simulated function cycle(InputView inputView, float delta);
simulated function bool keyEvent(string key, string action, float delta);
simulated function rawInput(float deltaTime, float aBaseX, float aBaseY, float aBaseZ, float aMouseX, float aMouseY, float aForward, float aTurn, float aStrafe, float aUp, float aLookUp);
simulated function prevWeapon();
simulated function nextWeapon();
simulated function switchWeapon(byte weaponGroupNumber);
simulated function prevItem();
simulated function activateItem();
simulated function fire(float f);
simulated function altFire(float f);
simulated function use();

simulated function updateCamera();
simulated function vector getCameraLocation();
simulated function rotator getCameraRotation();

simulated function renderInterface(UserInterfaceMediator mediator, CanvasObject canvas);
simulated function bool receivedConsoleCommand(UserInterfaceMediator mediator, string command);

simulated function cameraShake(vector shakeOrigin, float shakeMagnitude);

simulated function array<Contact> getContactsForDesignation(UserInterfaceMediator mediator, string designation);
simulated function array<Contact> filterContactsForDesignation(UserInterfaceMediator mediator, string designation, array<Contact> inputContacts) {
  return inputContacts;
}

simulated function changeCameraSector(UserInterfaceMediator mediator, Sector newSector);

simulated function gainedContact(Contact contact);
simulated function lostContact(Contact contact);

simulated function userOrderFailed(string reason);
simulated function userOrderIssued(class<SpaceTask> orderClass);

simulated function respawnedPlayer(UserInterfaceMediator mediator);

simulated function notifyClearingPlayerUser(UserInterfaceMediator mediator);
simulated function notifySetPlayerUser(UserInterfaceMediator mediator);

defaultproperties
{
}