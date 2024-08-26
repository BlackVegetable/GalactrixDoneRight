This is the readme for the Balance Mod.  It explains installation, where to report bugs, and how to further modify your game.
For explanations of rules please check the Balance Handbook.  For explanations of changes, please check the changelog.  Enjoy!




BlackVegetable's Comprehensive Balance Mod (CBM Version 1.0)

BACKING UP OLD FILES:

1. Copy Assets.zip from your unmodded Galactrix (found in your Galactrix folder) to another folder.  Rename as AssetsBACKUP.zip .

2. Unzip The Assets.zip that remains in your Galactrix folder.  Important folders you unzipped are: "Assets" and "English".

3. To backup old save files while running Windows XP: My Documents/Puzzle Quest Galactrix/Saves .  Files contained here should be moved to a folder labeled "Backup Saves"
	Vista's filepath is similar to XP's.
*** NOTE THAT SAVED GAMES FROM THE RETAIL VERSION CANNOT BE USED WITH THE CBM AND MAY BE DAMAGED UNLESS REMOVED FROM THE SAVEGAME FOLDER. ***


INSTALLATION:

0. Unzip contents of the mod into a temporary folder of your choosing.


Copy and Paste the following from the files in said folder to the following locations.

1. Take the contents of the English Folder and place them in your English Folder.

2. Take the contents of the Scripts Folder and place them in your Assets/Scripts Folder.

3. Take the contents of the Conversations Folder and place them in your Assets/Conversations Folder. [NOT your English/Conversations Folder!!]

4. Take the contents of the Screens Folder and place them in your Assets/Screens Folder. [Otherwise you will have the infamous "Alphabet Items" Glitch]

5. Take the Changelog and place it in your Galactrix folder -- OR -- Delete this file as it is not needed.

6. Take the Handbook and place it in your Galactrix folder.

7. Take the Lua File Documentation and Delete it -- OR -- Use as a reference for modding.

8. Take this Readme file and place it in your Galactrix folder for future reference.

9. Delete the temporary folder once you are certain all the mod's files have been accounted for.



THE HANDBOOK will serve as a guide to the differences between the retail version and the CBM, it is highly recommended you read it.

If you encounter any bugs/typos you should do one of the following:

1. Post your discovered bug in the official Galactrix Forums (http://forums.infinite-interactive.com) in the appropriate topic.

2. Send me a Private Message on the official Forums -- my username is BlackVegetable.

3. Send me an email at IamTheOlive@gmail.com with a description of the bug/typo.

In all three cases you should both detail the bug or typo and what you were doing to trigger it, attempt to reproduce the bug,
and post/send the Debug Log for the game session resulting in the error.  The Debug Log is found in My Documents/Puzzle Quest Galactrix/Debug Logs but
is rewritten each new game session you start.  Also, be sure to check the Forums to be sure your bug hasn't already been documented or addressed by a
newer version than you are running.

Also, you will need a PDF reader to properly display the latest version of the Balance Handbook.  I recommend Foxit Reader (http://www.foxitsoftware.com/pdf/reader).



MODS and PATCHES in addition to the Balance Mod will probably not work.  A few, such as the colorblind mod, that do not edit script files, should still
work.  However, the major modifications people want to make are included here in this readme for your editing pleasure!

To make hacking easier/harder all-around (or remove from the game) . . . 
	
	Open ...\Puzzle Quest Galactrix\Assets\Scripts\GlobalFunctions\Hack.lua
	To give yourself more time . . .  
		After the line (14) that says: local time = _G.GATES[location].time
		Add a line saying: time = math.floor(time * 1.5)
		This will give you 50% more time, rounding down.
	To give yourself less time . . .
		After the line (14) that says: local time = _G.GATES[location].time
		Add a line saying: time = math.ceil(time * 0.75)
		This will give you 25% less time, rounding up.
	To reduce the required matches . . .
		After the line (13) that says: local keys = _G.GATES[location].keys - sciHack
		Add a line saying: keys = math.ceil(keys * 0.6)
		This will reduce the required matches by 40%, rounding up.
	To increase the required matches . . .
		After the line (13) that says: local keys = _G.GATES[location].keys - sciHack
		Add a line saying: keys = math.floor(keys * 1.3)
		This will increase the required matches by 30%, rounding down.		
	To remove hacking from the game . . .
		After the line (13) that says: local keys = _G.GATES[location].keys - sciHack
		Add a line saying: keys = 0
		This will make hacking events end right after they begin.

To make JumpGates never come UnHacked . . .

	Open ...\Puzzle Quest Galactrix\Assets\Scripts\Screens\SolarSystemMenu.lua
	To make gates never unhack themselves . . .
		On line (139) which reads: if math.random(1,20) == 1 then
		Change the last number so it reads: if math.random(1,20) == 21 then
		This is an impossible event (if you roll a 20-sided die and it reads a 21.)
		And thus will never unhack your gates.
	To make gates unhack more frequently . . .
		On line (139) which reads: if math.random(1,20) == 1 then
		Change the first bit so it reads: if math.random(1,15) == 1 then
		This will reduce the number of possible numbers your die could "roll" and thus increase the odds of landing a one.
		The odds of unhacking a gate will increase.  (Just don't lower that number below 2.)

To make Items/Ships easier to craft . . .

	Open ...\Puzzle Quest Galactrix\Assets\Scripts\GlobalFunctions\Plans.lua
	To make Ships easier to craft . . .
		Find lines (8-10) that read:
		weap = SHIPS[itemID].weapons_rating
		eng  = SHIPS[itemID].engine_rating
		cpu  = SHIPS[itemID].cpu_rating
		Change them to read:
		weap = math.ceil(SHIPS[itemID].weapons_rating * 0.75)
		eng  = math.ceil(SHIPS[itemID].engine_rating * 0.75)
		cpu  = math.ceil(SHIPS[itemID].cpu_rating * 0.75)
		They will now require 25% fewer matches to craft (rounding up.)
	To make Items easier to craft . . .
		Find lines (12-14) that read:
		weap = ITEMS[itemID].weapon_requirement
		eng  = ITEMS[itemID].engine_requirement
		cpu  = ITEMS[itemID].cpu_requirement
		Change them to read:
		weap = math.ceil(SHIPS[itemID].weapon_requirement * 0.75)
		eng  = math.ceil(SHIPS[itemID].engine_requirement * 0.75)
		cpu  = math.ceil(SHIPS[itemID].cpu_requirement * 0.75)
		They will now require 25% fewer matches to craft (rounding up.)




NEW IDEAS (for the Balance Handbook):

If you have a new idea for either a challenge mode or a challenge character class, please post it in the Balancd Mod:Need Input
forum topic.  I very well may include it!  Also, if you feel the Balance Handbook is missing crucial information, please let
me know in the same fashion.  Thanks!



SPECIAL THANKS go to the following individuals:

Xono (For early LUA programming help; I wouldn't have gotten very far without Xono.)
KGB (For major contributions on how Attributes should function as well as other input.)
Offshore7 (For helping to eradicate the infamous "Alphabet Items" Glitch.)
Still (For a large amount of beta testing and feedback.)
and
All other Beta Testers for their help and feedback.



Thanks and Enjoy!
- BlackVegetable IamTheOlive@Gmail.com
