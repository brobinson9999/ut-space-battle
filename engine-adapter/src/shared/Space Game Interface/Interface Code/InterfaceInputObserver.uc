class InterfaceInputObserver extends InputObserver;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var SpaceGameplayInterface Interface;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool KeyEvent(string Key, string Action, float Delta)
  {
    return Interface.KeyEvent(Key, Action, Delta);
  }

  simulated function Cleanup()
  {
    Interface = None;
    
    Super.Cleanup();
  }

// (gen-proxy "rawInput" "interface" ((:NAME "deltaTime" :TYPE "float") (:NAME "aBaseX" :TYPE "float") (:NAME "aBaseY" :TYPE "float") (:NAME "aBaseZ" :TYPE "float") (:NAME "aMouseX" :TYPE "float") (:NAME "aMouseY" :TYPE "float") (:NAME "aForward" :TYPE "float") (:NAME "aTurn" :TYPE "float") (:NAME "aStrafe" :TYPE "float") (:NAME "aUp" :TYPE "float") (:NAME "aLookUp" :TYPE "float")))
simulated function rawInput(float deltaTime, float aBaseX, float aBaseY, float aBaseZ, float aMouseX, float aMouseY, float aForward, float aTurn, float aStrafe, float aUp, float aLookUp) {
  interface.rawInput(deltaTime, aBaseX, aBaseY, aBaseZ, aMouseX, aMouseY, aForward, aTurn, aStrafe, aUp, aLookUp);
}

// (gen-proxy "prevWeapon" "interface" NIL)
simulated function prevWeapon() {
  interface.prevWeapon();
}

// (gen-proxy "nextWeapon" "interface" NIL)
simulated function nextWeapon() {
  interface.nextWeapon();
}

// (gen-proxy "switchWeapon" "interface" ((:NAME "weaponGroupNumber" :TYPE "byte")))
simulated function switchWeapon(byte weaponGroupNumber) {
  interface.switchWeapon(weaponGroupNumber);
}

// (gen-proxy "prevItem" "interface" NIL)
simulated function prevItem() {
  interface.prevItem();
}

// (gen-proxy "activateItem" "interface" NIL)
simulated function activateItem() {
  interface.activateItem();
}

// (gen-proxy "fire" "interface" ((:NAME "f" :TYPE "float")))
simulated function fire(float f) {
  interface.fire(f);
}

// (gen-proxy "altFire" "interface" ((:NAME "f" :TYPE "float")))
simulated function altFire(float f) {
  interface.altFire(f);
}

// (gen-proxy "use" "interface" NIL)
simulated function use() {
  interface.use();
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}