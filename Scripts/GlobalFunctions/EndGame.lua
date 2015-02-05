
-------------------------------------------------------------------------------
--    EndGame  -- called at the end of a battle game
--    event - the end game event
-------------------------------------------------------------------------------
function EndGame(event)--event to send to source
	LOG("Menu:EndGame()")
	local menu = SCREENS.GameMenu
	local questEvent
	local sourceMenu = menu.sourceMenu

	menu.gemCycle = nil
	
	local sourceObject = menu.sourceObject
	local function sendQuestEvent()
		if event then
			GameEventManager:Send( event, sourceObject)			
		end		
	end	
	
	if menu.sourceObject and menu.world and not menu.world.mp then
		--LOG("Send Event to source")
		--Graphics.FadeToBlack()		
		if event and menu.questID and menu.objectiveID then
			LOG(string.format("add quest details to %s",event:GetName()))
			event:SetAttribute("questID",menu.questID)
			event:SetAttribute("objectiveID",menu.objectiveID)
		end
		--Send result event to source object	
		if sourceMenu ~= "SolarSystemMenu" then
			sendQuestEvent()			
		end
	end	
	
	Sound.StopMusic();

	menu.sourceObject = nil	
	menu.sourceMenu = nil

	if sourceMenu == "SolarSystemMenu" then			
		SCREENS.GameMenu:Finalize()

		if sourceObject.encounterTargeted and not SCREENS.GameMenu.victory then -- this means its an encounter that wants to kick it out of the system
			sourceObject.encounterTargeted = nil
			GLOBAL_FUNCTIONS["FleeSystem"]("GameMenu")
		else
			sourceObject.encounterTargeted = nil
			_G.CallScreenSequencer("GameMenu", sourceMenu, nil, nil, nil, nil, sendQuestEvent)

		end
	else--if Quick/MP Battle
		local function continue()
			SCREENS.GameMenu:Finalize()
			
			_G.CallScreenSequencer("GameMenu", sourceMenu)

		end

		if sourceMenu == "SinglePlayerMenu" then--if actual hero save --not mp battle
			_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero, continue)	
		else			
			continue()			
		end

	end
	
	return true
end


return EndGame