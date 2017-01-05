-- StartMPBattle 
--When Players change Hero to use in MP
--This is sent to server to replicate outward.

use_safeglobals()






class "StartMPBattle" (GameEvent)

StartMPBattle.AttributeDescriptions = AttributeDescriptionList()

StartMPBattle.AttributeDescriptions:AddAttribute('int', 'locked', {default=0,serialize= 1})

StartMPBattle.AttributeDescriptions:AddAttributeCollection('GameObject', 'BattleGround', {serialize= 1})
StartMPBattle.AttributeDescriptions:AddAttributeCollection('GameObject', 'remotePlayers', {})
StartMPBattle.AttributeDescriptions:AddAttributeCollection('GameObject', 'GamePatterns', {serialize= 1})
StartMPBattle.AttributeDescriptions:AddAttributeCollection('string', 'patterns', {serialize= 1})
StartMPBattle.AttributeDescriptions:AddAttributeCollection('GameObject', 'battle_items_1', {serialize= 1})
StartMPBattle.AttributeDescriptions:AddAttributeCollection('GameObject', 'battle_items_2', {serialize= 1})

StartMPBattle.AttributeDescriptions:AddAttributeCollection('string', 'item_list_1', {serialize= 1})
StartMPBattle.AttributeDescriptions:AddAttributeCollection('string', 'item_list_2', {serialize= 1})

StartMPBattle.AttributeDescriptions:AddAttributeCollection('string', 'mp_id', {serialize= 1})



function StartMPBattle:__init()
    super("StartMPBattle")
    LOG("StartMPBattle Init()")
	self:SetSendToSelf(false)
end



function StartMPBattle:do_OnReceive()
	LOG("StartMPBattle OnReceive() "..tostring(SCREENS.MultiplayerGameSetup.my_player_id))
	--and add an entry to the log
	
	if self:GetAttribute("locked")==0 then--On receipt by Client
		if not mp_is_host() then
			LOG("StartMPBattle Lock check client")			
			if SCREENS.MultiplayerGameSetup.ready[SCREENS.MultiplayerGameSetup.my_player_id]==1 then
				local ready_widget = "ready_"..SCREENS.MultiplayerGameSetup:GetMultiplayerScreenPosition(SCREENS.MultiplayerGameSetup.my_player_id)
				SCREENS.MultiplayerGameSetup:deactivate_widget(ready_widget)
				SCREENS.MultiplayerGameSetup:set_text("str_heading","[GAME_STARTING]")
				self:SetAttribute("locked",1)
			else--ready status changed in client - abort start-mp-battle
				LOG("StartMPBattle Lock check client - ABORTED")						
			end
			GameEventManager:Send(self,SCREENS.MultiplayerGameSetup.host_id)--Ready or not - send reply to host
		else--host receives "client not ready" 
			LOG("StartMPBattle Lock failed - Activate Hosts ready widget")	
			local ready_widget = "ready_"..SCREENS.MultiplayerGameSetup:GetMultiplayerScreenPosition(SCREENS.MultiplayerGameSetup.my_player_id)
			SCREENS.MultiplayerGameSetup:activate_widget(ready_widget)			
		end

	elseif self:NumAttributes("BattleGround") == 0  then--On Receipt by host
		LOG("Create BattleGround Network objects "..tostring(SCREENS.MultiplayerGameSetup.my_player_id))
		if not mp_is_host() or SCREENS.MultiplayerGameSetup.game_starting then--not host, or already starting a game then 
			return--bail out
		end
		SCREENS.MultiplayerGameSetup.game_starting = true
		--Start Mp battle on both client and Host
		self:SetSendToSelf(true)
		local battleGround = GameObjectManager:Construct("B101")
		self:PushAttribute("BattleGround",battleGround)
		for i=1, self:NumAttributes("item_list_1") do
			self:PushAttribute("battle_items_1",GameObjectManager:Construct("Item"))
		end
		for i=1, self:NumAttributes("item_list_2") do
			self:PushAttribute("battle_items_2",GameObjectManager:Construct("Item"))
		end
		for i,_ in pairs(battleGround.patternList) do
			local pattern = GameObjectManager:Construct(_G.PATTERNS[i].obj)
			self:PushAttribute("GamePatterns",pattern)
			self:PushAttribute("patterns",i)
		end
		
		GameEventManager:Send(self)--Broadcast event.
	else--MP Battle game objects created -- Open each players GameMenus
		LOG("Create GameStart Event - send to battleground of player "..tostring(SCREENS.MultiplayerGameSetup.my_player_id))
		local startEvent = GameEventManager:Construct("GameStart")
		startEvent:PushAttribute("mp_id","")
		startEvent:PushAttribute("mp_id","")
		startEvent:PushAttribute("Players",_G.Hero)
		startEvent:PushAttribute("Players",_G.Hero)
		for i,v in pairs(SCREENS.MultiplayerGameSetup.players) do--for each player
			local ship = v:GetAttribute("curr_ship")
			local player_id = v:GetAttribute("player_id")
			LOG(tostring(player_id).." has items totalling "..tostring(self:NumAttributes("battle_items_"..tostring(player_id))))
			for j=1, self:NumAttributes("battle_items_"..tostring(player_id)) do--Add players items
				ship:PushAttribute("battle_items",_G.GLOBAL_FUNCTIONS.LoadItem(self:GetAttributeAt(string.format("item_list_%d", player_id),j),self:GetAttributeAt(string.format("battle_items_%d", player_id),j)))
			end
			startEvent:SetAttributeAt("Players",player_id,v)
		end
		for i=1, self:NumAttributes("mp_id") do
			startEvent:SetAttributeAt("mp_id",i,self:GetAttributeAt("mp_id",i))
		end
		local battleGround = self:GetAttributeAt("BattleGround",1)
		for i=1, self:NumAttributes("GamePatterns") do
			--battleGround:PushAttribute("GamePatterns",_G.GLOBAL_FUNCTIONS.LoadPattern(self:GetAttributeAt("patterns",i),self:GetAttributeAt("GamePatterns",i)))
			local patternID = self:GetAttributeAt("patterns",i)
			--battleGround.patternList[patternID]=_G.GLOBAL_FUNCTIONS.LoadPattern(patternID,self:GetAttributeAt("GamePatterns",i))
			startEvent:PushAttribute("GamePatterns",_G.GLOBAL_FUNCTIONS.LoadPattern(patternID,self:GetAttributeAt("GamePatterns",i)))
		end
		
		if SCREENS.MultiplayerGameSetup.inventory_player then
			SCREENS.MultiplayerGameSetup:CloseInventory()
		end
		SCREENS.MultiplayerGameSetup.players={}
		close_custompopup_menu()
			
		_G.CallScreenSequencer("MultiplayerGameSetup","GameMenu","MultiplayerGameSetup",_G.Hero,battleGround,startEvent)
		
		local function transition()
		end
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "GameMenu", nil, 3000, true)				
		
	end
	
end



return ExportClass("StartMPBattle")
