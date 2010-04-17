class UnrealEngine3CanvasObject extends UnrealEngineCanvasObject;

var Color consoleColor;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function drawTile(object Mat, float XL, float YL, float U, float V, float UL, float VL) {
  local float oldX, oldY, newX, newY;
  local bool bRestorePosition;
  
  if (UL < 0) {
    U += UL;
    UL = abs(UL);
  }
  
  if (VL < 0) {
    V += VL;
    VL = abs(VL);
  }

  if (XL < 0 || YL < 0) {
    bRestorePosition = true;
    oldX = unrealCanvas.curX;
    oldY = unrealCanvas.curY;
    
    if (XL < 0) {
      newX = oldX + XL;
      XL = abs(XL);
    } else {
      newX = oldX;
    }

    if (YL < 0) {
      newY = oldY + YL;
      YL = abs(YL);
    } else {
      newY = oldY;
    }
    
    unrealCanvas.setPos(newX, newY);
  }
    

  unrealCanvas.drawTile(Texture2D(mat), XL, YL, U, V, UL, VL);
  
  if (bRestorePosition)
    unrealCanvas.setPos(oldX, oldY);
}

simulated function vector convertWorldPositionToCanvasPosition(vector worldPosition) {
  return unrealCanvas.project(worldPosition);
}

simulated function Font getFont(int fontHeight) {
  return getConsoleFont();
}

simulated function Font getConsoleFont() {
  return unrealCanvas.default.font;
}

simulated function Color getConsoleColor() {
  return consoleColor;
}

simulated function wrapStringToArray(string text, out array<string> result, float dx, optional string EOL) {
  parseStringIntoArray(text, result, EOL, true);
}

simulated function drawScreenText(String text, float x, float y) {
  setPosFractional(x, y);
  unrealCanvas.drawText(text);
}

simulated function setPosFractional(float x, float y) {
  setPos(x * getSizeX(), y * getSizeY());
}

simulated function object getDefaultMaterial() {
  return unrealCanvas.defaultTexture;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated static function float getGlobalDrawscaleFactor() {
  return default.globalWorldScale * default.globalDrawscale;
}

simulated static function float getGlobalPositionScaleFactor() {
  return default.globalWorldScale;
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}