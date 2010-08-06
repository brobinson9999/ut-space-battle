class SpaceGameplayInterfaceConcreteBaseBase extends SpaceGameplayInterface;

var Texture2D graphic;

simulated function array<Material> loadShipSizeIcons() {
  local array<Material> result;
  
  result[result.length] = Material(dynamicLoadObject("Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay", class'Material'));
  result[result.length] = Material(dynamicLoadObject("Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay", class'Material'));
  result[result.length] = Material(dynamicLoadObject("Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay", class'Material'));
  result[result.length] = Material(dynamicLoadObject("Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay", class'Material'));
  result[result.length] = Material(dynamicLoadObject("Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay", class'Material'));
  result[result.length] = Material(dynamicLoadObject("Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay", class'Material'));
  result[result.length] = Material(dynamicLoadObject("Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay", class'Material'));
  result[result.length] = Material(dynamicLoadObject("Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay", class'Material'));
  
  return result;
}

simulated function float materialXSize(Texture2D other) {
  return other.sizeX;
}

simulated function float materialYSize(Texture2D other) {
  return other.sizeY;
}

static simulated function array<String> splitString(coerce string inputString, coerce string delimiter) {
  local array<string> result;
  
  parseStringIntoArray(inputString, result, delimiter, true);
  
  return result;
}

defaultproperties
{
  graphic=Texture2D'EngineResources.White'
}