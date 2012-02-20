class InputView extends InputObserver;

// This class is an input observer which does some processing of input before passing it off to it's own observers.

var bool bDebugUnboundKeys;
var array<vector> joysticks;
  
var array<InputObserver> observers;

simulated function addObserver(InputObserver other) {
  observers[observers.length] = other;
}

simulated function bool removeObserver(InputObserver other) {
  local int i;

  for (i=0;i<observers.length;i++) {
    if (observers[i] == other) {
      observers.remove(i,1);
      return true;
    }
  }

  return false;
}

simulated function cleanup()
{
  while (observers.length > 0)
    removeObserver(observers[0]);

  super.cleanup();
}

simulated function bool keyEvent(string key, string action, float delta)
{
  local int i;

  if (action == "IST_Hold") return false;
  if (action == "IST_Press") delta = 1;
  if (action == "IST_Release") delta = 0;

  // X/Y reversal.
  if (key == "IK_JoyX")
    joysticks[0].y = delta;

  if (key == "IK_JoyY")
    joysticks[0].x = -delta;

  if (key == "IK_JoyV")
    joysticks[1].x = delta;

  if (key == "IK_JoyZ")
    joysticks[1].y = -delta;

  for (i=0;i<observers.length;i++)
    if (observers[i].keyEvent(key, action, delta))
      return true;

  if (bDebugUnboundKeys)
    errorMessage("InputView.KeyEvent("$key$", "$action$", "$delta$")");

  return false;
}

// (gen-composite "rawInput" ((:NAME "deltaTime" :TYPE "float") (:NAME "aBaseX" :TYPE "float") (:NAME "aBaseY" :TYPE "float") (:NAME "aBaseZ" :TYPE "float") (:NAME "aMouseX" :TYPE "float") (:NAME "aMouseY" :TYPE "float") (:NAME "aForward" :TYPE "float") (:NAME "aTurn" :TYPE "float") (:NAME "aStrafe" :TYPE "float") (:NAME "aUp" :TYPE "float") (:NAME "aLookUp" :TYPE "float")))
simulated function rawInput(float deltaTime, float aBaseX, float aBaseY, float aBaseZ, float aMouseX, float aMouseY, float aForward, float aTurn, float aStrafe, float aUp, float aLookUp) {
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].rawInput(deltaTime, aBaseX, aBaseY, aBaseZ, aMouseX, aMouseY, aForward, aTurn, aStrafe, aUp, aLookUp);
}

// (gen-composite "prevWeapon" NIL)
simulated function prevWeapon() {
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].prevWeapon();
}

// (gen-composite "nextWeapon" NIL)
simulated function nextWeapon() {
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].nextWeapon();
}

// (gen-composite "switchWeapon" ((:NAME "weaponGroupNumber" :TYPE "byte")))
simulated function switchWeapon(byte weaponGroupNumber) {
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].switchWeapon(weaponGroupNumber);
}

// (gen-composite "prevItem" NIL)
simulated function prevItem() {
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].prevItem();
}

// (gen-composite "activateItem" NIL)
simulated function activateItem() {
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].activateItem();
}

// (gen-composite "fire" ((:NAME "f" :TYPE "float")))
simulated function fire(float f) {
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].fire(f);
}

// (gen-composite "altFire" ((:NAME "f" :TYPE "float")))
simulated function altFire(float f) {
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].altFire(f);
}

// (gen-composite "use" NIL)
simulated function use() {
  local int i;

  for (i=0;i<observers.length;i++)
    observers[i].use();
}

defaultproperties
{
  Joysticks(0)=()
  Joysticks(1)=()
}