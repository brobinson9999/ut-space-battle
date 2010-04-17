UT Space Battle
Space Combat Simulation
by Brendon Robinson

This project is hosted on SourceForge and has been released under the GNU LGPL:
http://utspacebattle.sourceforge.net/
It is also hosted on ModDB:
http://www.moddb.com/mods/ut-space-battle

Installation/Deployment:

UT3 Base Distribution:
  Extract or copy the contents of the distribution archive to your Documents\My Games\Unreal Tournament 3\UTGame folder.
  The base distribution does not include any maps, these will have to be downloaded separately.

UT2k4 Base Distribution:
  Extract or copy the contents of the distribution archive to your UT2004\System folder.
  The base distribution does not include any maps, these will have to be downloaded separately.


Overview:
Please note that this is an Alpha distribution. It has not been significantly polished for release or documented. However, I am making it available for those who are interested and perhaps would like to follow it's progress. Because this is an alpha release there may be new bugs with a new release, debugging messages displayed, and game balance may shift from release to release.

There are currently two gametypes:
  * Dogfight - Each player controls one ship. Players accumulate "spawning points" by destroying other ships which allow them to respawn as larger, more powerful ships. Destroying larger ships will yield more points. Frags are awarded for each kill irrespective of target size. The objective is to be first to reach a specified number of frags. In Dogfight you can always see enemy ships.
  * Carrier Battle - Each player controls one carrier and a group of supporting ships. The supporting ships can accumulate "spawning points" and respawn as larger, more powerful ships. Frags are awarded only for carrier kills. The objective is to be first to reach a specified number of frags. Because each player controls a fleet and frags are awarded only for carrier kills, Carrier Battle is best suited for smaller numbers of bots and low frag limits. In Carrier Battle you can only see enemy ships if they are within a certain distance of a friendly ship.

These gametypes have not been tested in multiplayer, and I do not believe that they will work in multiplayer at this time. Bot support is working and the bots should provide a fair challenge. Difficulty levels are respected but at this time, the difference between difficulty levels is limited.

Gameplay:
All players have an AI which controls all units by default. The human player can optionally directly control the movement and force firing of the current ship at it's primary target. (the AI will fire automatically if it estimates a high enough probability of a hit) In addition, the behaviour of units that are not directly controlled can be influenced by issuing orders to the AI. There are a number of "fleets" which have different carriers and ship progression. One can be selected, or if none is selected, a random fleet will be selected for you. Bots will always use random fleets.

Controls:
In UT2004, key binds can be set up in the input commands. In UT3 support is not yet available for binding keys. The following default keybinds are provided for UT3:

Mouse Axes:					Change Desired Rotation of Ship (in Free Flight), Rotate Camera (in free camera mode)
Mouse Wheel:  			Zoom in/out (in free camera mode)
Space:							Tactical Overview (when held, camera is zoomed out far enough to get a large-scale view)

Left Mouse Button:	Force Fire Weapons at Primary Target
Right Mouse Button:	Switch off Free Flight Mode when pressed, Switch to Free Flight mode on release.

Q:									Switch off Free Flight Mode
E:									Switch on Free Flight Mode
W:									Randomize current ship (make a random ship the current one)

R:									Toggle through some HUD readouts. 
Y:									Toggle displaying all HUD readouts, or only readouts for current target.
J:									Toggle Displaying the HUD
K:									Toggle Displaying Projectiles on HUD
L:									Toggle Displaying Ships/Projectiles in 3D

1:									Select All Ships
2:									Select Current Ship
3:									Select Carrier (in Carrier Battle)
4:									Select Support Ships/Fighters (in Carrier Battle)

T:									Order selected ships to target the hostile closest to the center of the screen
D:									Order Selected ships to defend the current ship.
F:									Order selected ships to concentrate fire on the current ship's target.
C:									Order selected ships to clear standing orders.

5:									Set Throttle Full Reverse
6:									Set Throttle Half Reverse
7:									Set Throttle to Zero
8:									Set Throttle to 1/3 Forward
9:									Set Throttle to 2/3 Forward
0:									Set Throttle Full Forward

I:									Set to fixed behindview camera
O:									Set to free camera
Spacebar:						Hold to show zoomed out overview when in free camera mode.
Arrow Keys:					Pan Camera when in free camera mode.
P:									Set to first person view of ship (undeveloped, will show parts of the inside of the model)
[:									Set to chase camera (default)

Backslash (\): 			Cycle through fleets.
