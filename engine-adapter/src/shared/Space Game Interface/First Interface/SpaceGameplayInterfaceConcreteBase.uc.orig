class SpaceGameplayInterfaceConcreteBase extends SpaceGameplayInterfaceConcreteBaseBase;

var UnrealEngineAdapter engineAdapter;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ** Controls.

  var bool                                    bFire;
  var float                                   manualAcceleration;

  var float                                   freeFlightInertialCompensationFactor;

  var float                                   joyAimSensitivity;

  var bool                                    bAIControl;

  var Ship                                    playerShip;
  var Contact                                 playerShipContact;
  var SpaceWorker_Ship                        playerWorker;
  var PlayerShipObserver                      playerShipObserver;

  var Contact                                 pointOfInterestContact;

  var array<SpaceWorker_Ship>                 friendlyTargetWorkers;
  var array<Contact>                          friendlyTargetContacts;

  var bool                                    bStrategicControls;

  var bool                                    bRelativeJoystickControls;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ** HUD.

  var int                                     HUDReadoutType;
  const HUD_Min                                 = 0;
  const HUD_None                                = 0;
  const HUD_Physics                             = 1;
  const HUD_Sensors                             = 2;
  const HUD_ShipID                              = 3;
  const HUD_ContactID                           = 4;
  const HUD_Max                                 = 4;

  var int                                     genericBarsY;

  var bool                                    bRenderHUD;
  var bool                                    bRenderProjectilesOnHUD;
  var bool                                    bRenderWorld;

  var bool                                    bShowHUDReadoutsForAllContacts;

  var Color                                   reticleColorFriendly;
  var Color                                   reticleColorHostile;
  var Color                                   reticleColorNeutral;

  var Color                                   reticleColorTargeted;
  var Color                                   reticleColorFriendlyTargeted;

  var Color                                   barColorParts;
  var Color                                   barColorEnemyParts;

  var array<Material>                         shipSizeIcons;
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ** Camera.
  
  // Camera Positioning.
  var Sector                                  cameraSector;
  var vector                                  cameraLocation;
  var rotator                                 cameraRotation;

  var CameraStrategy                          cameraStrategy;
  var array<CameraStrategy>                   cameraStrategies;
  
  var FixedRelativePositionCameraStrategy     behindViewCameraStrategy;
  var FixedRelativePositionCameraStrategy     pilotCameraStrategy;
  var StrategicCameraStrategy                 strategicCameraStrategy;
  var ChaseCameraStrategy                     chaseCameraStrategy;

  var Contact                                 strategicCameraFocusContact;

  var float                                   strategicCameraSensitivity;
  var vector                                  strategicCameraPanSpeed;

  var float                                   cameraShakeMagnitude;
  var private SpaceGameplayInterfaceCameraShaker cameraShaker;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function SpaceGameplayInterfaceCameraShaker getCameraShaker() {
    if (cameraShaker == none) {
      cameraShaker = SpaceGameplayInterfaceCameraShaker(allocateObject(class'SpaceGameplayInterfaceCameraShaker'));
      cameraShaker.sgi = self;
    }
      
    return cameraShaker;
  }
  
  simulated function int getStatusAreaWidth(CanvasObject canvas) {
    return (canvas.getSizeX() * 0.35);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function renderInterface(UserInterfaceMediator mediator, CanvasObject canvas) {
    local Contact target;
    local int i;
    
    local SectorPresence sectorPresence;

    local color bracketColor;
    local float aimAccuracy;
    
    local int targetCurrentCondition;
    local int targetOptimalCondition;
    
    local vector leadInPosition;
    local vector leadInDelta;

    local SpaceWorker_Ship playerShipWorker;
    
    myAssert(playerShip == none || !playerShip.bCleanedUp, "SpaceGameplayInterfaceConcreteBase playerShip != none but playerShip.bCleanedUp");

    // Abort if not rendering the HUD.
    if (!bRenderHUD)
      return;
      
    // Abort if camera is not in any sector.
    if (cameraSector == none)
      return;

    // Reset the "bar stack".
    genericBarsY = canvas.getSizeY() - 10;

    // Draw reticles for contacts.    
    sectorPresence = mediator.getSectorPresenceForSector(cameraSector);
    if (sectorPresence != none) {
      for (i=0;i<sectorPresence.knownContacts.length;i++)
        drawContactOverlays(sectorPresence.knownContacts[i], canvas);
    }

    if (playerShip != none) {
      // Show own health.
      draw_Segmented_Bar(canvas, PartShip(playerShip).numPartsOnline, PartShip(playerShip).parts.length, barColorParts);
      canvas.setDrawColor(reticleColorFriendly);
      drawStatusMessage(canvas, "System Status");
      
      // Show Desired Rotation Marker.
      aimAccuracy = abs(acos(vector(playerShip.rotation) dot vector(playerShip.desiredRotation))) / (PI);
      aimAccuracy = aimAccuracy ** 0.1;
      aimAccuracy = (2 - aimAccuracy) * 0.5;
      if (!(aimAccuracy > 0))
        aimAccuracy = 1;
//      aimAccuracy *= abs(aimAccuracy);

      bracketColor = reticleColorFriendlyTargeted;
      bracketColor.R = bracketColor.R * aimAccuracy;
      bracketColor.G = bracketColor.G * aimAccuracy;
      bracketColor.B = bracketColor.B * aimAccuracy;
      canvas.setDrawColor(bracketColor);
      drawBracketString(canvas, playerShip.getShipLocation(), vector(playerShip.desiredRotation), 5, playerShip.radius * 0.1, 1, playerShip.radius * 7.5, playerShip.radius * 5);
      
      // Show Heading Indicators.
      bracketColor = reticleColorFriendly;
      bracketColor.R = bracketColor.R * aimAccuracy;
      bracketColor.G = bracketColor.G * aimAccuracy;
      bracketColor.B = bracketColor.B * aimAccuracy;

      canvas.setDrawColor(bracketColor);
      drawBracketString(canvas, playerShip.getShipLocation(), vector(playerShip.rotation), 10, playerShip.radius * 0.25, 1, playerShip.radius * 5, playerShip.radius * 5);

      playerShipWorker = playerShip.getShipWorker();
      if (playerShipWorker != none) {
        // Show lead in.
        if (playerShipWorker.mainWeaponsTarget != none && AIPilot(playerShip.pilot).hasFixedWeapons(playerShip)) {
          leadInPosition = AIPilot(playerShip.pilot).AM_Intercept_Calculate_Lead_In(playerShipWorker.mainWeaponsTarget.getContactLocation(), playerShipWorker.mainWeaponsTarget.getContactVelocity(), AIPilot(playerShip.pilot).projectileSpeed());
          leadInDelta = leadInPosition - playerShipWorker.mainWeaponsTarget.getContactLocation();

          canvas.setDrawColor(reticleColorHostile);
          drawBracketString(canvas, playerShipWorker.mainWeaponsTarget.getContactLocation(), normal(leadInDelta), 9, 5, 1, vsize(leadInDelta) * 0.5, vsize(leadInDelta) * 0.1);
        }

        // Render Hostile Health Bar.
        target = playerShipWorker.mainWeaponsTarget;
        if (target != none) {
          target.estimateTargetCondition(targetCurrentCondition, targetOptimalCondition);
          draw_Segmented_Bar(canvas, targetCurrentCondition, targetOptimalCondition, barColorEnemyParts);
          canvas.setDrawColor(barColorEnemyParts);
          drawStatusMessage(canvas, "Primary Target: "$getTextDescriptionForContact(target));
        }
      }

      // show weapons
      renderWeaponsStatus(mediator, canvas);
    }
    
    if (bRenderProjectilesOnHUD) {
      for (i=0;i<cameraSector.projectiles.length;i++) {
        drawProjectile(canvas, cameraSector.projectiles[i]);
      }
    }
  }

  simulated function renderWeaponsStatus(UserInterfaceMediator mediator, CanvasObject canvas) {
    local int i;
    
    for (i=0;i<playerShip.weapons.length;i++)
      renderWeaponStatus(mediator, canvas, playership.weapons[i]);
  }
  
  simulated function renderWeaponStatus(UserInterfaceMediator mediator, CanvasObject canvas, ShipWeapon weapon) {
    local Contact weaponTarget;
    local int segments;
      
    segments = 100;
    
    if (weapon.worker != none && weapon.worker.currentTask != none)
      weaponTarget = weapon.worker.currentTask.target;

    if (weaponTarget != none) {
      draw_Segmented_Bar(canvas, weapon.estimated_Accuracy_Against(weaponTarget, 0) * segments, segments, reticleColorTargeted);
    } else {
      draw_Segmented_Bar(canvas, 0, segments, reticleColorTargeted);
    }

    if (weapon.localTechnology.burstSize > 1) {
      weapon.updateBurstCounter();
      draw_Segmented_Bar(canvas, (weapon.localTechnology.burstSize - weapon.burstCounter), weapon.localTechnology.burstSize, barColorEnemyParts);
    } else if (weapon.nextFireTime() <= getCurrentTime())
      draw_Segmented_Bar(canvas, 1, 1, barColorEnemyParts);
    else
      draw_Segmented_Bar(canvas, 0, 1, barColorEnemyParts);

    if (!weapon.bOnline) {
      canvas.setDrawColor(getGreyColor());
      drawStatusMessage(canvas, weapon.localTechnology.friendlyName$": Offline");
    } else if (weaponTarget != none) {
      canvas.setDrawColor(reticleColorTargeted);
      drawStatusMessage(canvas, weapon.localTechnology.friendlyName$": "$getTextDescriptionForContact(weaponTarget));
    } else {
      canvas.setDrawColor(getGreyColor());
      drawStatusMessage(canvas, weapon.localTechnology.friendlyName$": No Target");
    }
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function drawBracketString(CanvasObject canvas, vector basePosition, vector direction, int bracketCount, float bracketSize, int bracketThickness, float initialOffset, float iterationOffset)
  {
    local int i;
    local vector bracketPosition;
    local vector bracketOffset;
    local float offsetDistance;
    
    for (i=0;i<bracketCount;i++)
    {
      offsetDistance = initialOffset + (i * iterationOffset);
      bracketOffset = Normal(direction) * offsetDistance;
      bracketPosition = basePosition + bracketOffset;
      drawReticle_PositionRadius(canvas, bracketPosition, bracketSize, bracketThickness, false);
    }
  }
  
  simulated function drawProjectile(CanvasObject canvas, WeaponProjectile projectile)
  {
    local vector worldLocation;
    
    if (projectile != none) {
      worldLocation = projectile.getProjectileLocation();

      canvas.setDrawColor(barColorParts);
      drawReticle_PositionRadius(canvas, worldLocation, sqrt(projectile.damage) * 10, 1, false);
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function draw_Generic_Bar(CanvasObject canvas, float CurrentValue, float MaxValue, Color DrawColor)
  {
    local int BarLength;
    
    BarLength = (CurrentValue / MaxValue) * getStatusAreaWidth(canvas);

    canvas.setDrawColor(DrawColor);

    canvas.SetPos((canvas.getSizeX() - 10) - BarLength, genericBarsY);
    DrawLine(canvas, 3, BarLength, 2);
    genericBarsY -= 3;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function draw_Segmented_Bar(CanvasObject canvas, float currentValue, float maxValue, Color drawColor)
  {
    local int i;
    local int segments;
    local int maxSegments;

    local int padCount;
    
    local float padLength;
    local float totalPadLength;
    local float drawSegmentLength;
    local float totalSegmentLength;

    local Color greyColor;
    local float startDrawX;
 
    segments = currentValue;
    maxSegments = maxValue;
  
    if (maxSegments > 0) {
      greyColor = getGreyColor();

      // there are maxSegments visible segments, and maxSegments - 1 pads. 
      totalSegmentLength = getStatusAreaWidth(canvas);

      padCount = maxSegments - 1;
      if (padCount > 0) {
        totalPadLength = totalSegmentLength;
        totalPadLength = ((totalPadLength/maxSegments) ** 0.3333) * maxSegments;
        padLength = totalPadLength / padCount;
      }
      
      drawSegmentLength = (totalSegmentLength - totalPadLength) / maxSegments;

      for (i=0;i<maxSegments;i++)
      {
        if (i<segments)
          canvas.setDrawColor(drawColor);
        else
          canvas.setDrawColor(greyColor);

        startDrawX = (drawSegmentLength * (i+1)) + (padLength * i);
        canvas.SetPos((canvas.getSizeX() - 10) - startDrawX, genericBarsY);
        drawLine(canvas, 3, drawSegmentLength, 2);
      }
    }
    
    genericBarsY -= 3;
  }

  simulated function Color getGreyColor() {
    local Color result;
    
    result.R = 128;
    result.G = 128;
    result.B = 128;
    result.A = 255;

    return result;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function drawStatusMessage(CanvasObject canvas, string messageText) {
    local float xStart, yStart;
    local int fontHeight;
    
    fontHeight = 7;
    genericBarsY -= fontHeight;

    canvas.setFont(canvas.getFont(fontHeight));
    xStart = (canvas.getSizeX() - 10) -  getStatusAreaWidth(canvas);
    
    // tweaked for UT3 - seems they may be drawing with different pivots.
    yStart = genericBarsY - (fontHeight/2);
//    yStart = genericBarsY;

    canvas.drawScreenText(messageText, xStart / canvas.getSizeX(), yStart / canvas.getSizeY());

    genericBarsY -= 3;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Color alphaModColor(Color baseColor, float alphaMod)
  {
    baseColor.a *= alphaMod;
    return baseColor;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool isWorldPositionOffCamera(CanvasObject canvas, vector worldPosition) {
    // Check to see if the dot product of unit-length vectors is greater than the cos of the FOV. Assuming 90 degree FOV for now.
    if (!(Vector(cameraRotation) Dot Normal(worldPosition - cameraLocation) > 0.707106))
      return true;
    else
      return false;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // Gets the screen position for a world position. If it is behind the camera, it returns a position along the edge of the screen "closest"
  // to the direction the world position is in.
  simulated function vector convertWorldPositionToCanvasPosition_BehindEdge(CanvasObject canvas, vector worldPosition) {
    local vector screenPosition;
    local int canvasXSize, canvasYSize;
    local float scaleFactor;

    // Get the initial screen position - could be behind the camera.
    screenPosition = canvas.convertWorldPositionToCanvasPosition(worldPosition);
    screenPosition.z = 0;
    
    if (isWorldPositionOffCamera(canvas, worldPosition)) {
      canvasXSize = canvas.getSizeX();  
      canvasYSize = canvas.getSizeY();
      
      screenPosition = normal(screenPosition);
      
      // avoid division by zero.
      if (abs(screenPosition.x) < 0.0001) screenPosition.x = 0.0001;
      if (abs(screenPosition.y) < 0.0001) screenPosition.y = 0.0001;
      
      scaleFactor = FMin(abs(float(canvasXSize) / screenPosition.x), abs(float(canvasYSize) / screenPosition.y)) / 2;
        
      screenPosition *= scaleFactor;
      
      screenPosition.x += canvasXSize / 2;
      screenPosition.y += canvasYSize / 2;
    }
    
    return screenPosition;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
  
  simulated function drawContactOverlays(Contact target, CanvasObject canvas)
  {
    drawReticle_Contact(target, canvas);
    drawContactIcon(target, canvas);
  }

  simulated function drawContactIcon(Contact target, CanvasObject canvas)
  {
    local float alphaMod;
    local vector locationDiff;
    local vector contactLocation;
    
    local float iconSize;
    local Color iconColor;
    local vector screenPosition;

    local float targetRadius;
    local float targetScreenWidth;
    
    contactLocation = target.getContactLocation();
    locationDiff = contactLocation - cameraLocation;
    targetRadius = target.estimateContactRadius();
    targetScreenWidth = canvas.convertWorldWidthToCanvasWidth(vSize(locationDiff), targetRadius);

    iconSize = sqrt(targetScreenWidth * 0.2) * 5;
    
    alphaMod = FMax((vsize(locationDiff) - 25000) / 50000, 0);

    if (alphaMod <= 0.001)
      return;
    
    if (target.isFriendly()) {
      iconColor = alphaModColor(reticleColorFriendly, alphaMod);
    } else if (target.isHostile()) {
      iconColor = alphaModColor(reticleColorHostile, alphaMod);
    } else {
      iconColor = alphaModColor(reticleColorNeutral, alphaMod);
    }
    
    // materials don't allow alpha this way.. I'll fake it for now by reducing color.
    iconColor.r *= alphaMod;
    iconColor.g *= alphaMod;
    iconColor.b *= alphaMod;
    
    canvas.setDrawColor(iconColor);
    
    if (shipSizeIcons.length == 0)
      shipSizeIcons = loadShipSizeIcons();
    
    screenPosition = convertWorldPositionToCanvasPosition_BehindEdge(canvas, contactLocation);
    if (targetRadius < 50) {
      canvas.drawIcon(shipSizeIcons[0], screenPosition.x, screenPosition.y, iconSize * 0.05);
//      canvas.drawIcon(Material(DynamicLoadObject("interfaceContent.Menu.arrowBlueDown", class'Material')), screenPosition.x, screenPosition.y, iconSize * 0.05);
    } else if (targetRadius < 100) {
      canvas.drawIcon(shipSizeIcons[1], screenPosition.x, screenPosition.y, iconSize * 0.05);
//      canvas.drawIcon(Material(DynamicLoadObject("interfaceContent.Menu.arrowBlueRight", class'Material')), screenPosition.x, screenPosition.y, iconSize * 0.05);
    } else if (targetRadius < 200) {
      canvas.drawIcon(shipSizeIcons[2], screenPosition.x, screenPosition.y, iconSize * 0.05);
//      canvas.drawIcon(Material(DynamicLoadObject("interfaceContent.Menu.arrowBlueLeft", class'Material')), screenPosition.x, screenPosition.y, iconSize * 0.05);
    } else if (targetRadius < 400) {
      canvas.drawIcon(shipSizeIcons[3], screenPosition.x, screenPosition.y, iconSize * 0.05);
//      canvas.drawIcon(Material(DynamicLoadObject("interfaceContent.Menu.arrowBlueUp", class'Material')), screenPosition.x, screenPosition.y, iconSize * 0.05);
    } else if (targetRadius < 800) {
      canvas.drawIcon(shipSizeIcons[4], screenPosition.x, screenPosition.y, iconSize * 0.15);
//      canvas.drawIcon(Material(DynamicLoadObject("interfaceContent.Menu.arrowDown", class'Material')), screenPosition.x, screenPosition.y, iconSize * 0.15);
    } else if (targetRadius < 1600) {
      canvas.drawIcon(shipSizeIcons[5], screenPosition.x, screenPosition.y, iconSize * 0.15);
//      canvas.drawIcon(Material(DynamicLoadObject("interfaceContent.Menu.arrowLeft", class'Material')), screenPosition.x, screenPosition.y, iconSize * 0.15);
    } else {
      canvas.drawIcon(shipSizeIcons[6], screenPosition.x, screenPosition.y, iconSize * 0.15);
//      canvas.drawIcon(Material(DynamicLoadObject("interfaceContent.Menu.arrowRight", class'Material')), screenPosition.x, screenPosition.y, iconSize * 0.15);
    }
  }
  
  simulated function drawReticle_Contact(Contact target, CanvasObject canvas)
  {
    local vector reticlePosition;
    local vector deltaPosition;
    local vector screenPosition;
  
    local float targetRadius;
    local float targetScreenWidth;
    
    local Color baseColor;
    
    local float AlphaMod;
    
    local vector Dv, RotDv;
    local array<string> ReadoutText;
    
    local SpaceWorker_Ship playerShipWorker;
    local Contact playerShipTarget;
    
    local float readoutTextSize;
    
    local User contactOwner;

    reticlePosition = target.getContactLocation();
    deltaPosition = (reticlePosition - cameraLocation);
    
    screenPosition = convertWorldPositionToCanvasPosition_BehindEdge(canvas, reticlePosition);

    targetRadius = target.estimateContactRadius();
    targetScreenWidth = canvas.convertWorldWidthToCanvasWidth(VSize(deltaPosition), targetRadius);

    alphaMod = FMax(1 - (target.radius / 500), 0.1);

    if (target.isFriendly())
      baseColor = alphaModColor(reticleColorFriendly, alphaMod);
    else if (target.isHostile())
      baseColor = alphaModColor(reticleColorHostile, alphaMod);
    else
      baseColor = alphaModColor(reticleColorNeutral, alphaMod);
    
    canvas.setDrawColor(baseColor);
    drawReticle_PositionRadius(canvas, reticlePosition, targetRadius, 1, true);

    if (playerShip != none)
      playerShipWorker = playerShip.getShipWorker();
    if (playerShipWorker != none)
      playerShipTarget = playerShipWorker.mainWeaponsTarget;

    // I'd rather these be a fixed # of pixels maybe, rather than increasing the radius - that depends on distance. It looks okay at long distance but up close the gap between the
    // brackets is too big.
    if (playerShipTarget == target) {
      canvas.setDrawColor(alphaModColor(reticleColorTargeted, alphaMod));
      drawReticle_PositionRadius(canvas, reticlePosition, targetRadius * 1.25, 5, true);
    } else if (IsItemInArray(Target, friendlyTargetContacts)) {
      canvas.setDrawColor(alphaModColor(reticleColorFriendlyTargeted, alphaMod));
      drawReticle_PositionRadius(canvas, reticlePosition, targetRadius * 1.25, 5, true);
    }
    
    if (bShowHUDReadoutsForAllContacts || (playerShipTarget == target)) {
      if (HUDReadoutType != HUD_None) {
        readoutText[ReadoutText.Length] = getTextDescriptionForContact(target);
      }

      if (HUDReadoutType == HUD_Physics) {

        ReadoutText[ReadoutText.Length] = "Range: "$VSize(playerShip.shipLocation - target.getContactLocation())$" u";
        if (playerShip != none) {
          Dv = playerShip.velocity - target.getContactVelocity();
          rotDv = Dv UnCoordRot Rotator(deltaPosition);
          ReadoutText[ReadoutText.Length] = "Approach: "$rotDv.x$" us";
        }
      } else if (HUDReadoutType == HUD_Sensors) {
        readoutText[ReadoutText.Length] = "Sensor: "$target.radius$" u";
        readoutText[ReadoutText.Length] = "Target: "$target.estimateContactRadius()$" u";
      } else if (HUDReadoutType == HUD_ShipID) {
        contactOwner = target.estimateContactUser();
        if (contactOwner != none)
          ReadoutText[ReadoutText.Length] = "Owner: "$contactOwner.displayName;
        else
          ReadoutText[ReadoutText.Length] = "Owner: None";
      } else if (HUDReadoutType == HUD_ContactID) {
        ReadoutText[ReadoutText.Length] = "Designation: "$Target.ContactID;
      }

      readoutTextSize = 7;
      canvas.setFont(canvas.getFont(readoutTextSize));
      canvas.setDrawColor(baseColor);
      drawTextLines(canvas, screenPosition.x + (targetScreenWidth * 0.5) + 5 + 10, screenPosition.y - (targetScreenWidth * 0.5) - 5, readoutTextSize + 3, readoutText);
    }
  }

  simulated function string getTextDescriptionForContact(Contact other) {
    local User contactOwner;
    
    contactOwner = other.estimateContactUser();
    if (contactOwner != none)
      return contactOwner.displayName$" :: "$other.estimateContactType();
    else
      return "Unknown";
  }
  
  simulated function drawReticle_PositionRadius(CanvasObject canvas, vector worldPosition, float radius, int bracketThickness, bool bDrawOnEdgeIfBehindCamera)
  {
    local vector screenPosition;
    local float reticleWidth;
    local float bracketWidth;
    
    if (bDrawOnEdgeIfBehindCamera) {
      screenPosition = convertWorldPositionToCanvasPosition_BehindEdge(canvas, worldPosition);
    } else {
      // Don't draw anything if it is behind the camera.
      if (isWorldPositionOffCamera(canvas, worldPosition))
        return;

      screenPosition = canvas.convertWorldPositionToCanvasPosition(worldPosition);
    }

    reticleWidth = canvas.convertWorldWidthToCanvasWidth(VSize(worldPosition - cameraLocation), radius);
    bracketWidth = FClamp(reticleWidth * 0.25, 3, 1000);
    
    Draw_Reticle_XY(canvas, screenPosition.X, screenPosition.Y, reticleWidth, reticleWidth, bracketWidth, bracketThickness);
  }


// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function Draw_Reticle_XY(CanvasObject C, int XPos, int YPos, int RetXSize, int RetYSize, float ReticleSize, int reticleThickness)
  {
    RetXSize = FMax(1, RetXSize);
    RetYSize = FMax(1, RetYSize);

    if (RetXSize <= reticleThickness + 2) {
      C.SetPos(XPos - (RetXSize * 0.5) + 0, YPos - (RetYSize * 0.5) + 0);
      drawSquare(C, RetXSize, RetYSize);
    } else {
      C.SetPos(XPos - (RetXSize * 0.5) + 0, YPos - (RetYSize * 0.5) + 0);
      DrawLine(C, 3, ReticleSize, reticleThickness);
      C.SetPos(XPos - (RetXSize * 0.5) + 0, YPos - (RetYSize * 0.5) + 0);
      DrawLine(C, 1, ReticleSize, reticleThickness);

      C.SetPos(XPos - (RetXSize * 0.5) + 0, YPos + (RetYSize * 0.5) + 0);
      DrawLine(C, 3, ReticleSize, reticleThickness);
      C.SetPos(XPos - (RetXSize * 0.5) + 0, YPos + (RetYSize * 0.5) + reticleThickness);
      DrawLine(C, 0, ReticleSize, reticleThickness);

      C.SetPos(XPos + (RetXSize * 0.5) + reticleThickness, YPos - (RetYSize * 0.5) + 0);
      DrawLine(C, 2, ReticleSize, reticleThickness);
      C.SetPos(XPos + (RetXSize * 0.5) + 0, YPos - (RetYSize * 0.5) + 0);
      DrawLine(C, 1, ReticleSize, reticleThickness);

      C.SetPos(XPos + (RetXSize * 0.5) + reticleThickness, YPos + (RetYSize * 0.5) + 0);
      DrawLine(C, 2, ReticleSize, reticleThickness);
      C.SetPos(XPos + (RetXSize * 0.5) + 0, YPos + (RetYSize * 0.5) + reticleThickness);
      DrawLine(C, 0, ReticleSize, reticleThickness);
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// Interface

  simulated function bool keyEvent(string key, string action, float delta)
  {
    local rotator rotationDelta;
    local rotator rotationFrame;
    
    if (bStrategicControls) {
      if (keyEvent_Strategic(key, action, delta)) return true;
    }
    
    // Mouse Axis.
    if (Key == "IK_MouseX" || Key == "IK_MouseY")
    {
      if (playerShip != None) {
        if (Key == "IK_MouseX")
          rotationDelta = rot(0,1,0);
        else
          rotationDelta = rot(1,0,0);
      
        // Which direction the ship should turn toward depends on the camera's roll.
        // It must be relative to the player's free flight rotation since we will be rotating it into that reference frame later.
        // Pitch and yaw of the camera should not be considered, else even a small rotation becomes large when placed in the reference
        // frame of the camera.
        rotationFrame = cameraRotation uncoordRot getFreeFlightRotation();
        rotationFrame.pitch = 0;
        rotationFrame.yaw = 0;

        rotationDelta = (delta * strategicCameraSensitivity * rotationDelta) CoordRot rotationFrame;
        rotationDelta.roll = 0;

        setFreeFlightRotation(rotationDelta coordRot getFreeFlightRotation());
      }
      
      return true;
    }

    return super.keyEvent(key, action, delta);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function bool keyEvent_Strategic(string key, string action, float delta) {
    if (key == "IK_MouseX") {
      receivedConsoleCommand(none, "strategic_camera_yaw_delta "$(Delta * StrategicCameraSensitivity));
      return true;
    }

    // Mouse Axis.
    if (key == "IK_MouseY") {
      receivedConsoleCommand(none, "strategic_camera_pitch_delta "$(Delta * StrategicCameraSensitivity));
      return true;
    }
    
    return false;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cycle(InputView inputView, float delta)
  {
    local vector forwardDesiredVelocity;
    local vector inertialCompensationDesiredVelocity;
    local vector newDesiredVelocity;
    local vector newAcceleration;
    
    super.cycle(inputView, delta);
    
    updateCameraShakeMagnitude(delta);
    
    strategicCameraStrategy.focusLocation += (strategicCameraPanSpeed * delta) CoordRot cameraRotation;
    
    if (playerShip != none) {
      myAssert(!playerShip.bCleanedUp, "SpaceGameplayInterfaceConcreteBase playerShip != none but playerShip.bCleanedUp");

      if (!bAIControl)
      {
        // Update Joystick Controls.
        updateJoystickControls(inputView, delta);

        // Update acceleration.
        if (playerShip.acceleration != 0)
        {
          inertialCompensationDesiredVelocity = Vector(getFreeFlightRotation()) * (VSize(playerShip.velocity) + (manualAcceleration * playerShip.acceleration));
          forwardDesiredVelocity = playerShip.velocity + (Vector(getFreeFlightRotation()) * manualAcceleration * playerShip.acceleration);

          newDesiredVelocity = (inertialCompensationDesiredVelocity * freeFlightInertialCompensationFactor) + (forwardDesiredVelocity * (1-freeFlightInertialCompensationFactor));
          newAcceleration = newDesiredVelocity - playerShip.velocity;
          if (VSize(newAcceleration) > 1)
            newAcceleration = Normal(newAcceleration);
            
          setFreeFlightAcceleration(newAcceleration);
        }
      } 

      // Fire Weapons
      if (bFire)
        fireWeapons();
    }
  }
  
  simulated function updateCameraShakeMagnitude(float delta) {
    local float baselineCameraShakeMagnitude;
    local float reduction;
    local float reductionRate;
    
    baselineCameraShakeMagnitude = getBaselineCameraShakeMagnitude();
    
    reductionRate = 2;
    reduction = abs(cameraShakeMagnitude - baselineCameraShakeMagnitude) * delta * reductionRate;
    
    cameraShakeMagnitude = FMax(baselineCameraShakeMagnitude, cameraShakeMagnitude - reduction);
  }
  
  simulated function float getBaselineCameraShakeMagnitude() {
    return 0;
  }
  
  simulated function fireWeapons()
  {
    local int i;
    local Contact Target;
    local ShipWeapon weapon;
    
    if (playerShip.getShipWorker() == none || playerShip.getShipWorker().mainWeaponsTarget == none)
      return;
      
    target = playerShip.getShipWorker().mainWeaponsTarget;

    for (i=0;i<playerShip.weapons.length;i++) {
      weapon = playerShip.weapons[i];
      
      // Don't auto-fire if the player is trying to manually fire.
      if (weapon.worker != none)
        weapon.worker.skipNextAutoFire();

      weapon.tryFire(target);
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function updateCamera() {
    // Update ships before camera so they aren't drawn "out of sync".
    updateVisibleShips();

    // Position the camera.
    positionCamera();
  }
  
  simulated function vector getCameraLocation() {
    return cameraLocation;
  }
  
  simulated function rotator getCameraRotation() {
    return cameraRotation;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // Visible ships should be updated to the same point in time every tick, so they aren't drawn out of sync with each other.
  simulated function updateVisibleShips()
  {
    local int i;

    if (cameraSector == None)
      return;

    for (i=0;i<cameraSector.ships.length;i++) {
      myAssert(cameraSector.ships[i].getGameSimulation() != none, "cameraSector.ships[i].getGameSimulation() == none");
      cameraSector.ships[i].updateShip();
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function initializeInterface(UserInterfaceMediator mediator) {
    super.initializeInterface(mediator);
    
    initializeCamera(mediator);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ** Camera.

  simulated function initializeCamera(UserInterfaceMediator mediator) {
    behindViewCameraStrategy = FixedRelativePositionCameraStrategy(addCameraStrategy("behindview", class'FixedRelativePositionCameraStrategy'));
    behindViewCameraStrategy.relativePosition = vect(-3,0,1.5);
    behindViewCameraStrategy.bRelativePositionScaledByRadius = true;
    behindViewCameraStrategy.bFaceDesiredRotation = true;
    
    pilotCameraStrategy = FixedRelativePositionCameraStrategy(addCameraStrategy("pilot", class'FixedRelativePositionCameraStrategy'));
    pilotCameraStrategy.relativePosition = vect(8,0,1.5);

    pilotCameraStrategy.bRelativePositionScaledByRadius = false;
    pilotCameraStrategy.bFaceDesiredRotation = false;
    
    strategicCameraStrategy = StrategicCameraStrategy(addCameraStrategy("strategic", class'StrategicCameraStrategy'));
    
    chaseCameraStrategy = ChaseCameraStrategy(addCameraStrategy("chase", class'ChaseCameraStrategy'));
    
    setCameraStrategy(strategicCameraStrategy);

    changeCameraSector(mediator, SpaceGameSimulation(getGameSimulation()).getGlobalSector());    
  }

  simulated function CameraStrategy addCameraStrategy(string newStrategyID, class<CameraStrategy> newStrategyClass) {
    local CameraStrategy newCameraStrategy;

    newCameraStrategy = CameraStrategy(allocateObject(newStrategyClass));
    newCameraStrategy.setStrategyID(newStrategyID);
    
    cameraStrategies[cameraStrategies.length] = newCameraStrategy;
    
    return newCameraStrategy;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function setCameraStrategyByID(string newStrategyID) {
    local CameraStrategy newCameraStrategy;
    
    newCameraStrategy = getCameraStrategyByID(newStrategyID);
    if (newCameraStrategy != none)
      setCameraStrategy(newCameraStrategy);
  }
  
  simulated function CameraStrategy getCameraStrategyByID(string newStrategyID) {
    local int i;
    
    for (i=0;i<cameraStrategies.length;i++)
      if (cameraStrategies[i].getStrategyID() ~= newStrategyID)
        return cameraStrategies[i];
        
    return none;
  }

  simulated function setCameraStrategy(CameraStrategy newStrategy) {
    cameraStrategy = newStrategy;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function positionCamera() {
    if (cameraStrategy != none)
      cameraStrategy.positionCamera(self);

    cameraRotation.yaw += (FRand()-0.5) * 2 * cameraShakeMagnitude;
    cameraRotation.pitch += (FRand()-0.5) * 2 * cameraShakeMagnitude;
    cameraRotation.roll += (FRand()-0.5) * 2 * cameraShakeMagnitude;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function AIPilot getPlayerPilot() {
  if (playerShip != none)
    return AIPilot(playerShip.pilot);
  else
    return none;
}

simulated function setAIControl(bool bNewAIControl)
{
  local AIPilot playerPilot;

  bAIControl = bNewAIControl;

  playerPilot = getPlayerPilot();
  if (playerPilot != none)
    playerPilot.bFreeFlight = !bNewAIControl;

  if (!bAIControl && playerShip != none)
    setFreeFlightRotation(playerShip.desiredRotation);
}

simulated function rotator getFreeFlightRotation() {
  local AIPilot playerPilot;

  playerPilot = getPlayerPilot();
  if (playerPilot != none)
    return playerPilot.freeFlightRotation;
  else
    return rot(0,0,0);
}

simulated function setFreeFlightRotation(rotator newRotation) {
  local AIPilot playerPilot;

  playerPilot = getPlayerPilot();
  if (playerPilot != none)
    playerPilot.freeFlightRotation = newRotation;
}

simulated function setFreeFlightAcceleration(vector newAcceleration) {
  local AIPilot playerPilot;

  playerPilot = getPlayerPilot();
  if (playerPilot != none)
    playerPilot.freeFlightAcceleration = newAcceleration;
}

simulated function updateJoystickControls(InputView inputView, float delta)
{
  local Rotator RotMod;
  local vector joy1Position;

  joy1Position = inputView.joysticks[0];
  if (joy1Position != Vect(0,0,0))
  {
    rotMod.yaw    = joy1Position.y * delta * joyAimSensitivity;
    rotMod.pitch  = joy1Position.x * delta * joyAimSensitivity;

    if (bRelativeJoystickControls)
      setFreeFlightRotation(rotMod coordRot playerShip.rotation);
    else
      setFreeFlightRotation(rotMod coordRot getFreeFlightRotation());
  }
}

simulated function bool receivedConsoleCommand(UserInterfaceMediator mediator, string command)
{
//    local int i;
  local array<Contact> targetContacts;
  local array<string> StringParts;

  // Get command and arguments.
  StringParts = splitString(command, " ");

  if (StringParts[0] ~= "set_ai_control") {
    SetAIControl(Int(StringParts[1]) == 1);     
    return true;
  }

  if (StringParts[0] ~= "set_strategic_controls") {
    bStrategicControls = (Int(StringParts[1]) == 1);
    return true;
  }

  if (StringParts[0] ~= "renderHUD") {
    bRenderHUD = (Int(stringParts[1]) == 1);
    return true;
  }

  if (StringParts[0] ~= "renderProjectilesOnHUD") {
    bRenderProjectilesOnHUD = (Int(stringParts[1]) == 1);
    return true;
  }

  if (StringParts[0] ~= "renderWorld") {
    setRenderWorld(mediator, Int(stringParts[1]) == 1);
    return true;
  }

  if (StringParts[0] ~= "toggleRenderHUD") {
    bRenderHUD = !bRenderHUD;
    return true;
  }

  if (StringParts[0] ~= "toggleRenderProjectilesOnHUD") {
    bRenderProjectilesOnHUD = !bRenderProjectilesOnHUD;
    return true;
  }

  if (StringParts[0] ~= "toggleRenderWorld") {
    setRenderWorld(mediator, !bRenderWorld);
    return true;
  }

  if (StringParts[0] ~= "toggleShowAllHUDReadouts") {
    bShowHUDReadoutsForAllContacts = !bShowHUDReadoutsForAllContacts;
    return true;
  }

  if (StringParts[0] ~= "set_hud_readout_delta") {
    ReceivedConsoleCommand(mediator, "set_hud_readout "$(HUDReadoutType + Int(StringParts[1])));
    return true;
  }

  if (StringParts[0] ~= "set_hud_readout") {
    HUDReadoutType = Int(StringParts[1]);
    if (HUDReadoutType > HUD_Max)
      HUDReadoutType = HUD_Min;
    infoMessage("Now using HUD Scheme " $ HUDReadoutType);

    return true;
  }

  if (stringParts[0] ~= "cameraShake")
  {
    cameraShake(cameraLocation, float(stringParts[1]));

    return true;
  }

  if (stringParts[0] ~= "set_acceleration")
  {
    manualAcceleration = Float(stringParts[1]);

    return true;
  }

  if (stringParts[0] ~= "set_acceleration_delta")
  {
    manualAcceleration = FClamp(manualAcceleration + Float(stringParts[1]), -1, 1);

    return true;
  }    

  if (stringParts[0] ~= "set_inertial")
  {
    freeFlightInertialCompensationFactor = Float(stringParts[1]);

    return true;
  }

  if (stringParts[0] ~= "set_relative_controls")
  {
    bRelativeJoystickControls = (Int(stringParts[1]) == 1);

    return true;
  }

  if (StringParts[0] ~= "set_bFire")
  {
    bFire = (Int(StringParts[1]) == 1);

    return true;
  }

  if (StringParts[0] ~=  "set_camera") {
    setCameraStrategyByID(stringParts[1]);
    return true;
  }

  if (stringParts[0] ~=  "strategic_camera_distance") {
    setStrategicCameraDistance(Float(stringParts[1]));
    return true;
  }

  if (stringParts[0] ~=  "strategic_camera_distance_delta") {
    setStrategicCameraDistance(strategicCameraStrategy.cameraDistance + float(stringParts[1]));
    return true;
  }

  if (stringParts[0] ~=  "multiplystrategicCameraDistance") {
    setStrategicCameraDistance(strategicCameraStrategy.cameraDistance * float(stringParts[1]));
    return true;
  }

  if (stringParts[0] ~= "strategicCameraPanX") {
    setStrategicCameraFocusContact(none);
    strategicCameraPanSpeed.x = float(stringParts[1]);
    return true;
  }

  if (stringParts[0] ~= "strategicCameraPanY") {
    setStrategicCameraFocusContact(none);
    strategicCameraPanSpeed.y = float(stringParts[1]);
    return true;
  }

  if (stringParts[0] ~= "strategicCameraPanZ") {
    setStrategicCameraFocusContact(none);
    strategicCameraPanSpeed.z = float(stringParts[1]);
    return true;
  }

  if (StringParts[0] ~=  "strategic_camera_yaw_delta") {
    setStrategicCameraRotationDelta(float(stringParts[1]) * rot(0,1,0));
    return true;
  }

  if (StringParts[0] ~=  "strategic_camera_pitch_delta") {
    setStrategicCameraRotationDelta(float(stringParts[1]) * rot(1,0,0));
    return true;
  }

  if (StringParts[0] ~= "set_strategic_camera_sensitivity") {
    strategicCameraSensitivity = Int(stringParts[1]);
    infoMessage("Now using Strategic Camera Sensitivity: "$strategicCameraSensitivity);

    return true;
  }

  if (StringParts[0] ~= "set_joystick_sensitivity")
  {
    JoyAimSensitivity = Int(StringParts[1]);
    infoMessage("Now using Joystick Sensitivity: " $ JoyAimSensitivity);

    return true;
  }

  if ((StringParts[0] ~= "o" || StringParts[0] ~= "order"))
  {
    if (StringParts.Length >= 4)
      parseOrder(mediator, StringParts[1], StringParts[2], StringParts[3]);
    else if (StringParts.Length >= 3)
      parseOrder(mediator, StringParts[1], StringParts[2], "");
    else infoMessage("Order failed: Too few arguments.");

    return true;
  }

  if (stringParts[0] ~=  "setFleetDelta") {
    if (UTSpaceBattleGameSimulation(getGameSimulation()) != none) {
      UTSpaceBattleGameSimulation(getGameSimulation()).setFleetDelta(Int(stringParts[1]), BaseUser(mediator.getPlayerUser()));
      infoMessage("Selected Fleet "$UTSpaceBattleGameSimulation(getGameSimulation()).getPlayerFleet().fleetName); 
    }

    return true;
  }

//    // 20090315: This might not be being used.
//    if (StringParts[0] ~= "setPilotCameraLocationOffset") {
//      pilotCameraStrategy.relativePosition.x = float(stringParts[1]);
//      pilotCameraStrategy.relativePosition.y = float(stringParts[2]);
//      pilotCameraStrategy.relativePosition.z = float(stringParts[3]);
//      
//      return true;
//    }

  if (StringParts[0] ~= "setPointOfInterest")
  {
    targetContacts = mediator.getContactsForDesignation(stringParts[1]);
    if (targetContacts.length > 0)
      pointOfInterestContact = targetContacts[0];
    else
      pointOfInterestContact = none;

    return true;
  }


  if (StringParts[0] ~= "set_friendly_targets")
  {
    Set_friendlyTargetWorkers(mediator.getContactsForDesignation(StringParts[1]));

    return true;
  }

  if (StringParts[0] ~= "toggle_friendly_targets")
  {
    Toggle_Friendly_Targets(mediator.getContactsForDesignation(StringParts[1]));

    return true;
  }

  if (stringParts[0] ~= "centerView")
  {
    setStrategicCameraDistance(10000);
    setStrategicCameraFocusLocation(vect(0,0,0));
  }

  if (StringParts[0] ~= "focus")
  {
    targetContacts = mediator.getContactsForDesignation(StringParts[1]);
    if (targetContacts.length > 0)
      setStrategicCameraFocusContact(targetContacts[0]);

    strategicCameraStrategy.focusContact = strategicCameraFocusContact;

    // enforce max/min distance relative to new focus
    setStrategicCameraDistance(strategicCameraStrategy.cameraDistance);

    return true;
  }

  if (StringParts[0] ~= "randomize_player_ship")
  {
    targetContacts = mediator.filterContactsForDesignation("random", mediator.filterContactsForDesignation("owned", mediator.getContactsForDesignation("knownContactsInCameraSector")));
    if (targetContacts.length > 0)
      SetPlayerShip(mediator, targetContacts[0]);

    return true;
  }

  if (StringParts[0] ~= "set_playership")
  {
    targetContacts = mediator.getContactsForDesignation(StringParts[1]);
    if (targetContacts.length > 0)
      setPlayerShip(mediator, targetContacts[0]);

    return true;
  }

  // If not matched, ask mediator to issue the command to the user.
  return mediator.issueUserCommand(command);
}

simulated function parseOrder(UserInterfaceMediator mediator, string WorkerID, string Order, string TargetID)
{
  local array<SpaceWorker> workers;
  local array<Contact> targets;
  local Contact singleTarget;

  workers = mediator.getWorkersForDesignation(workerID);
  if (workers.length == 0) {
    mediator.userOrderFailed("no worker(s) in selection.");
    return;
  }

  // Orders that don't require a target can go here.

  // Clear orders.
  if (Order ~= "clr")
  {
    mediator.issueManualOrders(workers, None, None);
    return;
  }

  // Self-destruct ship.
  if (Order ~= "scuttle")
  {
    mediator.scuttleWorkers(workers);
    return;
  }

  targets = mediator.getContactsForDesignation(TargetID);
  if (targets.length > 0)
    singleTarget = targets[0];
  if (singleTarget == None) {
    mediator.userOrderFailed("invalid target.");
    return;
  }

  // Orders that require a target can go here.

  // Attack.
  if (Order ~= "atk")
  {
    mediator.issueManualOrders(workers, class'Task_Attack', singleTarget);
    mediator.userOrderIssued(class'Task_Attack');
    return;
  }

  // Defense.
  if (Order ~= "def")
  {
    mediator.issueManualOrders(workers, class'Task_Defense', singleTarget);
    mediator.userOrderIssued(class'Task_Defense');
    return;
  }

  // Patrol.
  if (Order ~= "pat")
  {
    mediator.issueManualOrders(workers, class'Task_Patrol', singleTarget);
    mediator.userOrderIssued(class'Task_Patrol');
    return;
  }

  mediator.userOrderFailed("unrecognized order.");
}

simulated function setStrategicCameraFocusLocation(vector newLocation) {
  setStrategicCameraFocusContact(none);

  if (strategicCameraStrategy != none)
    strategicCameraStrategy.focusLocation = newLocation;
}

simulated function setStrategicCameraFocusContact(Contact newFocus) {
  strategicCameraFocusContact = newFocus;

  if (strategicCameraStrategy != none)
    strategicCameraStrategy.focusContact = newFocus;
  if (chaseCameraStrategy != none)
    chaseCameraStrategy.focusContact = newFocus;
}

simulated function setStrategicCameraDistance(float newDistance) {
  local float minimumDistance;

  if (strategicCameraFocusContact != none)
    minimumDistance = strategicCameraFocusContact.estimateContactRadius();

  if (strategicCameraStrategy != none)
    strategicCameraStrategy.cameraDistance = FMax(newDistance, minimumDistance);
}

simulated function setStrategicCameraRotationDelta(rotator rotationDelta) {
  if (strategicCameraStrategy != none)
    strategicCameraStrategy.cameraRotation = rotationDelta coordRot strategicCameraStrategy.cameraRotation;
}

simulated function setRenderWorld(UserInterfaceMediator mediator, bool bNewRenderWorld) {
  if (bNewRenderWorld == bRenderWorld)
    return;

  bRenderWorld = bNewRenderWorld;
  if (bRenderWorld)
    startRenderingSectorContacts(mediator);
  else
    stopRenderingSectorContacts(mediator);
}

simulated function cameraShake(vector shakeOrigin, float shakeMagnitude) {
  local float shakeDistance;
  local float magnitudeDelta;
  local float magnitudeFactor;

  shakeDistance = VSize(cameraLocation - shakeOrigin);
//    magnitudeFactor = FClamp(1 - (shakeDistance / 500), 0, 1);
  magnitudeFactor = FClamp(250 / shakeDistance, 0, 1);
  magnitudeDelta = shakeMagnitude * magnitudeFactor;

  cameraShakeMagnitude = sqrt((cameraShakeMagnitude ** 2) + (magnitudeDelta ** 2));
  //cameraShakeMagnitude += magnitudeDelta;
}

simulated function Toggle_Friendly_Targets(array<Contact> SelectedTargets)
{
  local int i;

  for (i=0;i<SelectedTargets.Length;i++)
    Toggle_Friendly_Target(SelectedTargets[i]);
}

simulated function Toggle_Friendly_Target(Contact selectedTarget)
{
  local int i;
  local SpaceWorker_Ship Worker;
  local Ship contactShip;

  if (selectedTarget == none) return;

  contactShip = selectedTarget.getOwnedShip();
  worker = contactShip.getShipWorker();

  if (IsItemInArray(SelectedTarget, friendlyTargetContacts))
  {
    for (i=0;i<friendlyTargetContacts.Length;i++)
      if (friendlyTargetContacts[i] == SelectedTarget)
      {
        friendlyTargetContacts.Remove(i,1);
        break;
      }

    for (i=0;i<friendlyTargetWorkers.Length;i++)
      if (friendlyTargetWorkers[i] == Worker)
      {
        friendlyTargetWorkers.Remove(i,1);
        break;
      }

  } else {
    friendlyTargetContacts[friendlyTargetContacts.Length] = SelectedTarget;
    friendlyTargetWorkers[friendlyTargetWorkers.Length] = Worker;
  }
} 

simulated function Set_friendlyTargetWorkers(array<Contact> SelectedTargets)
{
  local int i;
  local array<SpaceWorker_Ship> result;
  local Ship contactShip;

  friendlyTargetContacts = SelectedTargets;
  for (i=0;i<friendlyTargetContacts.Length;i++) {
    contactShip = friendlyTargetContacts[i].getOwnedShip();
    result[i] = contactShip.getShipWorker();
  }

  friendlyTargetWorkers = result;
}

simulated function setPlayerShip(UserInterfaceMediator mediator, contact newPlayerShipContact)
{
  if (playerShip != none) {
    setAIControl(true);
    playerShip = none;
    playerWorker = none;
    if (playerShipObserver != none) {
      playerShipObserver.cleanup();
      playerShipObserver = none;
    }
  }

  if (playerShipObserver != none) {
    playerShipObserver.cleanup();
    playerShipObserver = none;
  }

  playerShipContact = newPlayerShipContact;
  if (newPlayerShipContact != none) {
    playerShip = playerShipContact.getOwnedShip();

    myAssert(playerShip != none, "SpaceGameplayInterfaceConcreteBase setPlayerShip newPlayerShipContact != none but playerShipContact.getOwnedShip() == none");

    playerShipObserver = PlayerShipObserver(allocateObject(class'PlayerShipObserver'));
    playerShipObserver.initializeShipObserver(playerShip, self);

    if (cameraSector != playerShip.sector)
      changeCameraSector(mediator, playerShip.sector);

    setAIControl(true);
  }
}
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function array<Contact> filterContactsForDesignation(UserInterfaceMediator mediator, string designation, array<Contact> inputContacts) {
    local array<Contact> result;
    
    result = inputContacts;
    
    if (designation ~= "closestToPlayerShip")
      result = filterClosestToPlayerShip(result);
    
    if (designation ~= "closestToCameraCenter")
      result = filterClosestToCameraCenter(result);

    if (designation ~= "random")
      result = randomContact(result);
      
    return result;
  }
  
  simulated function array<Contact> filterClosestToPlayerShip(array<Contact> inputContacts) {
    local int i;
    local vector locDiff;
    local Contact thisContact, bestContact;
    local float thisScore, bestScore;
    local array<Contact> result;

    if (playerShip == none)
      return result;
      
    for (i=0;i<inputContacts.length;i++) {
      thisContact = inputContacts[i];
      locDiff = thisContact.getContactLocation() - playerShip.getShipLocation();
      thisScore = VSize(locDiff);
      if (bestContact == none || thisScore > bestScore) {
        bestScore = thisScore;
        bestContact = thisContact;
      }
    }
    
    if (bestContact != none)
      result[result.length] = bestContact;
      
    return result;
  }

  simulated function array<Contact> filterClosestToCameraCenter(array<Contact> inputContacts) {
    local int i;
    local vector locDiff;
    local Contact thisContact, bestContact;
    local float thisScore, bestScore;
    local array<Contact> result;

    for (i=0;i<inputContacts.length;i++) {
      thisContact = inputContacts[i];
      locDiff = thisContact.getContactLocation() - cameraLocation;
      thisScore = normal(locDiff) dot vector(cameraRotation);
      if (bestContact == none || thisScore > bestScore) {
        bestScore = thisScore;
        bestContact = thisContact;
      }
    }
    
    if (bestContact != none)
      result[result.length] = bestContact;
      
    return result;
  }
  
  simulated function array<Contact> randomContact(array<Contact> inputContacts) {
    local array<Contact> result;

    if (inputContacts.length > 0)
      result[result.length] = inputContacts[rand(inputContacts.length)];
      
    return result;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function array<Contact> getContactsForDesignation(UserInterfaceMediator mediator, string designation) {
    local array<Contact> result;
    local SectorPresence sectorPresence;
    
    if (designation ~= "fts")
      result = friendlyTargetContacts;

    if (designation ~= "focus")
      result[result.length] = strategicCameraFocusContact;
      
    if (designation ~= "ps" && playerShipContact != none)
      result[result.length] = playerShipContact;

    if (designation ~= "pswt" && playerShip != none && playerShip.getShipWorker() != none && playerShip.getShipWorker().mainWeaponsTarget != none)
      result[result.length] = playerShip.getShipWorker().mainWeaponsTarget;

    if (designation ~= "poi" && pointOfInterestContact != none)
      result[result.length] = pointOfInterestContact;

    if (designation ~= "knownContactsInPlayerShipSector" && playerShip != none && playerShip.sector != none) {
      sectorPresence = mediator.getSectorPresenceForSector(playerShip.sector);
      if (sectorPresence != none)
        result = sectorPresence.knownContacts;
    }

    if (designation ~= "knownContactsInCameraSector" && cameraSector != none) {
      sectorPresence = mediator.getSectorPresenceForSector(cameraSector);
      if (sectorPresence != none)
        result = sectorPresence.knownContacts;
    }

    return result;
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function changeCameraSector(UserInterfaceMediator mediator, Sector newSector)
  {
    if (newSector == cameraSector)
      return;
      
    // Clear old render data.
    if (bRenderWorld)
      stopRenderingSectorContacts(mediator);

    // Set new sector.
    cameraSector = newSector;
    
    // Setup new render data.
    if (bRenderWorld)
      startRenderingSectorContacts(mediator);
  }
  
  simulated function notifyClearingPlayerUser(UserInterfaceMediator mediator) {
    if (bRenderWorld)
      stopRenderingSectorContacts(mediator);
  }

  simulated function notifySetPlayerUser(UserInterfaceMediator mediator) {
    if (bRenderWorld)
      startRenderingSectorContacts(mediator);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  // Returns true if the contact is visible - it must be in the same sector as the camera and also we must be rendering the world.
  simulated function bool contactIsVisible(Contact contact) {
    return (bRenderWorld && contact.sector == cameraSector);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function gainedContact(Contact contact) {
    if (contactIsVisible(contact))
      startRenderingContact(contact);
  }

  simulated function lostContact(Contact contact) {
    if (contactIsVisible(contact))
      stopRenderingContact(contact);

    if (strategicCameraFocusContact == contact)
      setStrategicCameraFocusContact(none);
  }

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function startRenderingSectorContacts(UserInterfaceMediator mediator) {
  local int i;
  local SectorPresence sectorPresence;

  if (cameraSector != none) {
    sectorPresence = mediator.getSectorPresenceForSector(cameraSector);

    if (sectorPresence != none)
      for (i=0;i<sectorPresence.knownContacts.length;i++) {
        if (contactIsVisible(sectorPresence.knownContacts[i]))
          startRenderingContact(sectorPresence.knownContacts[i]);
      }
  }
}

simulated function stopRenderingSectorContacts(UserInterfaceMediator mediator) {
  local int i;
  local SectorPresence sectorPresence;

  if (cameraSector != none) {
    sectorPresence = mediator.getSectorPresenceForSector(cameraSector);

    if (sectorPresence != none)
      for (i=0;i<sectorPresence.knownContacts.length;i++) {
        // don't check - we aren't rendering the sector anymore - so the contact definately won't be "visible".
//          if (contactIsVisible(sectorPresence.knownContacts[i]))
          stopRenderingContact(sectorPresence.knownContacts[i]);
      }

    for (i=0;i<cameraSector.projectiles.length;i++)
      stopRenderingSectorProjectile(cameraSector.projectiles[i]);
  }
}

simulated function stopRenderingSectorProjectile(WeaponProjectile projectile) {
  local int i;

  for (i=projectile.observers.length-1;i>=0;i--)
    if (ProjectileRenderableProjectileObserver(projectile.observers[i]) != none)
      ProjectileRenderableProjectileObserver(projectile.observers[i]).notifyCameraLeftSector();
}
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function class<ShipRenderable> getContactRenderableClass(Contact contact) {
    local Ship contactShip;
    
    contactShip = contact.contactShip;
    if (PartShip(contactShip) != none)
      return class'PartShipRenderable';
    else if (contactShip != none)
      return class'ShipRenderable';
    else
      return none;
  }
  
  simulated function startRenderingContact(Contact contact) {
    local class<ShipRenderable> renderableClass;
    local ShipRenderable newRenderable;
    
    if (contact.contactObservers.length > 0)
      infoMessage("Contact.setupRenderData when already rendering!");

    renderableClass = getContactRenderableClass(contact);
    if (renderableClass != none) {
      newRenderable = ShipRenderable(engineAdapter.spawnEngineObject(renderableClass,,,contact.getContactLocation(), contact.getContactSourceRotation()));
      class'UnrealEngineAdapter'.static.propogateGlobalsActor(self, newRenderable);
      newRenderable.cameraShaker = getCameraShaker();
      newRenderable.setShip(contact.contactShip);
      newRenderable.initializeShipRenderable();
      
      contact.addContactObserver(newRenderable.getShipObserver());
    }
  }
  
  simulated function stopRenderingContact(Contact contact) {
    local ShipObserver oldObserver;

    while (contact.contactObservers.length > 0) {
      oldObserver = contact.contactObservers[contact.contactObservers.length-1];
      
      if (contact.contactShip != none)
        contact.contactShip.removeShipObserver(oldObserver);
      
      if (RenderablePartShipObserver(oldObserver).observingFor != none)
        RenderablePartShipObserver(oldObserver).observingFor.clearRenderData();
      
      contact.removeContactObserver(oldObserver);
    }
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function userOrderFailed(string reason) {
    // Play sound.
    playOrderFailedSound();

    if (reason != "")
      infoMessage("Order failed: "$reason);
    else
      infoMessage("Order failed.");
  }
  
  simulated function userOrderIssued(class<SpaceTask> orderClass) {
    playOrderIssuedSound(orderClass);
  }
  
  simulated function playOrderFailedSound();
  simulated function playOrderIssuedSound(class<SpaceTask> orderClass);
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function respawnedPlayer(UserInterfaceMediator mediator) {
  super.respawnedPlayer(mediator);
  
  receivedConsoleCommand(mediator, "set_playership flagship");
  receivedConsoleCommand(mediator, "focus ps");
  receivedConsoleCommand(mediator, "set_friendly_targets ps");
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function playInterfaceSound(object engineSoundObject, optional float volume) {
    engineAdapter.playInterfaceSound(engineSoundObject, volume);
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function cleanup() {
    if (cameraShaker != none) {
      cameraShaker.cleanup();
      cameraShaker = none;
    }
    
    setPlayerShip(none, none);
    
    cameraSector = none;

    if (friendlyTargetWorkers.Length > 0) friendlyTargetWorkers.remove(0, friendlyTargetWorkers.length);
    if (friendlyTargetContacts.Length > 0) friendlyTargetContacts.remove(0, friendlyTargetContacts.length);

    setStrategicCameraFocusContact(none);

    pointOfInterestContact = none;
    
    while (cameraStrategies.length > 0) {
      cameraStrategies[0].cleanup();
      cameraStrategies.remove(0,1);
    }
    
    setCameraStrategy(none);

    behindViewCameraStrategy = none;
    pilotCameraStrategy = none;
    strategicCameraStrategy = none;
    chaseCameraStrategy = none;
    
    engineAdapter = none;
    
    super.cleanup();
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

simulated function drawTextLines(CanvasObject c, float xStart, float yStart, float displacementPerLine, array<string> lines)
{
  local int i;
  local float VerticalDisplacement;

  for (i=0;i<Lines.Length;i++)
  {
    VerticalDisplacement = DisplacementPerLine * i;
    C.SetPos(XStart, YStart + VerticalDisplacement);
    C.DrawScreenText(Lines[i], XStart / C.getSizeX(), (YStart + VerticalDisplacement) / C.getSizeY());
  }
}

simulated function drawLine(CanvasObject canvas, int direction, float lineLength, float lineThickness) {
  switch (direction)
  {
    case 0:
      drawSquare(canvas, lineThickness, -lineLength);
      break;
    case 1:
      drawSquare(canvas, lineThickness, lineLength);
      break;
    case 2:
      drawSquare(canvas, -lineLength, lineThickness);
      break;
    case 3:
      drawSquare(canvas, lineLength, lineThickness);
      break;
  }
}

simulated function drawSquare(CanvasObject canvas, float width, float height) {
  canvas.drawTile(canvas.getDefaultMaterial(), width, height, 0, 0, width, height);
}

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

// Not the most performant since the array is copied.
simulated function bool isItemInArray(object Item, array<object> Arr) {
  local int i;

  for (i=0;i<Arr.Length;i++)
    if (Arr[i] == Item)
      return true;

  return false;
}


defaultproperties
{
  bRenderWorld=true
  bRenderHUD=true
  bRenderProjectilesOnHUD=true

  bStrategicControls=true
  
  graphic=None
  strategicCameraSensitivity=150
  joyAimSensitivity = 8092
  
  reticleColorFriendly=(R=0,G=255,B=0,A=128)
  reticleColorHostile=(R=255,G=0,B=0,A=128)
  reticleColorNeutral=(R=128,G=128,B=128,A=128)
  reticleColorTargeted=(R=255,G=128,B=128,A=255)
  reticleColorFriendlyTargeted=(R=128,G=255,B=128,A=255)  

  barColorParts=(R=0,G=0,B=255,A=255)  
  barColorEnemyParts=(R=255,G=0,B=0,A=255)  
  
  freeFlightInertialCompensationFactor=1
  
  HUDReadoutType=1
}
