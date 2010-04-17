class UnrealEngineAdapterTests extends AutomatedTest;

simulated function runTests() {
  local UnrealEngineAdapter adapter;

  adapter = UnrealEngineAdapter(allocateObject(class'xTeamGameAdapter'));
  myAssert(adapter.getObjectAllocator() != none, "allocator exists");
  myAssert(adapter.getLogger() != none, "logger exists");
  myAssert(adapter.getClock() != none, "clock exists");
}