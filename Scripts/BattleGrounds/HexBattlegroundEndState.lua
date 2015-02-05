-- HexBattleGroundEndState
--  include these functions ONLY when the game is over and we need to access the end game screens
--

use_safeglobals()

local HEX_GRIDS =55 -- Matches value in InitBattleground.lua


local function RestartBattle(battleground)
	LOG("Restart Battle")

	battleground:ClearAttributeCollection("Effects")

	battleground.g1 = nil
	battleground.g2 = nil
	battleground.turn = {}
	battleground.turn_count = 0
	battleground.turn.turns = 1

	battleground:ResetTurn()
	battleground.moveList=nil
	battleground:InitGemList()--reset to base gems

	battleground.aboutToWin = nil
	battleground.aboutToWin = nil
	Sound.StopMusic();
	battleground.gameLost = false
	battleground.locked = false
	battleground.gateHacked = false




	local numPlayers = battleground:NumAttributes('Players')
	for i=1, numPlayers do
		local player = battleground:GetAttributeAt("Players",i)
		--player:InitBattleStats()--Reset battle
		battleground:InitHeroBattleStats(player)
		_G.SCREENS.GameMenu:UpdateEnergyUI(player)
	end

	battleground.preProcessLists = false

	battleground:InitTimer()
	battleground.TimeExpired =nil



	battleground.state = _G.STATE_INITIALIZING

	local e = GameEventManager:Construct("ClearBoard")
	GameEventManager:Send(e, battleground )



end



----------- CallBack Functions from end game dialogs
local function OnEventVictoryMenu(battleground,event)
	local winner = event:GetAttribute("winner_id")
	local statHero = event:GetAttribute("stat_hero")
	PlaySound("music_victory")
	battleground.state = STATE_GAME_OVER
	_G.SCREENS.GameMenu.victory = true
	local function VictoryCallback()
		local e = GameEventManager:Construct("GameEnd")
		e:SetAttribute('result',winner)
		local nextTime = GetGameTime() + (battleground:GetAttribute("game_end_delay"))
		GameEventManager:SendDelayed( e, battleground, nextTime )
	end

	if battleground.classIDStr == "B004" then
		if statHero.num_encounters > 0 then
			--BEGIN_STRIP_DS
			local function lessEncounter()
				statHero.num_encounters = statHero.num_encounters - 1
			end
			_G.NotDS(lessEncounter)
			--END_STRIP_DS
		end
		--SCREENS.SolarSystemMenu.num_encounters = SCREENS.SolarSystemMenu.num_encounters - 1
		statHero:SetSystemNeutral()
		--SCREENS.SolarSystemMenu.neutral_encounters = true
	end

	local cargoList
	local planList
	local factionTable
	local loser = 2
	if not battleground.mp then
		planList  = battleground:AwardPlans(winner)
		cargoList = battleground:AwardCargo(winner)
		factionTable = battleground:AdjustFactions(statHero,loser)
	end


	local shipPortrait
	if battleground:NumAttributes("Players") > 1 then
		local enemy = battleground:GetAttributeAt('Players',2)
		local ship = enemy:GetAttribute("curr_ship")
		shipPortrait = ship:GetAttribute("portrait")
	end
	battleground:OpenCombatResults(true,VictoryCallback,statHero, factionTable, planList, cargoList, shipPortrait)
end

local function OpenCombatResults(battleground, victory,callback, statHero, factionChange, planList, cargoList, shipPortrait)
   SCREENS.GameMenu:HideWidgets()

	if battleground.mp then
      LoadAssetGroup("AssetsButtons")
		--Graphics.FadeToBlack()

		SCREENS.MPResultsMenu:Open(victory,callback, statHero, factionChange, planList, cargoList)
	else
      LoadAssetGroup("AssetsButtons")
		Graphics.FadeToBlack()
		SCREENS.CombatResultsMenu:Open(victory,callback, statHero, factionChange, planList, cargoList, shipPortrait)
	end
end

local function OnEventLossMenu(battleground, event)
	PlaySound("music_defeat")

	local winner = event:GetAttribute("winner_id")
	battleground.state = STATE_GAME_OVER
	SCREENS.GameMenu.victory = false
	local function RestartCallback(confirmed)
		if confirmed then
			Sound.StopMusic();
			SCREENS.GameMenu:ShowWidgets()
			battleground:RestartBattle()
		else--No quits game
			local e = GameEventManager:Construct("GameEnd")
			e:SetAttribute('result',winner)
			local nextTime = GetGameTime() + battleground:GetAttribute("game_end_delay")
			GameEventManager:SendDelayed( e, battleground, nextTime )
		end
	end

	local shipPortrait
	if battleground:NumAttributes("Players") > 1 then
		local enemy = battleground:GetAttributeAt('Players',2)
		local ship = enemy:GetAttribute("curr_ship")
		shipPortrait = ship:GetAttribute("portrait")
	end

	battleground:OpenCombatResults(false,RestartCallback, event:GetAttribute("stat_hero"), nil, nil, nil, shipPortrait)
end


local function HandleEndGame(battleground, winner)

	LOG("HandleEndGame - Create GameOver message "..tostring(winner))
	battleground.state = STATE_GAME_OVER

	_G.GLOBAL_FUNCTIONS[string.format("Update%s",battleground.ui)]()

	_G.GLOBAL_FUNCTIONS.Pause.Close(false, false)
--	if is_yesno_menu_open() then -- if Quit menu is already open
--		close_yesno_menu(false, false)
--	end
   _G.SCREENS.GameMenu.waiting_to_quit = false

	local numPlayers = battleground:NumAttributes("Players")
	local player1 = battleground:GetAttributeAt("Players",1)
	if numPlayers == 1 or winner == 0 then--Mini-games
		LOG("mini-game send event")
      local loser = 0
		local e
		if winner == 0 then--lost single player game
			e = GameEventManager:Construct("LossMenu")
			--battleground:LossRestartMenu(winner,player1)
		else
			e = GameEventManager:Construct("VictoryMenu")
			-- battleground:VictoryMenu(winner,player1)
		end
		e:SetAttribute("winner_id",  winner)
		e:SetAttribute("stat_hero", player1)
		GameEventManager:SendDelayed(e, battleground, GetGameTime() + battleground:GetAttribute("game_end_delay"))

	elseif numPlayers == 2 then--standard battle
		local loser = battleground:GetEnemy(battleground:GetAttributeAt("Players",winner)):GetAttribute("player_id")
		battleground:GetAttributeAt("Players", winner):ResetCombatStats()

		--Player vs Player
		if battleground.mp then
			--LOG(string.format("PvsP victory %d",winner))
			local e = GameEventManager:Construct("GameEnd")--Constructed to be passed into GetReturnEvent only
			e:SetAttribute('result',winner)
			local returnEvent = battleground:GetReturnEvent(e,true)
			GameEventManager:Send(returnEvent,_G.Hero)--Send event now for MP only
			if winner == _G.Hero:GetAttribute("player_id") then
				local e = GameEventManager:Construct("VictoryMenu")
				e:SetAttribute("winner_id",  winner)
				e:SetAttribute("stat_hero", battleground:GetAttributeAt("Players", winner))
				GameEventManager:SendDelayed(e, battleground, GetGameTime() + battleground:GetAttribute("game_end_delay"))
				-- battleground:VictoryMenu(winner,battleground:GetAttributeAt("Players",winner),battleground:GetAttributeAt("Players",loser))
			else
				--battleground:LossRestartMenu(winner,battleground:GetAttributeAt("Players",winner),battleground:GetAttributeAt("Players",loser))
				local e = GameEventManager:Construct("LossMenu")
				e:SetAttribute("winner_id",  winner)
				e:SetAttribute("stat_hero", battleground:GetAttributeAt("Players", winner))
				GameEventManager:SendDelayed(e, battleground, GetGameTime() + battleground:GetAttribute("game_end_delay"))
			end
		elseif battleground:GetAttributeAt("Players",loser):GetAttribute("ai") == 1 then -- Player vs AI
			--LOG(string.format("P/AI vs AI victory %d",winner))
			local e = GameEventManager:Construct("VictoryMenu")
			e:SetAttribute("winner_id",  winner)
			e:SetAttribute("stat_hero", battleground:GetAttributeAt("Players", winner))
			GameEventManager:SendDelayed(e, battleground, GetGameTime() + battleground:GetAttribute("game_end_delay"))
			--battleground:VictoryMenu(winner,battleground:GetAttributeAt("Players",winner))
		else
			local e = GameEventManager:Construct("LossMenu")
			e:SetAttribute("winner_id",  winner)
			e:SetAttribute("stat_hero", battleground:GetAttributeAt("Players", loser))
			GameEventManager:SendDelayed(e, battleground, GetGameTime() + battleground:GetAttribute("game_end_delay"))
		end

	end


end


-------------------------------------------------------------------------------
-- Destroys all game objects, calls menu endGame function
-------------------------------------------------------------------------------
local function OnEventGameEnd(battleground, event)
	LOG("ENDSTATE OnEventEndGame()")
	if mp_is_host() then
		for i=1, HEX_GRIDS do
			LOG("clear gem @ "..tostring(i))
			--[[
			local gem = battleground:GetGem(i)
			if gem then
				battleground:ReleaseGem(gem)
				--LOG("Destroy Gem " .. gcinfo())
			end
			battleground:SetGem(i, nil)
			--]]
			battleground:DestroyGem(i)
		end

	end
    battleground.gems=nil

	if mp_is_host() then
	    --local numPatterns = battleground:NumAttributes('GamePatterns')

		local idList = {}
		for i,v in pairs(battleground.patternList) do
			table.insert(idList,i)
		end
	    for i,v in pairs(idList) do
	    	local pattern = battleground.patternList[v]
			battleground.patternList[v]=nil
	    	--local pattern = battleground:GetAttributeAt("GamePatterns",1)
	        --battleground:EraseAttribute('GamePatterns',pattern)
			--ClearPattern(pattern)
			LOG("ClearPattern "..tostring(v))
			GameObjectManager:Destroy(pattern)
			pattern = nil
	    end

		for j=1,battleground:NumAttributes("Effects") do
			local effect = battleground:GetAttributeAt("Effects",1)
			battleground:EraseAttribute("Effects",effect)
			GameObjectManager:Destroy(effect)
		end

		for i,v in pairs(battleground.removeEffects) do--destroy effects that are yet to be destroyed
			GameObjectManager:Destroy(v)
		end
	end

	battleground.removeEffects = {}

	local returnEvent = battleground:GetReturnEvent(event)

    local numPlayers = battleground:NumAttributes('Players')
    for i=1, numPlayers do
    	local player = battleground:GetAttributeAt("Players",1)

		player:SetAttribute("player_id",0)
		local numEffects = player:NumAttributes("Effects")
		local ship = player:GetAttribute("curr_ship")
		local numItems = ship:NumAttributes("battle_items")
		if mp_is_host() then
			--clean up any lingering effects
			for j=1,numEffects do
				local effect = player:GetAttributeAt("Effects",1)
				player:EraseAttribute("Effects",effect)
				GameObjectManager:Destroy(effect)
			end

			--clean up any player item objects
			for j=1,numItems do
				local item = ship:GetAttributeAt("battle_items",1)
				ship:EraseAttribute("battle_items",item)
				_G.GLOBAL_FUNCTIONS.ClearItem(item)
			end
		end
		battleground:EraseAttribute("Players", player)

		if player ~= _G.Hero and mp_is_host() then
			if battleground.mp then
				_G.GLOBAL_FUNCTIONS.ClearChar.ClearNetworkHero(player,battleground.host_id)
			else
				_G.GLOBAL_FUNCTIONS.ClearChar.ClearEnemy(player)
			end
			player = nil
		end

    end

	battleground:ClearAttributeCollection("Players")

	if _G.Hero then
		battleground:RemoveChild(_G.Hero)
	end
	_G.GLOBAL_FUNCTIONS["EndGame"](returnEvent)
end



local function AdjustFactions(battleground, statHero, loser)
	--LOG("Adjust Factions")
	local faction
	local factionTable
	if battleground:NumAttributes("Players") >= loser then
		loser = battleground:GetEnemy(statHero)
		--battleground:GetAttributeAt("Players", loser)
		if loser:GetAttribute("ai")==1 then
			local enemyFaction = loser:GetAttribute("faction")
			if enemyFaction ~= _G.FACTION_NONE then
				factionTable = { id = enemyFaction, amount = 10 }
				if statHero:GetFactionData(enemyFaction) == _G.FACTION_UNKNOWN then
					--statHero:PushAttribute("encountered_factions", enemyFaction)
					factionTable.amount = 15
				end
				_G.DATA.Factions[enemyFaction].forceEncounters = false
				local e = GameEventManager:Construct("RemoveFactionStatus")
				e:SetAttribute("faction", tostring(factionTable.id))
				e:SetAttribute("amount", factionTable.amount)
				e:SetAttribute("show", 0)
				GameEventManager:Send(e, statHero)
				if _G.DATA.Factions[enemyFaction].enemy and (not (statHero:GetFactionData(_G.DATA.Factions[enemyFaction].enemy) == _G.FACTION_UNKNOWN)) then
					local e = GameEventManager:Construct("GiveFactionStatus")
					e:SetAttribute("faction", tostring(_G.DATA.Factions[enemyFaction].enemy))
					e:SetAttribute("amount", factionTable.amount)
					e:SetAttribute("show", 0)
					factionTable.enemy = _G.DATA.Factions[enemyFaction].enemy
					GameEventManager:Send(e, statHero)
				else
					factionTable.enemy = nil
				end
			end
		end
	end

	return factionTable
end




local function AwardCargo(battleground, winner)
	if winner ~= 1 or battleground.mp or battleground:NumAttributes("Players") < 2 then
		return { } -- player lost or multiplayer or no opponent (minigame)
	end
	local loser = battleground:GetAttributeAt("Players", 2)
	winner = battleground:GetAttributeAt("Players", winner)
	local cargoList = { }

	for i = _G.NUM_CARGOES,1,-1 do
		local typeStr = string.format("cargo_%d_type",i)
		local amountStr = string.format("cargo_%d_amount",i)
		if HEROES[loser.classIDStr][typeStr] then
			table.insert(cargoList, HEROES[loser.classIDStr][typeStr], 2 * HEROES[loser.classIDStr][amountStr])
		end
	end

	local dropped = winner:AddCargo(cargoList) -- this is how much cargo we lose due to space restrictions
	for i,v in ipairs(dropped) do	--subtract dropped cargo from our totals
		if(v>0)then
			cargoList[i] = cargoList[i] - v
		end
	end
	return cargoList
end



local function AwardPlans(battleground, winner)
	if winner ~= 1 or battleground.mp or battleground:NumAttributes("Players") < 2 or _G.GLOBAL_FUNCTIONS.DemoMode() then
		return { } -- player lost or multiplayer or no opponent (minigame)    or trial version
	end
	local loser = battleground:GetAttributeAt("Players", 2)
	local ship = loser:GetAttribute("curr_ship")
	winner = battleground:GetAttributeAt("Players", winner)
	local awardPlans = { }


	--build plans list,
	local planList={}
	for i=1, winner:NumAttributes("plans") do
		local plan = winner:GetAttributeAt("plans",i)
		planList[plan]=true
	end

	-- prevent plans dropping for items removed from the game
	planList["I081"] = true
	planList["I092"] = true

	local loser_hero = HEROES[loser.classIDStr]
	if HEROES[loser.classIDStr]["drop_ship_plan"] == 100 and not planList[HEROES[loser.classIDStr]["init_ship"]] then
		table.insert(awardPlans, loser_hero["init_ship"])
		winner:PushAttribute("plans", loser_hero["init_ship"])
	end


	local sphere_plans = planList["SSGS"]

	if math.random(1,10) <= 3 then -- plans are to be awarded
		if math.random(1,4) <= 3 then
			-- award a 'quality plan'
			LOG("Quality plan")
			local ship = loser_hero["init_ship"]
			if math.random(1,2) == 1 and (CollectionContainsAttribute(winner, "crew", "C001") or sphere_plans) then
				if not planList[ship] and loser_hero["drop_ship_plan"] ~= 0 and loser_hero["drop_ship_plan"] ~= 100 then
					table.insert(awardPlans, ship)
					winner:PushAttribute("plans", ship)
				end
			end

			local item
			local itemList = { }
			local ship = loser:GetAttribute("curr_ship")
			for i=1, ship:NumAttributes("battle_items") do
				table.insert(itemList, ship:GetAttributeAt("battle_items", i).classIDStr)
			end

			local canCraftItems = false
			for i=1, winner:NumAttributes("crew") do
				local crew = winner:GetAttributeAt("crew", i)
				if crew == "C000" or crew == "C001" or sphere_plans then
					canCraftItems = true
				end
			end

			local i = #itemList
			if math.random(1,3) < 3 and canCraftItems then
				while i > 0 do
					local index = math.random(1, i)
					local item = table.remove(itemList, index)

					--cost==0 = invalid item
					--rarity == 10 = Faction Specific Items - these shouldn't be awarded here
					if not planList[item] and (ITEMS[item].cost ~= 0 or ITEMS[item].rarity ~= 10) then
						table.insert(awardPlans, item)
						winner:PushAttribute("plans", item)
						i = 0
					else
						i = i - 1
					end
				end
			end
		else
			-- award a 'random plan'
			LOG("Random Plan")
			local planID
			if CollectionContainsAttribute(winner, "crew", "C001") or sphere_plans then
				planID = math.random(1,184) -- can award items or ships
			elseif CollectionContainsAttribute(winner, "crew", "C000") then
				planID = math.random(1,161) -- can award items
			end

			if planID then
				if planID > 161 then
					local shipList = {
						"SMBL", "STDS", "SSMT", "SCBS", "SPWS", "SLWS", "SELF", "SKTS", "SMPA", "SCTN", "STWS",
						"SDMS", "SCMA", "SLHC", "SVHC", "SSHL", "SJHS", "SPSS", "SQLS", "STDG", "SMRM",
						"SVDR", "STBS", }
					local plan = shipList[planID-161]
					if not planList[plan] then
						winner:PushAttribute("plans", plan)
						table.insert(awardPlans, plan)
					end
				else

				-- Balance Mod New Items Edit (Non-Psi weaponry) --
					local newLuck = math.random(1,100)
					if newLuck <= 4 then
						planID = math.random(310,333)
					end
				-- This will give a 4% chance to give a plan for one of the new (non-psi) items instead. --

					local plan = string.format("I%03d", planID)
					if not planList[plan] then
						winner:PushAttribute("plans", plan)
						table.insert(awardPlans, plan)
					end
				end
			end
		end
	end
	--[[
	if math.random(1,100) <= HEROES[loser.classIDStr]["drop_ship_plan"] and CollectionContainsAttribute(winner, "crew", "C001") then
		local ship = HEROES[loser.classIDStr]["init_ship"]
		if not planList[ship] then
			table.insert(awardPlans, ship)
			winner:PushAttribute("plans", ship)
		end
	end

	local item
	local itemList = { }
	local numItems = ship:NumAttributes("battle_items")
	for i=1, numItems do
		item = ship:GetAttributeAt("battle_items",i).classIDStr
		table.insert(itemList, item)
	end

	local canCraftItems = false
	for i=1, winner:NumAttributes("crew") do
		local crew = winner:GetAttributeAt("crew", i)
		if crew == "C000" or crew == "C001" then
			canCraftItems = true
		end
	end

	local i = #itemList
	if math.random(1,100) <= HEROES[loser.classIDStr]["drop_item_plan"] and canCraftItems then
		while i > 0 do
			local index = math.random(1, i)
			local item = table.remove(itemList, index)

			if ITEMS[item].cost > 0 and not planList[item] then
				table.insert(awardPlans, item)
				winner:PushAttribute("plans", item)
				i = 0
			else
				--table.remove(itemList, index)
				i = i - 1
			end
		end
	end
]]--
	planList = nil

	return awardPlans
end


local HBG_StartEndState =
{
	RestartBattle = RestartBattle,
	OnEventVictoryMenu = OnEventVictoryMenu,
	OpenCombatResults = OpenCombatResults,
	OnEventLossMenu = OnEventLossMenu,
	HandleEndGame = HandleEndGame,
	OnEventGameEnd = OnEventGameEnd,
	--OnEventGameStart = OnEventGameStart,
 	AdjustFactions = AdjustFactions,
 	AwardCargo = AwardCargo,
 	AwardPlans = AwardPlans,
}

return HBG_StartEndState

