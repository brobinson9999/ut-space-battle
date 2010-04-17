import os
import shutil
import subprocess
import datetime

from mypyshell import *

# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# ** Setup Parameters

releaseDirectory = r"E:\Software\Unreal Engine Mods\Space Game Release"
sevenZipPath = r"C:\Program Files\7-Zip\7z"
#sevenZipOptions = "a -tzip -mx=9"
sevenZipOptions = ["a" " " "-tzip"]
deleteReleaseDirAfterZip = True

dirSourceCode = "Source-Code"
dirUnrealEngine2BaseDistribution = "Unreal-Engine-2-Base-Distribution"
dirUnrealEngine2FullDistribution = "Unreal-Engine-2-Full-Distribution"
dirUnrealEngine3BaseDistribution = "Unreal-Engine-3-Base-Distribution"
dirUnrealEngine3FullDistribution = "Unreal-Engine-3-Full-Distribution"

# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# ** Helpers

def releaseDir(dirSuffix):
    return os.path.join(releaseDirectory, dirSuffix)

def SetupAndCopyReleaseDirectory(fromDir, toDirSuffix):
    RemoveReleaseDirectory(toDirSuffix)
    CopyReleaseDirectoryContents(fromDir, toDirSuffix)
    
def RemoveReleaseDirectory(dirSuffix):
    RemoveDirectory(releaseDir(dirSuffix))
    
def RemoveDirectory(directory):
    if (os.path.isdir(directory)):
        shutil.rmtree(directory)

def CopyReleaseDirectoryContents(fromDir, toDirSuffix):
    shutil.copytree(fromDir, releaseDir(toDirSuffix))

def zipReleaseDir(dirSuffix):
    targetDir = releaseDir(dirSuffix)
    zipName = releaseDir(dirSuffix + "-" + dateStringNow() + ".zip")
    subprocess.call([sevenZipPath, sevenZipOptions, zipName, targetDir])
    if (deleteReleaseDirAfterZip):
        RemoveDirectory(targetDir)

def makeReleaseDir(releaseName):
    RemoveReleaseDirectory(releaseName)
    os.makedirs(releaseDir(releaseName))
    
def copyUT2004Map(mapName, toDirectory):
    shutil.copyfile("C:\\UT2004\\Maps\\" + mapName + ".ut2", os.path.join(toDirectory, mapName + ".ut2"))
    
def releaseUT2004Map(mapName):
    makeReleaseDir(mapName)
    copyUT2004Map(mapName, releaseDir(mapName))
    zipReleaseDir(mapName)

def copyUT3Map(mapName, toDirectory):
    shutil.copyfile("C:\\Users\\Kittens\\Documents\\My Games\\Unreal Tournament 3\\UTGame\\Unpublished\\CookedPC\\CustomMaps\\" + mapName + ".ut3", os.path.join(toDirectory, mapName + ".ut3"))
    shutil.copyfile("C:\\Users\\Kittens\\Documents\\My Games\\Unreal Tournament 3\\UTGame\\Unpublished\\CookedPC\\CustomMaps\\" + mapName + ".ini", os.path.join(toDirectory, mapName + ".ini"))

def releaseUT3Map(mapName):
    makeReleaseDir(mapName)
    copyUT3Map(mapName, releaseDir(mapName))
    zipReleaseDir(mapName)
    
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# ** Source Code

# Copy Files
SetupAndCopyReleaseDirectory("E:\Documents\Programming\Unreal Engine Mods\Source Code", dirSourceCode)

# Create Archive
zipReleaseDir(dirSourceCode)

# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# ** Unreal Engine 2 Distribution

# Copy Files
SetupAndCopyReleaseDirectory("C:\UT2004\ClientScripts\System", dirUnrealEngine2BaseDistribution)
shutil.copyfile("E:\Documents\Programming\Unreal Engine Mods\UT Space Battle Readme.txt", os.path.join(releaseDir(dirUnrealEngine2BaseDistribution), "UT Space Battle Readme.txt"))

# Remove Logs and INI Files.
os.remove(releaseDir(os.path.join(dirUnrealEngine2BaseDistribution, "ClientScripts.log")))
os.remove(releaseDir(os.path.join(dirUnrealEngine2BaseDistribution, "ClientScripts.ini")))
os.remove(releaseDir(os.path.join(dirUnrealEngine2BaseDistribution, "ClientScriptsUser.ini")))

# Create Archive
zipReleaseDir(dirUnrealEngine2BaseDistribution)

# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# ** Unreal Engine 3 Distribution

def makeUnrealEngine3BaseDistribution(releaseName):
    makeReleaseDir(releaseName)
    SetupAndCopyReleaseDirectory("C:\Users\Kittens\Documents\My Games\Unreal Tournament 3\UTGame\Unpublished\CookedPC\Script", os.path.join(releaseName, "UTGame", "Published", "CookedPC", "Script"))
    os.makedirs(releaseDir(os.path.join(releaseName, "UTGame", "Config")))
    shutil.copyfile("C:\Users\Kittens\Documents\My Games\Unreal Tournament 3\UTGame\Config\UTClientScripts.ini", os.path.join(releaseDir(releaseName), "UTGame", "Config", "UTClientScripts.ini"))
    shutil.copyfile("E:\Documents\Programming\Unreal Engine Mods\UT Space Battle Readme.txt", os.path.join(releaseDir(releaseName), "UT Space Battle Readme.txt"))

makeUnrealEngine3BaseDistribution(dirUnrealEngine3BaseDistribution)
zipReleaseDir(dirUnrealEngine3BaseDistribution)

makeUnrealEngine3BaseDistribution(dirUnrealEngine3FullDistribution)
os.makedirs(releaseDir(os.path.join(dirUnrealEngine3FullDistribution, "UTGame", "Published", "CookedPC", "CustomMaps")))
copyUT3Map("SP-DeimosSpace",releaseDir(os.path.join(dirUnrealEngine3FullDistribution, "UTGame", "Published", "CookedPC", "CustomMaps")))
copyUT3Map("SP-DeepSpace",releaseDir(os.path.join(dirUnrealEngine3FullDistribution, "UTGame", "Published", "CookedPC", "CustomMaps")))
zipReleaseDir(dirUnrealEngine3FullDistribution)

# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# ** Maps

releaseUT3Map("SP-DeimosSpace")
releaseUT3Map("SP-DeepSpace")

releaseUT2004Map("SP-Preload")
releaseUT2004Map("SP-Mothership")
releaseUT2004Map("SP-Phobos")

# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
# **************************************************************************************************************************************************************************************************************
