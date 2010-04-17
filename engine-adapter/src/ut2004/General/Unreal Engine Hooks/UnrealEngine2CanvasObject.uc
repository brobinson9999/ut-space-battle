class UnrealEngine2CanvasObject extends UnrealEngineCanvasObject;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

var object defaultMaterial;

var float globalDrawscale;    // Global factor for the drawScale only.
var float globalWorldScale;   // Global factor for both drawScale and location.

var Font consoleFont;
var Color consoleColor;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function drawIcon(object materialObject, float centerX, float centerY, float iconScale) {
  local Material mat;
  local float matXSize;
  local float matYSize;
  local float iconXSize;
  local float iconYSize;
  
  mat = Material(materialObject);
  matXSize = mat.materialUSize();
  matYSize = mat.materialVSize();
  iconXSize = matXSize * iconScale;
  iconYSize = matYSize * iconScale;
  
  setPos(centerX - (iconXSize / 2), centerY - (iconYSize / 2));
  unrealCanvas.drawTile(mat, iconXSize, iconYSize, 0, 0, matXSize, matYSize);
}

simulated function drawTile(object Mat, float XL, float YL, float U, float V, float UL, float VL) {
  unrealCanvas.drawTile(Material(mat), XL, YL, U, V, UL, VL);
}

simulated function vector convertWorldPositionToCanvasPosition(vector worldPosition) {
  return unrealCanvas.worldToScreen(worldPosition * getGlobalPositionScaleFactor());
}

simulated function Font getFont(int fontHeight) {
  if (fontHeight >= 12)
    return getConsoleFont();
  else
    return unrealCanvas.tinyFont;
}

simulated function Font getConsoleFont() {
  return consoleFont;
}

simulated function Color getConsoleColor() {
  return consoleColor;
}

simulated function wrapStringToArray(string text, out array<string> result, float dx, optional string EOL) {
  unrealCanvas.wrapStringToArray(text, result, dx, EOL);
}

simulated function drawScreenText(String text, float x, float y) {
  local float backupAlpha;
  
  // Transparency on text results in invisible text.
  backupAlpha = unrealCanvas.drawColor.a;
  unrealCanvas.drawColor.a = 255;
  
  // bump text location slightly for consistency with UE3.
  y = ((y * getSizeY()) + 2) / getSizeY();
  
  unrealCanvas.drawScreenText(text, x, y, DP_UpperLeft);

  unrealCanvas.drawColor.a = backupAlpha;
}

simulated function object getDefaultMaterial() {
  return defaultMaterial;
}

simulated function cleanup() {
  consoleFont = none;
  
  super.cleanup();
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
  defaultMaterial=Texture'engine.WhiteSquareTexture'
  globalDrawscale=2.5
//  globalDrawscale=1
  globalWorldScale=0.5
//  globalWorldScale=0.1
}