class ExplicitUserForeignPolicyTests extends AutomatedTest;

simulated function runTests() {
  local ExplicitUserForeignPolicy policy;
  local User userA, userB;

  policy = ExplicitUserForeignPolicy(allocateObject(class'ExplicitUserForeignPolicy'));
  userA = User(allocateObject(class'User'));
  userB = User(allocateObject(class'User'));

  myAssert(!policy.isFriendly(userB, userA), "not initially friendly");
  myAssert(!policy.isHostile(userB, userA), "not initially hostile");

  policy.setHostile(userB, userA);
  myAssert(policy.isHostile(userB, userA), "now hostile");
  myAssert(!policy.isFriendly(userB, userA), "not friendly while hostile");
  myAssert(!policy.isHostile(userB, userB), "hostility to userA does not imply hostility toward userB");
  myAssert(!policy.isHostile(userA, userB), "hostility need not be reciprocal");

  policy.setFriendly(userB, userA);
  myAssert(policy.isFriendly(userB, userA), "now friendly");
  myAssert(!policy.isHostile(userB, userA), "setting friendly implies no longer hostile");

  policy.clearDiplomaticStatus(userB, userA);
  myAssert(!policy.isFriendly(userB, userA), "after clearing, no longer friendly");
  
  policy.cleanup();
  userA.cleanup();
  userB.cleanup();
}