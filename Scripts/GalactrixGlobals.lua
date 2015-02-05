function _G.DoNothing()
	-- nil
end


_G.mp_get_connection_strength = mp_get_connection_strength or function ()

	return 5
end


_G.enable_sleep_mode = enable_sleep_mode or function ()

end


_G.disable_sleep_mode = disable_sleep_mode or function ()

end



function _G.is_open(menu_name)
	if rawget(SCREENS,menu_name) and SCREENS[menu_name]:IsOpen() then
		return true
	else
		return false
	end
end

function _G.LoadInit(handle,file)
	if not handle then
		LOG(string.format("import(%s)",file))
		handle = import(file)
	end
	return handle

end


function _G.HideWirelessIcons()

	local function hide_rec(menu)
		menu:hide_widget("icon_wireless_strength")
	end

	if _G.is_open("ReceptionStrengthMenu") then
		_G.SCREENS.ReceptionStrengthMenu:Close()
	end

	if is_open("GameMenu") then
		hide_rec(_G.SCREENS.GameMenu)
	end
	if _G.is_open("MultiplayerGameSetup") then
		hide_rec(_G.SCREENS.MultiplayerGameSetup)
	end
	if _G.is_open("MPResultsMenu") then
		hide_rec(_G.SCREENS.MPResultsMenu)
	end
	if _G.is_open("CustomLoadingMenu") then
		_G.SCREENS.CustomLoadingMenu.multiplayer=nil
		hide_rec(_G.SCREENS.CustomLoadingMenu)
	end

end




function _G.PlayCutscene(cutsceneID,sourceMenu)
	local sourceMenu = sourceMenu or "SolarSystemMenu"
	local function CutSceneFinished()
		_G.ScreenManager.pop_back()
		_G.Hero.cut_scene = nil
		SCREENS.SolarSystemMenu:ShowWidgets()
		SCREENS.SolarSystemMenu.state=_G.STATE_IDLE
	end

	local function loadit()--use loading screen while opening SolarSystemMenu
		SCREENS.CustomLoadingMenu:Open(nil, CutSceneFinished, nil, nil)
	end

	local function CancelCutScene()
		_G.ScreenManager.pop_back()
		cancel_cutscene_menu()
	end

	SCREENS.SolarSystemMenu.state=_G.STATE_MENU
	collectgarbage()
	SCREENS.SolarSystemMenu:HideWidgets()

	_G.ScreenManager.push_back(CancelCutScene)

	open_cutscene_menu(string.format("CutScenes/%s.xml",cutsceneID), loadit)


end




_G.MAX_CREDITS = 9999999-- 10 MILLION - 1

-- Mod Globals --
_G.LAST_TURN_FREE = false
_G.ENEMY_STUNNED = false
_G.ALLY_STUNNED = false
_G.TOTAL_TURNS = 0
_G.PLAYER_1_COOLANT = 9
_G.PLAYER_2_COOLANT = 9
_G.PLAYER_1_STUN = false
_G.PLAYER_2_STUN = false
_G.ENEMY_LEVEL = 1
_G.WAS_VICTORY = false

--MAP Globals
_G.FLEE_SYSTEM = 1
_G.ABANDON_ENCOUNTER = 2
_G.ALERT_ENCOUNTER = 3

_G.STATE_PRE_FLIGHT = 0
_G.STATE_FLIGHT = 1
_G.STATE_TARGET = 2
_G.STATE_ENCOUNTER = 3
_G.STATE_MENU = 4
_G.STATE_TRANSITION = 5

_G.CURSOR_SNAP_DELAY = 400
_G.CURSOR_SNAP_SPEED = 300


--BattleGame States
_G.STATE_INITIALIZING = -1
_G.STATE_IDLE = 0
_G.STATE_USER_INPUT_GEM = 1
_G.STATE_USER_INPUT_PLAYER = 2
_G.STATE_SWAPPING = 3
_G.STATE_ILLEGALMOVE = 4
_G.STATE_SEARCHING = 5
_G.STATE_REMOVING = 6
_G.STATE_FALLING = 7
_G.STATE_REPLENISHING = 8
_G.STATE_GAME_OVER = 9
_G.STATE_ENDING_TURN = 10
_G.STATE_FINDING_MOVE = 11

_G.MAX_MOVES = 12


_G.STATE_SET_PATTERN_GRID = 99




--GOV & INDUSTRY DEFINITIONS
_G.GOV_NONE					= 0
_G.GOV_DICTATORSHIP			= 1
_G.GOV_DEMOCRACY			= 2
_G.GOV_CORPORATE			= 3
_G.GOV_FEUDAL				= 4
_G.GOV_ANARCHIC				= 5

_G.INDUSTRY_NONE			= 0
_G.INDUSTRY_MINING			= 6
_G.INDUSTRY_MILITARY		= 7
_G.INDUSTRY_AGRICULTURE		= 8
_G.INDUSTRY_INDUSTRIAL		= 9
_G.INDUSTRY_ADMINISTRATIVE	= 10


--CARGO DEFINITIONS
_G.NUM_CARGOES = 10

_G.CARGO_FOOD 			= 1
_G.CARGO_TEXTILES 		= 2
_G.CARGO_MINERALS 		= 3
_G.CARGO_ALLOYS 		= 4
_G.CARGO_TECH 			= 5
_G.CARGO_LUXURIES 		= 6
_G.CARGO_MEDICINE 		= 7
_G.CARGO_GEMS	 		= 8
_G.CARGO_GOLD	 		= 9
_G.CARGO_CONTRABAND 	= 10


--FACTION DEFINITIONS
_G.STANDING_CRIMINAL		= 1
_G.STANDING_SUSPECT			= 2
_G.STANDING_NEUTRAL			= 3
_G.STANDING_FRIENDLY		= 4
_G.STANDING_ALLIED			= 5


_G.FACTION_NONE        = 0
_G.FACTION_TRIDENT     = 1
_G.FACTION_MRI         = 2
_G.FACTION_CYTECH      = 3
_G.FACTION_LUMINA      = 4
_G.FACTION_VORTRAAG    = 5
_G.FACTION_ELYSIA      = 6
_G.FACTION_KECK        = 7
_G.FACTION_DEGANI      = 8
_G.FACTION_JAHRWOXI    = 9
_G.FACTION_KRYSTALLI   = 10
_G.FACTION_QUESADANS   = 11
_G.FACTION_PLASMIDS    = 12
_G.FACTION_PIRATES     = 13
_G.FACTION_SOULLESS    = 14
_G.FACTION_UNKNOWN     = 15

-- constants for evaluating AI item usage
--[[
_G.AI_ITEM_NEVER       = 0
_G.AI_ITEM_VERYBAD     = 50
_G.AI_ITEM_BAD         = 70
_G.AI_ITEM_MODERATE    = 85
_G.AI_ITEM_GOOD        = 100
_G.AI_ITEM_VERYGOOD    = 170
_G.AI_ITEM_ALWAYS      = 400
]]--
_G.NUM_FACTIONS = 14--Ben decided to hard code this since the addition of "NONE" and "UNKNOWN" caused loss of sense -- please correct if incorrect.
LOG(tostring(_G.NUM_FACTIONS).." = numfactions")

--Hero info
_G.MALE = 1
_G.FEMALE = 0
_G.StartHeroes = {"H001","H002"}
--_G.StartEnemies = {"HE01","HE02","HE03"}--Not used


init_profanity_filter()
--Return false if invalid Name
function _G.ValidName(name)
	local valid = false

	if name then
		for x in string.gmatch(name, "(%S+)") do--check for at least one "word"
			valid = true
			break
		end

		for x in string.gmatch(name, '[%[%]%(%)%|%<%>%*%/\\\"?]') do--check for open square bracket, etc
			valid = false
			break
		end

		--BEGIN_STRIP_DS
		if is_profane(name) then--Check against Profanity list
			valid =false
		end
		--END_STRIP_DS
	end
	return valid

end



function _G.ShowMemUsage(message)
--	ClearAutoLoadTables()
--	purge_garbage()
	LOG(message)
	local memusage = gcinfo()

	LOG(memusage .. " kb")

--[[
	for k,v in pairs(gcinfo2()) do
		LOG("" .. k .. ": " .. v)
	end
--]]
	--for i,v in pairs(SCREENS) do
		--LOG("Screen: " .. i .. " IsOpen? " .. tostring(v:IsOpen()))
	--end
end



_G.MASTER_TABLE =
{
	EVENTS;
	MAPS;
	PARTICLE_PATHS;
	BATTLEGROUNDS;
	PATTERNS;
	EFFECTS;
	DATA;
	GLOBAL_FUNCTIONS;
	SHIPS;
	WEAPONS;
	QUESTS;
	ITEMS;
	PSI;
	CREW;
	ENCOUNTERS;
	GEMS;
	GATES;
	HEROES;
	STARS;
	SATELLITES;
	BEAMS;
	ACTIONS;
	OBJECTIVES;
	CONDITIONS;
}



function _G.print_table(tbl)
	if type(tbl)=="table" then
		LOG("{")
		local comma = ""
		for i,v in pairs(tbl) do
			LOG(comma.."["..tostring(i).."]=")
			comma = ","
			if type(v)=="table" then
				_G.print_table(v)
			else
				LOG(tostring(v))
			end
		end
		LOG("}")
	end
end

function _G.ManageAssetGroups(menuName)
	_G.GLOBAL_FUNCTIONS["ManageAssetGroups"](menuName)
end

_G.OS_HALT = OS_HALT or function()
	while true do
	end
end
