-------------------------------------------------------------------------------
--
--   InitBattlegroundPlatform.lua
--
--		Code to hand back some initialized tables with generic values
--
-------------------------------------------------------------------------------

--STOP SPLITTING UP MY FILES FOR NO REASON
--local GRID_FUNCS = dofile("Assets/Scripts/BattleGrounds/InitBattlegroundGrid.lua")
--local FillGrid = GRID_FUNCS.FillGrid

--This function Not Platform Specific - Keep in Sync
local function OnEventGameStart(battleground, event)
		LOG("NOPLATFORM InitBattlegroundPlatform::OnEventGameStart")

		battleground:InitBattle()


		--Sets count down timer for battle - default = 0/no timer
		local time_limit = event:GetAttribute("time_limit")
		if time_limit > 0 then
			battleground:SetAttribute("timer", time_limit)
		end
		--Set counter -- must be done before end_turn when The timer is initialized.
		battleground:SetAttribute("counter",battleground:GetAttribute("timer"))


		for i=1, event:NumAttributes('Players') do
			battleground:PushAttribute("Players",nil)
		end

		for i=1, event:NumAttributes('Players') do
			assert (i<3,"More than 2 players, not yet supported")

			local player = event:GetAttributeAt('Players',i)
			local team = player:GetAttribute("team")

			player:SetToSave()

			if event:NumAttributes("mp_id") >= i then

				battleground.mp = true
				player:SetAttribute("gui_id",player:GetAttribute("player_id"))

				--if tostring(battleground.my_id) == event:GetAttributeAt("mp_id",i) then
				if _G.Hero:GetAttribute("player_id")==player:GetAttribute("player_id") then
					battleground.my_player_id = player:GetAttribute("player_id")
				else
					battleground.opponent_id = _G.GLOBAL_FUNCTIONS.Multiplayer.GetPlayerID(player:GetAttribute("player_id"))
				end

				battleground:InitHeroBattleStats(player)
			else
				battleground.my_player_id = 1
				battleground.opponent_id = battleground.my_player_id--single_player
				player:SetAttribute("player_id",i)
				player:SetAttribute("gui_id",i)

				battleground:InitHeroBattleStats(player)

				local ship = player:GetAttribute("curr_ship")
				ship:BattleItemsFromLoadout(player:GetAttributeAt("ship_list",player:GetAttribute("ship_loadout")), player)

			end
			battleground:SetAttributeAt('Players',player:GetAttribute("player_id"),player)
			player:GetAttribute("curr_ship"):SetPos(battleground:WorldToGrid(battleground.coords[i]["shield"][1],battleground.coords[i]["shield"][2]))--set position of Hero


			player.damage_bonus = math.floor((player:GetLevel())/10)
			--_G.Blog(string.format("Added Player #%d",i))
		end

		SCREENS.GameMenu.my_id = battleground.my_id
		--SCREENS.GameMenu.my_player_id = _G.Hero:GetAttribute("player_id")
		SCREENS.GameMenu.host_id = battleground.host_id
		SCREENS.GameMenu.opponent_id = battleground.opponent_id
		LOG("Set GameMenu.opponent_id to "..tostring(SCREENS.GameMenu.opponent_id))


		if not battleground.mp then
			for pattern,_ in pairs(battleground.patternList) do
				battleground.patternList[pattern]=_G.GLOBAL_FUNCTIONS.LoadPattern(pattern)
			end
		else
			for i=1, event:NumAttributes("GamePatterns") do
				local pattern = event:GetAttributeAt("GamePatterns",i)
				battleground.patternList[pattern.classIDStr]=pattern
			end
		end




		battleground.state = _G.STATE_INITIALIZING
		--if board is specified - grid will be initialized with those specified gems
		--otherwise will be random unmatching board
		battleground:FillGrid(battleground:GetFillList())--use Local call since we're here



		_G.GLOBAL_FUNCTIONS[string.format("Init%s",battleground.ui)]()
		_G.ClearAutoLoadTables()


end

--[[ no longer in platform file
--these are screen coordinates - not world coordinates
local function InitCoords(world)
	world.messageList = {}

    world.coords={}
    world.coords[1] = {}
    world.coords[2] = {}
    world.coords[3] = {}
	world.coords[3]["Effect"] = {510,97}

	world.coords[1]["Effect"] = {230,104}
    world.coords[1]["weapon"]={200,483}
    world.coords[1]["engine"]={195,455}
    world.coords[1]["cpu"]={190,428}
    world.coords[1]["shield"]={240,582}
    world.coords[1]["intel"]={59,406}
    world.coords[1]["psi"]={96,384}
    --world.coords[1]["damage"]={150,638}
    --world.coords[1]["damage"]={240,582}
    world.coords[1]["ship"]={100,640}
    world.coords[1]["damage"]={156,568}
    world.coords[1]["life"]={156,568}
    world.coords[1]["key"]={890,654}
    world.coords[1]["time"]={512,674}
    world.coords[1]["hack"]={865,579}
    world.coords[1]["cargo_food"]={890,654}
    world.coords[1]["cargo_textiles"]={890,654}
    world.coords[1]["cargo_minerals"]={890,654}
    world.coords[1]["cargo_alloys"]={890,654}
    world.coords[1]["cargo_tech"]={890,654}
    world.coords[1]["cargo_luxuries"]={890,654}
    world.coords[1]["cargo_medicine"]={890,654}
    world.coords[1]["cargo_gems"]={890,654}
    world.coords[1]["cargo_gold"]={890,654}
    world.coords[1]["cargo_contraband"]={890,654}
    world.coords[1]["components_weap"]={890,654}
	 world.coords[1]["components_eng"]={890,654}
	 world.coords[1]["components_cpu"]={890,654}
    world.coords[1]["item"]={}
    world.coords[1]["item"][1]={30,340}--361}
    world.coords[1]["item"][2]={30,448}--320}
    world.coords[1]["item"][3]={30,486}--282}
    world.coords[1]["item"][4]={34,528}--240}
    world.coords[1]["item"][5]={45,567}--201}
    world.coords[1]["item"][6]={56,606}--162}
    world.coords[1]["item"][7]={74,647}--121}
    world.coords[1]["item"][8]={110,687}--81}

	world.coords[2]["Effect"] = {790,104}
    world.coords[2]["weapon"]={820,483}
    world.coords[2]["engine"]={825,455}
    world.coords[2]["cpu"]={830,428}
    world.coords[2]["shield"]={784,582}
    world.coords[2]["intel"]={960,406}
    world.coords[2]["psi"]={930,384}
    --world.coords[2]["damage"]={894,638}
    --world.coords[2]["damage"]={784,582}
    world.coords[2]["ship"]={930,640}
    world.coords[2]["damage"]={894,568}
    world.coords[2]["life"]={894,568}
    world.coords[2]["key"]={833,596}
    world.coords[2]["time"]={512,674}
    world.coords[2]["cargo_food"]={833,596}
    world.coords[2]["cargo_textiles"]={833,596}
    world.coords[2]["cargo_minerals"]={833,596}
    world.coords[2]["cargo_alloys"]={890,654}
    world.coords[2]["cargo_tech"]={890,654}
    world.coords[2]["cargo_luxuries"]={890,654}
    world.coords[2]["cargo_medicine"]={890,654}
    world.coords[2]["cargo_gems"]={890,654}
    world.coords[2]["cargo_gold"]={890,654}
    world.coords[2]["cargo_contraband"]={890,654}
    world.coords[2]["item"]={}
    world.coords[2]["item"][1]={990,340}
    world.coords[2]["item"][2]={840,448}
    world.coords[2]["item"][3]={832,486}
    world.coords[2]["item"][4]={822,528}
    world.coords[2]["item"][5]={806,567}
    world.coords[2]["item"][6]={790,606}
    world.coords[2]["item"][7]={768,647}
    world.coords[2]["item"][8]={740,687}


	world.beamEffects = {}
	world.beamEffects["life"] 	= "BM12"
	world.beamEffects["damage"] = "BM01"
	world.beamEffects["ship"] 	= "BM01"
	world.beamEffects["shield"] = "BM02"
	world.beamEffects["intel"] 	= "BM12"
	world.beamEffects["psi"] 	= "BM11"
	world.beamEffects["weapon"] = "BM08"
	world.beamEffects["engine"] = "BM05"
	world.beamEffects["cpu"] 	= "BM04"

	world.effectFont = {}
	world.effectFont["life"] = "font_numbers_white"
	world.effectFont["shield"] = "font_numbers_blue"
	world.effectFont["intel"] = "font_numbers_white"
	world.effectFont["psi"] = "font_numbers_purple"
	world.effectFont["weapon"] = "font_numbers_red"
	world.effectFont["engine"] = "font_numbers_yellow"
	world.effectFont["cpu"] = "font_numbers_green"

end
--]]

local PLATFORM_FUNCS = {
	OnEventGameStart = OnEventGameStart,
	InitCoords = InitCoords,
}

return PLATFORM_FUNCS
