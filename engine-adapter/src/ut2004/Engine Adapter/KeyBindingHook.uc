class KeyBindingHook extends GUIUserKeyBinding;
// Make this config if possible... not sure if I can do that though since KeyData is already declared.
 
defaultproperties
{
  KeyData[0]=(KeyLabel="UT Space Battle Camera",bIsSection=True)
  KeyData[1]=(KeyLabel="Chase Camera",Alias="gl set_camera behindview|gl set_relative_controls 0|gl set_strategic_controls 0")
  KeyData[2]=(KeyLabel="Free Camera",Alias="gl set_camera strategic|gl set_relative_controls 0|gl set_strategic_controls 1")
  KeyData[3]=(KeyLabel="Pilot Camera",Alias="gl set_camera pilot|gl set_relative_controls 1|gl set_strategic_controls 0")
  KeyData[4]=(KeyLabel="Chase Camera",Alias="gl set_camera chase|gl set_relative_controls 0|gl set_strategic_controls 0")
  KeyData[5]=(KeyLabel="Increase Free Camera Distance",Alias="gl strategic_camera_distance_delta 50")
  KeyData[6]=(KeyLabel="Decrease Free Camera Distance",Alias="gl strategic_camera_distance_delta -50")
  KeyData[7]=(KeyLabel="Tactical Overview (Hold)",Alias="gl multiplyStrategicCameraDistance 100|onrelease gl multiplyStrategicCameraDistance 0.01")
  KeyData[8]=(KeyLabel="Free Camera Pan +X",Alias="gl strategicCameraPanX 10000|onrelease gl strategicCameraPanX 0")
  KeyData[9]=(KeyLabel="Free Camera Pan -X",Alias="gl strategicCameraPanX -10000|onrelease gl strategicCameraPanX 0")
  KeyData[10]=(KeyLabel="Free Camera Pan +Y",Alias="gl strategicCameraPanY 10000|onrelease gl strategicCameraPanY 0")
  KeyData[11]=(KeyLabel="Free Camera Pan -Y",Alias="gl strategicCameraPanY -10000|onrelease gl strategicCameraPanY 0")


  KeyData[12]=(KeyLabel="UT Space Battle HUD",bIsSection=True)
  KeyData[13]=(KeyLabel="Toggle Target Info Readout",Alias="gl set_hud_readout_delta 1")
  KeyData[14]=(KeyLabel="Toggle HUD",Alias="gl toggleRenderHUD")
  KeyData[15]=(KeyLabel="Toggle HUD Projectile Display",Alias="gl toggleRenderProjectilesOnHUD")
  KeyData[16]=(KeyLabel="Toggle Ship/Projectile Display",Alias="gl toggleRenderWorld")
  KeyData[17]=(KeyLabel="Toggle HUD Readouts",Alias="gl toggleShowAllHUDReadouts")

  KeyData[18]=(KeyLabel="UT Space Battle Ship Controls",bIsSection=True)
  KeyData[19]=(KeyLabel="Randomize Current Ship",Alias="gl randomize_player_ship|gl focus ps")
  KeyData[20]=(KeyLabel="Disable Autopilot",Alias="gl set_ai_control 0")
  KeyData[21]=(KeyLabel="Enable Autopilot",Alias="gl set_ai_control 1")
  KeyData[22]=(KeyLabel="Autopilot (Hold)",Alias="gl set_ai_control 1|onrelease gl set_ai_control 0")
  KeyData[23]=(KeyLabel="Fire Weapons",Alias="gl set_bFire 1|onrelease gl set_bFire 0|button bFire|onrelease requestRespawnAdapter")
  KeyData[24]=(KeyLabel="Increase Thrust",Alias="gl set_acceleration_delta 0.25")
  KeyData[25]=(KeyLabel="Decrease Thrust",Alias="gl set_acceleration_delta -0.25")
  KeyData[26]=(KeyLabel="100% Reverse Thrust",Alias="gl set_acceleration -1")
  KeyData[27]=(KeyLabel="75% Reverse Thrust",Alias="gl set_acceleration -0.75")
  KeyData[28]=(KeyLabel="50% Reverse Thrust",Alias="gl set_acceleration -0.5")
  KeyData[29]=(KeyLabel="25% Reverse Thrust",Alias="gl set_acceleration -0.25")
  KeyData[30]=(KeyLabel="Neutral Thrust",Alias="gl set_acceleration 0")
  KeyData[31]=(KeyLabel="25% Forward Thrust",Alias="gl set_acceleration 0.25")
  KeyData[32]=(KeyLabel="50% Forward Thrust",Alias="gl set_acceleration 0.5")
  KeyData[33]=(KeyLabel="75% Forward Thrust",Alias="gl set_acceleration 0.75")
  KeyData[34]=(KeyLabel="100% Forward Thrust",Alias="gl set_acceleration 1")
  KeyData[35]=(KeyLabel="Scuttle Current Ship",Alias="gl o ps scuttle")

  KeyData[36]=(KeyLabel="UT Space Battle Ship Selection",bIsSection=True)
  KeyData[37]=(KeyLabel="Select All Friendlies",Alias="gl set_friendly_targets owned<knownContactsInCameraSector")
  KeyData[38]=(KeyLabel="Select Current Ship",Alias="gl set_friendly_targets ps")
  KeyData[39]=(KeyLabel="Select Carrier",Alias="gl set_friendly_targets carrier")
  KeyData[40]=(KeyLabel="Select Fighters",Alias="gl set_friendly_targets reinforcements")

  KeyData[41]=(KeyLabel="UT Space Battle Selection Orders",bIsSection=True)
  KeyData[42]=(KeyLabel="Attack Target Near Center of Screen",Alias="gl o fts atk closestToCameraCenter<hostile<knownContactsInPlayerShipSector")
  KeyData[43]=(KeyLabel="Defend Player's Ship",Alias="gl o fts def ps")
  KeyData[44]=(KeyLabel="Attack Player's Primary Target",Alias="gl o fts atk pswt")
  KeyData[45]=(KeyLabel="Clear Standing Orders",Alias="gl o fts clr")

  KeyData[46]=(KeyLabel="UT Space Battle Miscellaneous",bIsSection=True)
  KeyData[47]=(KeyLabel="Change Fleet",Alias="gl setFleetDelta 1")
}