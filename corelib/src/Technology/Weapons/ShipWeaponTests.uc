class ShipWeaponTests extends AutomatedTest;

simulated function runTests() {
  myAssert(class'ShipWeapon'.static.getBestFireDirection(vect(1,0,0), vect(1,0,0), 0) == vect(1,0,0), "basic case");
  myAssert(class'ShipWeapon'.static.getBestFireDirection(vect(0,1,0), vect(1,0,0), 0) == vect(1,0,0), "zero fire arc gives back the center of the arc");
  myAssert(class'ShipWeapon'.static.getBestFireDirection(vect(2,0,0), vect(1,0,0), 32768) == vect(1,0,0), "output should be normalized");
  myAssert(class'ShipWeapon'.static.getBestFireDirection(vect(0,1,0), vect(1,0,0), 8192) == normal(vect(1,1,0)), "output should max out at fire arc angle");
  myAssert(class'ShipWeapon'.static.getBestFireDirection(vect(0,1,0), vect(1,0,0), 16384) == normal(vect(0,1,0)), "no change within acceptable arc");
}