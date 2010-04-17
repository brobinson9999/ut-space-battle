class InputDriver extends Interaction;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var InputView View;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function InitializeInputDriver()
  {
    // Assign Delegates.
    OnReceivedNativeInputKey = KeyEvent;
    OnReceivedNativeInputAxis = AxisEvent;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool AxisEvent(int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad)
  {
    return KeyEvent(ControllerId, Key, IE_Axis, Delta, bGamepad);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool KeyEvent( int ControllerId, name Key, EInputEvent EventType, optional float AmountDepressed=1.f, optional bool bGamepad )
  {
    local string KeyMapped;
    local string ActionMapped;
    local bool bHandled;
    
    // Map Key and Action.
    KeyMapped = MapKey(Key);
    ActionMapped = MapEventType(EventType);

    // If there are multiple controllers, each should have it's own view - only handling one for now though.
    if (View != None)
      bHandled = View.KeyEvent(KeyMapped, ActionMapped, AmountDepressed);
    else
      bHandled = false;

    // Some keys should always return true for handling.
    // For now, this includes only mouse x and y, so the camera is not moved externally.
    if (KeyMapped == "IK_MouseX" || KeyMapped == "IK_MouseY")
      return true;
      
    // Some keys should always return false for handling.
    // For now, this includes left mouse click so you can still use it to respawn.
    if (KeyMapped == "IK_LeftMouse")
      return false;
      
    // Return result.
    return bHandled;
  }
  
  simulated function string MapEventType(EInputEvent EventType)
  {
    switch (EventType)
    {
      case IE_Repeat:   return "IST_Hold";
      case IE_Pressed:  return "IST_Press";
      case IE_Released: return "IST_Release";
      case IE_Axis:     return "IST_Axis";
    }
    
    return String(EventType);
  }

  simulated function string MapKey(name Key)
  {
    switch (Key)
    {
      case 'one':               return "IK_1";
      case 'two':               return "IK_2";
      case 'three':             return "IK_3";
      case 'four':              return "IK_4";
      case 'five':              return "IK_5";
      case 'six':               return "IK_6";
      case 'seven':             return "IK_7";
      case 'eight':             return "IK_8";
      case 'nine':              return "IK_9";
      case 'zero':              return "IK_0";
      case 'LeftMouseButton':   return "IK_LeftMouse";
      case 'RightMouseButton':  return "IK_RightMouse";
      case 'MiddleMouseButton': return "IK_MiddleMouse";
      case 'MouseScrollUp':     return "IK_MouseWheelUp";
      case 'MouseScrollDown':   return "IK_MouseWheelDown";
    }
    
    return "IK_"$String(Key);
//    return String(Key);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

	simulated function Cleanup()
	{
		View = None;
		
		// Not necessary in UT3?
//		Master.RemoveInteraction(Self);
	}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}