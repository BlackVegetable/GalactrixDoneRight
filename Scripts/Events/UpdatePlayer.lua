-- UpdatePlayer 
--When Players change Hero to use in MP
--This is sent to server to replicate outward.

use_safeglobals()






class "UpdatePlayer" (GameEvent)

UpdatePlayer.AttributeDescriptions = AttributeDescriptionList()

UpdatePlayer.AttributeDescriptions:AddAttributeCollection('GameObject', 'hero', {serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttributeCollection('GameObject', 'curr_ship', {serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttributeCollection('GameObject', 'ship_list', {serialize= 1})


UpdatePlayer.AttributeDescriptions:AddAttribute('string', 'mp_id', {serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'player_id', {default=1,serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttribute('string', 'mp_name', {default="",serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttribute('string', 'name', {default="",serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttribute('string', 'portrait', {default="",serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'male', {default=1,serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttributeCollection('string', 'ships', {serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttributeCollection('string', 'battle_items', {serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'ship_loadout', {default=1,serialize= 1})

UpdatePlayer.AttributeDescriptions:AddAttributeCollection('string', 'items', {serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttributeCollection('string', 'ships', {serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttributeCollection('string', 'defeated', {serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttributeCollection('int', 'cargo', {serialize= 1})

UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'pilot', {default=0,serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'gunnery', {default=0,serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'engineer', {default=0,serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'science', {default=0,serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'intel', {default=0,serialize= 1})
UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'psi', {default=0,serialize= 1})


UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'player_ready', {default=0,serialize= 1})


UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'slot', {default=1,serialize=1})

UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'ai', {default=0,serialize= 1})


UpdatePlayer.AttributeDescriptions:AddAttribute('int', 'mp_enemy', {default=0,serialize= 1})



function UpdatePlayer:__init()
    super("UpdatePlayer")
    LOG("UpdatePlayer Init()")
	self:SetSendToSelf(false)
end



function UpdatePlayer:do_OnReceive()
	LOG("UpdatePlayer OnReceive(), Num Attributes(\'hero\')= "..self:NumAttributes("hero"))
	--and add an entry to the log

	if _G.is_open("MultiplayerGameSetup") then--This could be removed, but may leave the DS Host doing a little too much at once.
		--will be removed for PC/XBox
	if self:NumAttributes("hero") == 1 then
		if _G.is_open("MultiplayerGameSetup") then
			LOG("UpdatePlayer my_id "..tostring(SCREENS.MultiplayerGameSetup.my_id))
			LOG("UpdatePlayer Event Set Object Attributes "..tostring(SCREENS.MultiplayerGameSetup.my_player_id))
							
			local hero = self:GetAttributeAt("hero",1)
			local ship = self:GetAttributeAt("curr_ship",1)
			
			hero:SetAttribute("ship_loadout",self:GetAttribute("ship_loadout"))
			for i=1, self:NumAttributes("ship_list") do
				local loadout = self:GetAttributeAt("ship_list",i)
				loadout:SetAttribute("ship",self:GetAttributeAt("ships",i))
								
				if i == hero:GetAttribute("ship_loadout") then--Add items to current loadout only
					for j=1, self:NumAttributes("battle_items") do
						loadout:PushAttribute("items", self:GetAttributeAt("battle_items",j))
					end
				end
				hero:PushAttribute("ship_list",loadout)				
			end
			
			ship = _G.GLOBAL_FUNCTIONS.LoadShip(hero:GetAttributeAt("ship_list",hero:GetAttribute("ship_loadout")):GetAttribute("ship"),ship)
			hero:SetAttribute("curr_ship",ship)
			ship.pilot = hero
			hero:SetAttribute("player_id",self:GetAttribute("player_id"))
			hero:SetAttribute("name",self:GetAttribute("name"))
			hero:SetAttribute("portrait",self:GetAttribute("portrait"))
			hero:SetAttribute("male",self:GetAttribute("male"))
	
			hero:SetAttribute("pilot",self:GetAttribute("pilot"))
			hero:SetAttribute("gunnery", self:GetAttribute("gunnery"))
			hero:SetAttribute("engineer",self:GetAttribute("engineer"))
			hero:SetAttribute("science",self:GetAttribute("science"))
			hero:SetAttribute("intel",self:GetAttribute("intel"))
			hero:SetAttribute("psi",self:GetAttribute("psi"))
			
			
			if self:GetAttribute("mp_enemy") == 1 then
				hero.mp_enemy = true
				ship:SetAttribute("model",hero:GetAttribute("name"))
			end
			--[[
			--local update_id =  _G.GLOBAL_FUNCTIONS.Multiplayer.GetPlayerID(hero:GetAttribute("player_id"))
			local mp_id_str = self:GetAttribute("mp_id")
			local update_id
			if string.char(string.byte(mp_id_str))=="-" then
				mp_id_str = string.gsub(mp_id_str,"-","")
				--LOG("UpdatePlayer: update_id = "..tostring(mp_id_str))
				update_id = tonumber(mp_id_str)
				update_id = -update_id
			else
				update_id = tonumber(mp_id_str)
			end			
			--]]
			
			local opponent
			--LOG("UpdatePlayer: update_id = "..tostring(self:GetAttribute("mp_id")))
			--LOG("UpdatePlayer: update_id = "..tostring(update_id))
			--		
			if SCREENS.MultiplayerGameSetup.my_player_id ~= hero:GetAttribute("player_id") then--Not updating self - Player Obj being received by opponent
				--SCREENS.MultiplayerGameSetup.opponent_id = update_id
				opponent = true
				LOG("set Opponent_id")			
			end				
					
			LOG("player set at "..tostring(update_id))
			SCREENS.MultiplayerGameSetup.players[hero:GetAttribute("player_id")] = hero
			if opponent then
				SCREENS.MultiplayerGameSetup:SetPlayerReady(hero:GetAttribute("player_id"),self:GetAttribute("player_ready"))
				--SCREENS.MultiplayerGameSetup:UpdateHero(hero)			--TEMP MOVE TO LINE UNDERNEATH			
			end			
			SCREENS.MultiplayerGameSetup:UpdateHero(hero)
		end
		
	else
		if mp_is_host() then
			self:SetSendToSelf(true)
			--LOG("UpdatePlayer Event Construct Objects on HOST "..tostring(SCREENS.MultiplayerGameSetup.my_player_id))
			self:PushAttribute("hero", GameObjectManager:Construct("Hero"))
			--self:PushAttribute("hero", gchelpers.watchnewgameobject("Hero"))
			for i=1, self:NumAttributes("ships") do
				self:PushAttribute("ship_list", GameObjectManager:Construct("IL00"))
			end
			self:PushAttribute("curr_ship", GameObjectManager:Construct("Ship"))
			LOG("Send Newly Constructed GameObjects to everyone")
			GameEventManager:Send(self)
		else
			LOG("No longer host")
		end	
	end
	end
end



return ExportClass("UpdatePlayer")
