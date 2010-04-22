class DrunkenProjectileRenderable extends MovingProjectileRenderable;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  var float drunkenMagnitudeMax;
  var float drunkenMagnitudeMin;
  var int drunkenRateMax;
  var int drunkenRateMin;

  var float drunkenYMagnitude;
  var float drunkenZMagnitude;
  var float drunkenYMagnitude2;
  var float drunkenZMagnitude2;
  var int drunkenYOscillations;
  var int drunkenZOscillations;
  var int drunkenYOscillations2;
  var int drunkenZOscillations2;

  var float startTime;
  var float travelTime;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
  
  simulated function float FRandRange(float LowerBound, float UpperBound)
  {
    return (FRand() * (UpperBound-LowerBound)) + LowerBound;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function float randomSign(float in)
  {
    if (FRand() < 0.5)
      return -in;
    else
      return in;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // Set drawtype and other rendering parameters.
  simulated function initialize()
  {
    local float distance;
    
    super.initialize();
    
    if (drunkenRateMin > 0 && drunkenRateMax > 0)
    {
      distance = VSize(projectile.endLocation - projectile.startLocation);

      drunkenZMagnitude = 0.5 * randomSign(FRandRange(drunkenMagnitudeMin, drunkenMagnitudeMax));
      drunkenYMagnitude = 0.5 * randomSign(FRandRange(drunkenMagnitudeMin, drunkenMagnitudeMax));
      drunkenZMagnitude2 = 0.5 * randomSign(FRandRange(drunkenMagnitudeMin, drunkenMagnitudeMax));
      drunkenYMagnitude2 = 0.5 * randomSign(FRandRange(drunkenMagnitudeMin, drunkenMagnitudeMax));
      drunkenZOscillations = (distance / FRandRange(drunkenRateMin, drunkenRateMax)) + 0.5;
      drunkenYOscillations = (distance / FRandRange(drunkenRateMin, drunkenRateMax)) + 0.5;
      drunkenZOscillations2 = (distance / FRandRange(drunkenRateMin, drunkenRateMax)) + 0.5;
      drunkenYOscillations2 = (distance / FRandRange(drunkenRateMin, drunkenRateMax)) + 0.5;
    }
    
    startTime = getLevel().timeSeconds;
    travelTime = FMax(0.1,(projectile.endTime - projectile.startTime));
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function setWorldLocation(vector newWorldLocation) {
    local vector drunkenVectorOffset;
    local float travelAngle;
    local vector newLocation;

    worldLocation = newWorldLocation;

    if (travelTime != 0) {
      travelAngle = 2 * PI * ((getLevel().timeSeconds - startTime) / travelTime);
      drunkenVectorOffset.Y = drunkenYMagnitude * sin(travelAngle * drunkenYOscillations);
      drunkenVectorOffset.Z = drunkenZMagnitude * sin(travelAngle * drunkenZOscillations);
      drunkenVectorOffset.Y += drunkenYMagnitude2 * sin(travelAngle * drunkenYOscillations2);
      drunkenVectorOffset.Z += drunkenZMagnitude2 * sin(travelAngle * drunkenZOscillations2);
    }

    newLocation = worldLocation;
    newLocation += drunkenVectorOffset CoordRot rotation;

    setLocation(newLocation * getGlobalPositionScaleFactor());
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}
