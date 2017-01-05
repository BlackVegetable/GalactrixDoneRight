
--local SP = import("Steve_Profile")


local function Battle(sourceMenu,player1,player2,player3,player4,questID,objectiveID)
	ShowMemUsage("Battle() start")

	--assert(player1,"No Player 1 Obj")
	--assert(player1,"No Player 2 Obj")
	
	
	local event = GameEventManager:Construct("GameStart")

	local battleField = "B000"--QuickBattleField
	if questID and objectiveID then
		battleField = "B001"
	end
		
	
	--event:SetAttribute("gravity",player1:GetGravity())
	--SATELLITES[player1]
	
	event:PushAttribute('Players',player1)

	event:PushAttribute('Players',player2)
	-- set start events attributes
	-- add participants to event

	local function StartBattleCallback(confirm)
		--LOG("StartBattleCallback")	
		--SP.SP_Start(1,"StartBattleCallback Entry")
		
		if confirm then
			
			if _G.is_open("SolarSystemMenu") then
				SCREENS.SolarSystemMenu.encounter = nil
				SCREENS.SolarSystemMenu.encounter_friendly = nil
			end				
				
			_G.GLOBAL_FUNCTIONS.Backdrop.Open()			
				
			--SP.SP_Profile(1,"Opened Backdrop")
			local function OpenGameMenu()
				local sourceObject = player1
				if player1 ~= _G.Hero then
					sourceObject = nil
				end
				_G.CallScreenSequencer("CombatIntroMenu", "GameMenu",sourceMenu,sourceObject,battleField,event,questID,objectiveID)
			end
			
			if _G.is_open(sourceMenu) then
				LOG("Closed CombatIntro using sourceMenu")
				_G.CallScreenSequencer(sourceMenu, OpenGameMenu)
			else
				OpenGameMenu()
			end
	
		else
			_G.CallScreenSequencer("CombatIntroMenu", sourceMenu)
			if _G.is_open("SolarSystemMenu") then
				SCREENS[sourceMenu]:GetWorld():DeselectSatellite()
			end
		end	
		--SP.SP_Profile(1,"StartBattleCallback Exit")
	end

	
	SCREENS.CombatIntroMenu:Open(player2,StartBattleCallback)
	
	return true
end


local function QuestBattle(sourceMenu,questID,objectiveID,player1,player2,player3,player4)
	Battle(sourceMenu,player1,player2,player3,player4,questID,objectiveID)
end

return {["Battle"]=Battle;
		["QuestBattle"]=QuestBattle;
}