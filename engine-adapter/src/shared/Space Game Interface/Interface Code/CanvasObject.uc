class CanvasObject extends BaseObject;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function Font getConsoleFont();
simulated function Font getFont(int fontHeight);
simulated function Color getConsoleColor();

simulated function vector convertWorldPositionToCanvasPosition(vector worldPosition);
simulated function float convertWorldWidthToCanvasWidth(float distance, float worldWidth);

simulated function drawIcon(object Mat, float centerX, float centerY, float iconScale);
simulated function drawTile(object Mat, float XL, float YL, float U, float V, float UL, float VL);

simulated function drawScreenText(String text, float x, float y);
simulated function wrapStringToArray(string text, out array<string> result, float dx, optional string EOL);
simulated function setPos(float x, float y);

simulated function int getSizeX();
simulated function int getSizeY();

simulated function resetCanvas();

simulated function setFont(Font newFont);
simulated function setDrawColor(Color newDrawColor);

simulated function object getDefaultMaterial();

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}