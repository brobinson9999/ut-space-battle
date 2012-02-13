class BasicControlExtractingPlayerControllerAdapter extends PlayerControllerAdapter;

var private bool bWasFiring, bWasAltFiring;

simulated event playerTick(float deltaTime) {
  super.playerTick(deltaTime);

  inputView.rawInput(deltaTime, aBaseX, aBaseY, aBaseZ, aMouseX, aMouseY, aForward / 6000.0, aTurn, aStrafe / 6000.0, aUp / 6000.0, aLookUp);
  
  if (bFire == 0 && bWasFiring) {
    bWasFiring = false;
    inputView.fire(0);
  }

  if (bAltFire == 0 && bWasAltFiring) {
    bWasAltFiring = false;
    inputView.altFire(0);
  }
}

exec function prevWeapon() {
  if (level.pauser == none) {
    inputView.prevWeapon();
    super.prevWeapon();
  }
}

exec function nextWeapon() {
  if (level.pauser == none) {
    inputView.nextWeapon();
    super.nextWeapon();
  }
}

exec function switchWeapon(byte weaponGroupNumber) {
  inputView.switchWeapon(weaponGroupNumber);
  super.nextWeapon();
}

exec function prevItem() {
  if (level.pauser == none) {
    inputView.prevItem();
    super.prevItem();
  }
}

exec function activateItem() {
  if (level.pauser == none) {
    inputView.activateItem();
    super.activateItem();
  }
}

exec function fire(optional float f) {
  bWasFiring = true;
  inputView.fire(1);
  super.fire(f);
}

exec function altFire(optional float f) {
  bWasAltFiring = true;
  inputView.altFire(1);
  super.altFire(f);
}

exec function use() {
  inputView.use();
  super.use();
}

defaultproperties
{
  bCallParentPlayerTick=true
}