

local function ClearChar(charObj)
	LOG("ClearChar")
	local ship = charObj:GetAttribute("curr_ship")
	if ship then		
		GameObjectManager:Destroy(ship)
		charObj:SetAttribute("curr_ship",nil)
		ship = nil
	end
	local numLoadouts = charObj:NumAttributes("ship_list")
	for i=numLoadouts,1,-1 do
		local loadout = charObj:GetAttributeAt("ship_list",i)		
		charObj:EraseAttribute("ship_list",loadout)
		GameObjectManager:Destroy(loadout)		
		loadout = nil
	end
	
	
	GameObjectManager:Destroy(charObj)
	charObj = nil
	LOG(gcinfo());	
end


local function ClearHero(HeroObj)
	if HeroObj then
		local numQuests = HeroObj:NumAttributes("running_quests")
		for i=1,numQuests do
			local questID = HeroObj:GetAttributeAt("running_quests",1):GetQuestID()
			_G.RemoveRunningQuest(HeroObj, questID)
		end
		ClearChar(HeroObj)
	end	
end
	
local function ClearEnemy(enemyObj)
	ClearChar(enemyObj)
end	

local function ClearNetworkHero(hero,host_id)
	LOG("ClearNetworkHero ")
	if hero then
		local event = GameEventManager:Construct("ClearNetworkHero")
		
		local ship = hero:GetAttribute("curr_ship")
		
		assert(ship,"ClearNetworkHero -> No ship")
		--if hero:GetAttribute("curr_ship") then
			event:PushAttribute("ship",ship)
			hero:SetAttribute("curr_ship",nil)
		--end
		event:PushAttribute("hero",hero)	
		for i=1,hero:NumAttributes("ship_list") do
			event:PushAttribute("loadout",hero:GetAttributeAt("ship_list",i))
		end
		hero:ClearAttributeCollection("ship_list");
				
		
		local curr_menu
		if _G.is_open("MultiplayerGameSetup") then
			curr_menu = SCREENS.MultiplayerGameSetup
		elseif _G.is_open("MPLobby") then
			curr_menu = SCREENS.MPLobby
		else
			curr_menu = SCREENS.GameMenu
		end
		
		if curr_menu.my_id == host_id then
			LOG("I'm the host - just call doONreceive'")
			event:do_OnReceive()--speed up receipt of this event
		else
			LOG("Send event")
			GameEventManager:Send(event,host_id)
		end
		
		ship = nil
	end
end	

return {["ClearEnemy"]=ClearEnemy;
		["ClearHero"]=ClearHero;
		["ClearNetworkHero"]=ClearNetworkHero;
}
