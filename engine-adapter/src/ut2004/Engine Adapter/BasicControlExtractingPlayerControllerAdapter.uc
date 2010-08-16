class BasicControlExtractingPlayerControllerAdapter extends PlayerControllerAdapter;

simulated event playerTick(float deltaTime) {
  super.playerTick(deltaTime);

  log("Player Input: fwd: "$(aForward / 6000.0)$" strafe: "$(aStrafe / 6000.0)$" up: "$(aUp / 6000.0)$" yaw: "$aTurn$" pitch: "$aLookUp);
  inputView.rawInput(deltaTime, aBaseX, aBaseY, aBaseZ, aMouseX, aMouseY, aForward / 6000.0, aTurn, aStrafe / 6000.0, aUp / 6000.0, aLookUp);
}

defaultproperties
{
  bCallParentPlayerTick=true
}