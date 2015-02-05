
function EncounterBattle(sourceMenu,encounter,player1,player2,player3,player4)
	LOG("EncounterBattle()")		
	local event = GameEventManager:Construct("GameStart")
		
	event:SetAttribute("gravity",player1:GetGravity())
		
		
		
	event:PushAttribute('Players',player1)
	event:PushAttribute('Players',player2)
	-- set start events attributes
	-- add participants to event
		
	
	
	local function StartEncounterCallback(confirm)
		LOG("StartEncounter callback")
		--StartEncounter(confirm,sourceMenu,encounter,player1,player2,player3,player4,event)
		if confirm then	
			SCREENS[sourceMenu]:GetWorld():RemoveChild(player2)
			local enc = player2.encounter
			if enc.targetObj then
				player1.encounterTargeted = true
			end
			player2:RemoveChild(enc)
			GameObjectManager:Destroy(enc)
			player2.encounter = nil
			
			--SCREENS[sourceMenu]:Close()	
			local function OpenGameMenu()
				_G.GLOBAL_FUNCTIONS.Backdrop.Open()			
				_G.CallScreenSequencer("EncounterIntroMenu", "GameMenu",sourceMenu,player1,"B004",event)
			end

			SCREENS.EncounterIntroMenu:Close()	
			if _G.is_open(sourceMenu) then
				LOG("Closed EncounterIntro using sourceMenu")
				_G.CallScreenSequencer(sourceMenu, OpenGameMenu)
			else
				OpenGameMenu()
			end
	
		
			-- send event to world
			--GameEventManager:Send( event, SCREENS.GameMenu:GetWorld() )	
		else
				--local encounter = player2:GetChild(0)

				--LOG("cancel encounter")
			if encounter.targetObj then--Enemy encounter
				--LOG("Flee system")
				if not _G.is_open("SolarSystemMenu") then
					_G.CallScreenSequencer("EncounterIntroMenu", "SolarSystemMenu",_G.FLEE_SYSTEM)
				else
					local function transition()
						SCREENS.EncounterIntroMenu:Close()
						--SCREENS.SolarSystemMenu:FleeSystem()
						GLOBAL_FUNCTIONS["FleeSystem"]("SolarSystemMenu")
					end
					SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "MapMenu")		
				end
			else
				if not _G.is_open("SolarSystemMenu") then
					--LOG("CallScreenSequencer EncounterIntro to SolarSystemMenu")
					_G.CallScreenSequencer("EncounterIntroMenu", "SolarSystemMenu",_G.ABANDON_ENCOUNTER)
				else
					SCREENS.SolarSystemMenu:ShowWidgets()					
					--LOG("Close EncounterIntro to SolarSystemMenu")
					SCREENS.EncounterIntroMenu:Close()
					SCREENS.SolarSystemMenu:GetWorld():DeselectSatellite()
				end
				
			end		
		end			
	end
	--Determine context sensitive menu options here
	--ie - if encounter.targetObj then  ok/cancel cancel=expulsion from system
	local enc = player2.encounter	
	
	
	--OpenEncounterMenu(StartEncounterCallback,player2,sourceMenu)
	_G.LoadAssetGroup("AssetsBattleGround")	
	LOG("Opened encounter intro menu")
	Gamepad.Rumble(PlayerToUser(1), 0.5, 450)	
	SCREENS.EncounterIntroMenu:Open(player2, StartEncounterCallback, enc.targetObj ~= nil,enc.contraband_detected)
	return true
end

return EncounterBattle
