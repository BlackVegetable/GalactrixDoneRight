-------------------------------------------------------------------------------
--
-- TUTORIAL SYSTEM
--	Works with a player in a similar manner to the quest system. 
--
--	Uncomment asserts for testing.
--
-------------------------------------------------------------------------------

use_safeglobals()

local assert = assert
local type = type

_G.LUA_PATH = _G.LUA_PATH or "?.lua;../?.lua"

-- this should be defined by individual projects
_G.MAX_TUTORIALS = _G.MAX_TUTORIALS or 0

-- this needs to default to 0 on startup, however it should be overriden when loading a hero by the players choice
_G.SHOW_TUTORIALS = _G.SHOW_TUTORIALS or 0
--[[ SHOW_TUTORIALS values =
0 = Default value, shows tutorials, but overrides this when a hero is loaded
1 = Don't show tutorials, set by player (not loaded), override heroClass definition
2 = Show tutorials, set by player (not loaded), override heroClass definition
--]]

_G.SHOWING_TUTORIAL = false

-------------------------------------------------------------------------------
-- MakeTutorialised(heroClass)
--	Adds the appropriate attributes to the class provided.
function _G.MakeTutorialised(heroClass)
    -- add attribute to remember if the player wants tutorials shown.
    heroClass.AttributeDescriptions:AddAttribute("int", "show_tutorials", {default=2, serialize=1, max=2})
    -- add attribute collection to remember tutorials shown 
    heroClass.AttributeDescriptions:AddAttributeCollection("int", "shown_tutorials", {default=0, serialize=1, max=1})
end

-------------------------------------------------------------------------------
-- InitialiseNewHeroTutorials(hero)
--	Initialises the hero, most importantly setting the flags for all the tutorials to 0 (not shown)
function _G.InitialiseNewHeroTutorials(hero)
	if SHOW_TUTORIALS == 0 then
		hero:SetAttribute("show_tutorials",2)	-- new players will most likely want to see tutorials
	else
		hero:SetAttribute("show_tutorials",SHOW_TUTORIALS)
	end
	
	-- initialise all the flags to 0 (not shown)
	for i = 1, MAX_TUTORIALS do
		hero:PushAttribute("shown_tutorials",0)
	end
end

-------------------------------------------------------------------------------
-- HeroLoadTutorialSystem(hero)
--	Verifies the loaded heros attributes
function _G.HeroLoadTutorialSystem(hero)

	if (SHOW_TUTORIALS == 1) then -- the player wants to hide tutorials, override the next loaded hero choice.
		hero:SetAttribute("show_tutorials", SHOW_TUTORIALS)
	elseif (SHOW_TUTORIALS == 2) then -- the player wants to show tutorials override the next loaded hero choice.
		hero:SetAttribute("show_tutorials", SHOW_TUTORIALS)
	elseif (SHOW_TUTORIALS == 0) then -- the player wants to use the loaded hero choice.
		-- do nothing
	end

	-- check the size of the flags array is equivalent to the max defined
	if hero:NumAttributes("shown_tutorials") < MAX_TUTORIALS then	
		local pushExtra = (MAX_TUTORIALS - hero:NumAttributes("shown_tutorials")) 
		for i = 1, pushExtra do
			hero:PushAttribute("shown_tutorials",0)
		end
	end
end

-------------------------------------------------------------------------------
-- SetShowingTutorials(object, value)
--	If there is a hero loaded, then toggle the value in the hero. Otherwise set SHOW_TUTORIALS to the value and override the next hero loaded.
function _G.SetShowingTutorials(hero, value)
	if hero then
		hero:SetAttribute("show_tutorials",value)
	else
		_G.SHOW_TUTORIALS = value
	end
end

-------------------------------------------------------------------------------
-- ShownTutorial(number,hero)
--	Checks if this tutorial has been shown, Returns true if screen is opened, 
--  false if tutorial screen is not opened.
function _G.ShownTutorial(number,hero)
	assert(number <= MAX_TUTORIALS)
	assert(hero)
	
	if (hero:GetAttributeAt("shown_tutorials",number) == 0) then
		return false
	else
		return true
	end

end

-------------------------------------------------------------------------------
-- ShowTutorialFirstTime(number,hero)
--	Checks if this tutorial has been shown, and if not, Opens the tutorial menu showing the tutorial defined by the number provided.
--	Returns true if screen is opened, false if tutorial screen is not opened.
function _G.ShowTutorialFirstTime(number,hero, callback)
	assert(number <= MAX_TUTORIALS)
	
	if _G.SHOWING_TUTORIAL then
		return false
	elseif hero then
		if number <= hero:NumAttributes("shown_tutorials") then -- check the number is in range
			if (hero:GetAttributeAt("shown_tutorials",number) == 0) and (hero:GetAttribute("show_tutorials") == 2) then
				-- if the player hasn't seen this tutorial and they have tutorials turned on
				hero:SetAttributeAt("shown_tutorials",number,1)
				_G.SHOWING_TUTORIAL = true
				SCREENS.TutorialMenu:OpenTarget(number,hero,callback)
				return true
			else
				return false
			end
		else
			return false
		end
	else
		_G.SHOWING_TUTORIAL = true			
		SCREENS.TutorialMenu:OpenTarget(number, nil,callback)
		return true
	end	
end

-------------------------------------------------------------------------------
-- ShowTutorial(number,hero)
--	Opens the tutorial menu showing the tutorial defined by the number provided.
--	Returns true if screen is loaded, false if tutorial screen is not loaded.
function _G.ShowTutorial(number,hero, callback)
	assert(number <= MAX_TUTORIALS)

	if _G.SHOWING_TUTORIAL then
		return false
	elseif hero then
		if number <= hero:NumAttributes("shown_tutorials") then -- check the number is in range
			hero:SetAttributeAt("shown_tutorials",number,1)
			_G.SHOWING_TUTORIAL = true
			SCREENS.TutorialMenu:OpenTarget(number,hero, callback)
			return true
		else
			return false
		end
	else
		_G.SHOWING_TUTORIAL = true
		SCREENS.TutorialMenu:OpenTarget(number, nil, callback)
		return true		
	end
end


-------------------------------------------------------------------------------
-- ShowTutorialConstant(number,hero)
--	Opens the tutorial menu showing the tutorial defined by the number provided.
--	Returns true if screen is loaded, false if tutorial screen is not loaded.
-- Obeys the hero show_tutorials attribute
function _G.ShowTutorialConstant(number,hero, callback)
	assert(number <= MAX_TUTORIALS)
	assert(hero)
	
	if _G.SHOWING_TUTORIAL then
		return false
	elseif hero then
		if number <= hero:NumAttributes("shown_tutorials") and (hero:GetAttribute("show_tutorials") == 2) then -- check the number is in range
			hero:SetAttributeAt("shown_tutorials",number,1)
			_G.SHOWING_TUTORIAL = true
			SCREENS.TutorialMenu:OpenTarget(number,hero, callback)
			return true
		else
			return false
		end	
	else
		_G.SHOWING_TUTORIAL = true
		SCREENS.TutorialMenu:OpenTarget(number, nil, callback)
		return true
	end	
end

-------------------------------------------------------------------------------
-- CloseTutorialMenu()
--	Closes and nils the TutorialMenu to free the memory used by it.
function _G.CloseTutorialMenu(callback)
	if callback then
		if type(callback) == "function" then
			CallScreenSequencer("TutorialMenu",callback)
		else
			SCREENS.TutorialMenu:Close()
		end
	else
		SCREENS.TutorialMenu:Close()
	end
end
