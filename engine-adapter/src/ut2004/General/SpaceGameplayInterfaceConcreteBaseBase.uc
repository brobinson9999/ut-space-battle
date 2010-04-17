class SpaceGameplayInterfaceConcreteBaseBase extends SpaceGameplayInterface;

var Material                graphic;

simulated function float materialXSize(Material other) {
  return other.materialUSize();
}

simulated function float materialYSize(Material other) {
  return other.materialVSize();
}

static simulated function array<String> splitString(coerce string inputString, coerce string delimiter) {
  local array<string> result;
  
  split(inputString, delimiter, result);
  
  return result;
}

defaultproperties
{
  graphic=Material'Engine.WhiteTexture'
}