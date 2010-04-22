class SpaceGameplayInterfaceConcreteBaseBase extends SpaceGameplayInterface;

var Material                graphic;

simulated function array<Material> loadShipSizeIcons() {
  local array<Material> result;
  
  result[result.length] = Material(dynamicLoadObject("interfaceContent.Menu.arrowBlueDown", class'Material'));
  result[result.length] = Material(dynamicLoadObject("interfaceContent.Menu.arrowBlueRight", class'Material'));
  result[result.length] = Material(dynamicLoadObject("interfaceContent.Menu.arrowBlueLeft", class'Material'));
  result[result.length] = Material(dynamicLoadObject("interfaceContent.Menu.arrowBlueUp", class'Material'));
  result[result.length] = Material(dynamicLoadObject("interfaceContent.Menu.arrowDown", class'Material'));
  result[result.length] = Material(dynamicLoadObject("interfaceContent.Menu.arrowRight", class'Material'));
  result[result.length] = Material(dynamicLoadObject("interfaceContent.Menu.arrowLeft", class'Material'));
  result[result.length] = Material(dynamicLoadObject("interfaceContent.Menu.arrowUp", class'Material'));
  
  return result;
}

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