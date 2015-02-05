use_safeglobals()
		
-- declare our screen
class "MultiplayerGameSetup" (Menu);

dofile("Assets/Scripts/Screens/MultiplayerGameSetupPlatform.lua")

function MultiplayerGameSetup:__init()
	LOG("MultiplayerGameSetup:__init()")
	super()
	--self:LoadGraphics()
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\MultiPlayerGameSetup.xml")
	
	-- our id
	self.my_id=0
	self.player_names = {}
	
	self.my_player_id = 0
	
	self.ready = {0,0}
	--the hosts id
	self.host_id=0
	self.is_host = false
	
	
	self.players={}
	
	self.opponent_id = self.opponent_id or 0
	
	--SETUP MP
   self.mp_signal_strength = 0 -- used solely for DS to check if Wireless signal strength should be displayed
end


function MultiplayerGameSetup:InventoryUpdated()

	self:UpdateHero(_G.Hero)--Update Screen
	self:UpdateNetworkHero(_G.Hero)--Update Network Players	
end


function MultiplayerGameSetup:OnGainFocus()
	
	self.inventory_player = nil
	
	return Menu.OnGainFocus(self)
end


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-----                              OnOpen                                 -----
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


function MultiplayerGameSetup:OnOpen()
	
	if not _G.GLOBAL_FUNCTIONS.CheckSaveData() then
		--[[
		self:hide_widget("icon_wireless_strength")	
		SCREENS.ReceptionStrengthMenu:Close()
		]]
		mp_leave_game(CloseGameResult)
		return
	end	
	
	self.game_starting = nil
	
	
	LOG("MultiplayerGame opened")
	self:UpdateSignalStrength()

	--add_text_file("ItemText.xml")	

	self:deactivate_widget("butt_inventory_1")
	self:deactivate_widget("butt_inventory_2")

	self:set_widget_value("ready_1",0)	
	self:set_widget_value("ready_2",0)	
	
	self:ShowInventoryWidgets(1)--will show none
	self:ShowInventoryWidgets(2)--will show none
	
	self.inventory_player = nil
	self.leaving_game = nil
	
	-- my netword id
	self.my_id=0
	
	-- my player number
	self.my_player_id = 1--default --clients gets overriden
	
	self.ready = {0,0}
	--the hosts network id
	self.host_id=0
	
	-- my opponent's network id
	self.opponent_id = self.opponent_id or 0
	
	
	
	self.players={}
	
	self:InitialiseWidgets()
	
	self.is_host = mp_is_host()
	
	self.host_id = _G.GLOBAL_FUNCTIONS.Multiplayer.GetResult(mp_get_host_id)
	
	local num_players = _G.GLOBAL_FUNCTIONS.Multiplayer.GetResult(mp_get_num_connected_players)
	
	self.my_player_id = 1
	self.opponent_player_id = 2
	if num_players > 1 then
	
		if not self.is_host then
			self.my_player_id = 2
			self.opponent_player_id = 1
			self.opponent_id = self.host_id
		else
			LOG("NumPlayers "..tostring(num_players))
			self.opponent_id = _G.GLOBAL_FUNCTIONS.Multiplayer.GetPlayerID(2)
			--LOG("opponent_id "..tostring(self.opponent_id))
			--self.opponent_id = _G.GLOBAL_FUNCTIONS.Multiplayer.GetPlayerID(1)
			--LOG("opponent_id 1 "..tostring(self.opponent_id))
			--self.opponent_id = _G.GLOBAL_FUNCTIONS.Multiplayer.GetPlayerID(3)
			--LOG("opponent_id 3 "..tostring(self.opponent_id))
			
		end
	end
	
	self.my_id = _G.GLOBAL_FUNCTIONS.Multiplayer.GetResult(mp_get_my_id)
	LOG(string.format("player_id=%d, host_id=%d, my_id=%d, opponent_id=%d",self.my_player_id,self.host_id,self.my_id,self.opponent_id))

		
	self:Update()	
		
	self:activate_widget(string.format("ready_%d", self:GetMultiplayerScreenPosition(self.my_player_id)))
	self:SetPlayerReady(self.my_player_id,0)
	
	self:reset_list("list_log")

	local last_save = nil
	if _G.Hero then
		last_save = _G.Hero:GetAttribute("name")
	else
		if Settings:ValueExists("last_save") then
			last_save = Settings:Read("last_save", "")
		end		
	end

	local saves = _G.GLOBAL_FUNCTIONS.EnumerateSaves(1) --SaveGameManager.Enumerate()
	self.heroes_list = {}
	self.selected_hero = 1
	self.actual_heroes = {}

	LOG("Saves "..tostring(#saves))
	if #saves > 0 then
		for k,v in ipairs(saves) do
	
			LOG("index: " .. k .. " savename: " .. v)
	
			table.insert(self.heroes_list,v)
			--if v == last_save then
				--self.selected_hero = #self.heroes_list
			--end
	
		end
	end	
	
	
	--[[
	local saves = _G.GLOBAL_FUNCTIONS.EnumerateSaves(1) --SaveGameManager.Enumerate()
	self.heroes_list = {}
	self.selected_hero = 1
	
	LOG("Saves "..tostring(#saves))
	
	for k,v in ipairs(saves) do

		LOG(tostring(v))
		LOG("index: " .. k .. " savename: " .. v)
		
		if (k==1 and v=="Empty 1") or (k==2 and v=="Empty 2") then
		
		else
			table.insert(self.heroes_list,v)
			if v == last_save then
				self.selected_hero = #self.heroes_list
			end
		end
	end
	--]]
	
	
	if #self.actual_heroes == 0 then
		self.selected_hero = -1
	end
	
	if _G.Hero then
		if _G.Hero.mp_enemy then
			local selected_hero
			local hero_name = _G.Hero.classIDStr
			for i,v in pairs(_G.DATA.MP_Enemies) do
				LOG(v)
				if v == hero_name then
					self.selected_hero = -i
					selected_hero = -i
					break
				end
			end
			self:LoadHeroSaves()--this will wipe the current self.selected_hero
			self.selected_hero = selected_hero
		else
			self:LoadHeroSaves(_G.Hero)
		end
	else
		self:LoadHeroSaves()
	end

	
	LOG("LoadTempHero")

	if self.selected_hero > 0 then
		_G.Hero = self.actual_heroes[self.selected_hero]
	elseif  self.selected_hero < 0 then
		_G.Hero = self:LoadTempHero(_G.DATA.MP_Enemies[-self.selected_hero],self.my_player_id,self.selected_hero,true)--loads enemy profile into  _G.Hero		
	--elseif  #self.actual_heroes >= self.selected_hero then
		--self:LoadHeroSaves()
		
		
	end	
	
	
	if _G.Hero then
		_G.Hero:SetAttribute("player_id",self.my_player_id)	
	end		
	
	if #self.actual_heroes + #_G.DATA.MP_Enemies<= 1 then
		self:hide_widget("butt_portraitprev") --_"..tostring(self.my_player_id))
		self:hide_widget("butt_portraitnext") --_"..tostring(self.my_player_id))
	else
		self:activate_widget("butt_portraitprev") --_"..tostring(self.my_player_id))	
		self:activate_widget("butt_portraitnext") --_"..tostring(self.my_player_id))
	end
	
	
	--LOG("UpdateNetworkHero")
	if _G.Hero then
		LOG("UpdateNetworkHero "..tostring(self.my_player_id))
		self:SetInventoryButton(self.my_player_id, true)
		self:UpdateHero(_G.Hero)--TEMP COMMENTED for debugging
		self:UpdateNetworkHero(_G.Hero)
	else
		mp_leave_game(CloseGameResult)
		return
	end
	if self.opponent_id ~= 0 then
		--LOG("Send UpdateOpponent Event to host to GET HOSTs Hero obj'")
		self:UpdateOpponent()
	end
	
	return Menu.OnOpen(self)
end


function MultiplayerGameSetup:UpdateOpponent()
	local e = GameEventManager:Construct("UpdateOpponent")
	LOG(tostring(self.my_player_id).." send to opponent_id "..tostring(self.opponent_id))
	GameEventManager:Send(e, self.opponent_id)--send to all players.
end


function MultiplayerGameSetup:UpdateHero(hero)
	local player_id = hero:GetAttribute("player_id")
	LOG(tostring(self.my_player_id).." UpdateHero() ID = "..tostring(player_id))
	local mp_id = self.my_id
	LOG(string.format("my_id=%d, (player_id=%d ~= my_player_id=%d)= %s",self.my_id,player_id,self.my_player_id,tostring(player_id ~= self.my_player_id)))
	if player_id ~= self.my_player_id then
		mp_id = self.opponent_id
		LOG("self.opponent_id = "..tostring(self.opponent_id))
		if self.inventory_player == player_id then
			self:CloseInventory()
		end
	end
	local currLoadout = hero:GetAttributeAt("ship_list",hero:GetAttribute("ship_loadout"))
	local shipID = currLoadout:GetAttribute("ship")	
	
	local function mpName(returnval,name)
		self.player_names[player_id] = name
		self:set_text(string.format("str_unit_name_%s", self:GetMultiplayerScreenPosition(player_id)),string.format("%s:",name))
		LOG(string.format("mpName setting str_unit_name_%s to %s:",self:GetMultiplayerScreenPosition(player_id),name))
	end
	
	local mp_name = _G.GLOBAL_FUNCTIONS.Multiplayer.GetPlayerID(player_id) or ""
	self.player_names[player_id] = mp_name
	LOG(string.format("GLobal FUNCTIONs Setting str_unit_name_%s to %s:",self:GetMultiplayerScreenPosition(player_id),mp_name))
	self:set_text(string.format("str_unit_name_%s", self:GetMultiplayerScreenPosition(player_id)),string.format("%s:",mp_name))	
	mp_get_player_name_from_ID(mpName,mp_id)
	local name = hero:GetAttribute("name")
	self:SetTextFields(hero, player_id, name)
	self:SetPortraits(hero, player_id, shipID)
	
	
	if hero.mp_enemy then
		self:deactivate_widget(string.format("butt_inventory_%d",player_id))
	else
		self:activate_widget(string.format("butt_inventory_%d",player_id))		
	end
	
	self:ShowInventoryWidgets(player_id, currLoadout)
end


function MultiplayerGameSetup:OnMouseEnter(id,x,y)
	LOG(string.format("OnMouseEnter(%d,%d)",x,y))
	local playerID
	local hero
	local offset = 0
	if id == 91 then		
		playerID = 1
		offset = 90
	elseif id == 92 then
		playerID = 2
		offset = 678
	end
	if playerID then
		if playerID == self.my_player_id then
			hero = self.players[self.my_player_id]
		else
			hero = self.players[self.opponent_player_id]
		end
		if hero then
			_G.GLOBAL_FUNCTIONS.ShipPopup(hero:GetAttributeAt("ship_list",hero:GetAttribute("ship_loadout")):GetAttribute("ship"),x+offset,y)
		end
	end
	
	return Menu.OnMouseEnter(self,id,x,y)
end


function MultiplayerGameSetup:UpdateNetworkHero(hero)
	LOG("UpdateNetworkHero")

	local event = GameEventManager:Construct("UpdatePlayer")
	
	local currLoadout = hero:GetAttributeAt("ship_list",hero:GetAttribute("ship_loadout"))
	event:SetAttribute("ship_loadout",hero:GetAttribute("ship_loadout"))
	for i=1,hero:NumAttributes("ship_list") do				
		event:PushAttribute("ships",hero:GetAttributeAt("ship_list",i):GetAttribute("ship"))
	end
	for i=1, currLoadout:NumAttributes("items") do
		event:PushAttribute("battle_items",currLoadout:GetAttributeAt("items",i))
	end
	event:SetAttribute("mp_id",tostring(self.my_id))
	event:SetAttribute("player_id",	hero:GetAttribute("player_id"))
	
	event:SetAttribute("name",		hero:GetAttribute("name"))
	event:SetAttribute("portrait",	hero:GetAttribute("portrait"))
	event:SetAttribute("male",		hero:GetAttribute("male"))

	event:SetAttribute("pilot",		hero:GetAttribute("pilot"))
	event:SetAttribute("gunnery",	hero:GetAttribute("gunnery"))
	event:SetAttribute("engineer",	hero:GetAttribute("engineer"))
	event:SetAttribute("science",	hero:GetAttribute("science"))
	event:SetAttribute("intel",		hero:GetAttribute("intel"))
	event:SetAttribute("psi",		hero:GetAttribute("psi"))
	event:SetAttribute("ai",		hero:GetAttribute("ai"))
	
	if hero.mp_enemy then
		event:SetAttribute("mp_enemy",1)
	end
	
	event:SetAttribute("player_ready",		self.ready[self.my_player_id])
	
	local old_hero = self.players[self.my_player_id]
	if old_hero then
		local player_id = old_hero:GetAttribute("player_id")
		--self:ClearPlayer(player_id,self.host_id)
		LOG("UpdateNetworkHero - ClearNetworkHero "..tostring(player_id))
		_G.GLOBAL_FUNCTIONS.ClearChar.ClearNetworkHero(old_hero,self.host_id)	
	end
	self.players[self.my_player_id]=nil
	local player_id = hero:GetAttribute("player_id")

	--self:deactivate_widget("butt_portraitprev") --
	--self:deactivate_widget("butt_portraitnext") --
	--self:deactivate_widget("butt_inventory_"..tostring(player_id)) --deactivate inventory button until network hero arrives

	LOG(tostring(self.my_id).." Send UpdatePlayer Event to host "..tostring(self.host_id))
	GameEventManager:Send(event,self.host_id)
	
end


function MultiplayerGameSetup:UpdateNetworkReady()
	if self.opponent_id ~= 0 then
		local event = GameEventManager:Construct("PlayerReady")
		event:SetAttribute("player_ready",self.ready[self.my_player_id])
		event:SetAttribute("player_id",self.my_player_id)
		GameEventManager:Send(event,self.opponent_id)
	end
end
	

local function CloseGameResult(ret)	
	LOG("CloseGameResult")

	close_yesno_menu(false,false)
	
	if _G.is_open("MultiplayerGameSetup") then
		SCREENS.MultiplayerGameSetup:ClearHeroes(true)
		LOG("CloseGameResult mpId="..tostring(SCREENS.MultiplayerGameSetup.my_player_id))
		_G.CallScreenSequencer("MultiplayerGameSetup", "MultiplayerMenu")

	elseif _G.is_open("MPResultsMenu") then
		
		SCREENS.GameMenu.sourceMenu = "MultiplayerMenu"
		_G.SCREENS.MPResultsMenu:DisableRematch()
		
		
		local function MPResultsCallback(result)	
			SCREENS.GameMenu.world.state = STATE_GAME_OVER
			LOG("STATE_GAME_OVER")
		end
		

	elseif _G.is_open("GameMenu") then

		_G.CallScreenSequencer("GameMenu", "MultiplayerMenu")			
	end
	
	mp_cleanup_network_objects()
end


function MultiplayerGameSetup:OnTimer(time)
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_overture")
	end	
	
	return Menu.MESSAGE_HANDLED
end

function MultiplayerGameSetup:ClearHeroes(clear_all_heroes)

	for k,v in ipairs(self.actual_heroes) do
		if self.actual_heroes[k] ~= _G.Hero or clear_all_heroes then
			LOG("Clear hero from Multiplayer")
			_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(self.actual_heroes[k])			
		end
		self.actual_heroes[k] = nil
	end
	
	self.actual_heroes = {}
	
	if clear_all_heroes then
		_G.Hero = nil
	end

end

function MultiplayerGameSetup:OnButton(buttonId, clickX, clickY)
	LOG("OnButton")
	
	if (buttonId == 1) then--HOST STARTS GAME
		self:deactivate_widget("butt_start")	
		self:ClearHeroes()
		self:deactivate_widget(string.format("ready_%s", self:GetMultiplayerScreenPosition(self.my_player_id)))
		LOG("HOST START BATTLE")
		local mpStart = GameEventManager:Construct("StartMPBattle")
		mpStart:PushAttribute("mp_id","")
		mpStart:PushAttribute("mp_id","")
		for i,v in pairs(self.players) do
			local player_id = v:GetAttribute("player_id")
			LOG("Player ID = " .. tostring(player_id))
			local loadout = v:GetAttributeAt("ship_list",v:GetAttribute("ship_loadout"))
			for j=1, loadout:NumAttributes("items") do
				mpStart:PushAttribute("item_list_"..tostring(player_id),loadout:GetAttributeAt("items",j))
			end	
			mpStart:SetAttributeAt("mp_id",player_id,tostring(_G.GLOBAL_FUNCTIONS.Multiplayer.GetPlayerID(player_id)))
		end
		
		GameEventManager:Send(mpStart)

	-- Leave Game
	elseif (buttonId == 10) then
		self:SetPlayerReady(self.my_player_id,0)
		self.leaving_game = true
		
		mp_leave_game(CloseGameResult)
		--[[
		self:hide_widget("icon_wireless_strength")
		_G.HideReceptionStrength()	
		SCREENS.ReceptionStrengthMenu:Close()
		]]
		self.players = {}
	
	-- Terminate Game (only works if host) - terminates the game with no host migration
	elseif (buttonId == 11) then
		--self:ClearHeroes(true)
		
		mp_leave_game(CloseGameResult)		
		--[[
		self:hide_widget("icon_wireless_strength")
		SCREENS.ReceptionStrengthMenu:Close()
		]]

	elseif (buttonId == 17) or (buttonId == 27) then--player1/2 inventory
		buttonId = (buttonId - 7)/10
		self.inventory_player = buttonId
		local opponent = nil--results in Inventory using _G.Hero
		LOG("buttonId "..tostring(buttonId).." ~= "..tostring(self.my_player_id))
	
		if buttonId ~= self.my_player_id and self.players[self.opponent_player_id] then--My opponents player object
			opponent = self.players[self.opponent_player_id]
		elseif buttonId == self.my_player_id and self.players[self.my_player_id] and self.players[self.my_player_id].mp_enemy then--my Enemy profile player object
			opponent = self.players[self.my_player_id]		
		end
		SCREENS.InventoryFrame:Open("MultiplayerGameSetup", 3,true,opponent)
			--self:Close()
			
			
	elseif (buttonId == 41) or (buttonId == 42) then--player READY checkbox
		if self.ready[self.my_player_id]==0 then
			self.ready[self.my_player_id]=1
		else
			self.ready[self.my_player_id]=0
		end
		self:SetPlayerReady(self.my_player_id,self.ready[self.my_player_id])
		self:UpdateNetworkReady()
		
		
	elseif (buttonId == 18) or (buttonId == 28) then-- prev Hero

		if self.players[self.my_player_id] then		
			self.selected_hero = self.selected_hero-1
			if self.selected_hero == 0 then
				self.selected_hero = -1--#self.heroes_list
				_G.Hero = nil
			elseif self.selected_hero < -#_G.DATA.MP_Enemies then
				if #self.actual_heroes>0 then
					self.selected_hero = #self.actual_heroes
				else
					self.selected_hero = -1
				end
			end
			LOG("Load Hero "..tostring(self.selected_hero))
				
			--local old_hero = self.players[self.my_player_id]
			if self.selected_hero > 0 then	
	
				_G.Hero = self.actual_heroes[self.selected_hero]
			else	
				_G.Hero = self:LoadTempHero(_G.DATA.MP_Enemies[-self.selected_hero],self.my_player_id,self.selected_hero,true)						
			end
			--hero:SetAttribute("player_id",self.my_player_id)
		
			
			
			self:UpdateHero(_G.Hero)--Update Screen
			ClearAutoLoadTables()
			
			self:UpdateNetworkHero(_G.Hero)--Update Network Players
		end
		
		collectgarbage()	-- cycling heroes as fast as possible was causing a crash. (not suprising when its loading files so fast)
	elseif (buttonId == 19) or (buttonId == 29) then--next Hero
	LOG("Memory " .. gcinfo())
		if self.players[self.my_player_id] then
			
			self.selected_hero = self.selected_hero+1
			if self.selected_hero == 0 then
				if #self.actual_heroes>0 then
					self.selected_hero = 1
				else
					self.selected_hero = -#_G.DATA.MP_Enemies
				end
			elseif self.selected_hero > #self.actual_heroes then
				self.selected_hero = -#_G.DATA.MP_Enemies 		
				_G.Hero = nil
				--self.selected_hero = 1
			end
			
			
			LOG("Load Hero "..tostring(self.selected_hero))
	
			--_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(self.actual_heroes[k])	
			--_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(old_hero)
			
			if self.selected_hero > 0 then	
	
				_G.Hero = self.actual_heroes[self.selected_hero]
			else
				_G.Hero = self:LoadTempHero(_G.DATA.MP_Enemies[-self.selected_hero],self.my_player_id,self.selected_hero,true)						
			end
		
			self:UpdateHero(_G.Hero)--Update Screen
			ClearAutoLoadTables()
			
			self:UpdateNetworkHero(_G.Hero)--Update Network Players
		end
		collectgarbage()	-- cycling heroes as fast as possible was causing a crash. (not suprising when its loading files so fast)
	end
	
	close_custompopup_menu()
	
	return Menu.OnButton(self, buttonId, clickX, clickY)
end


function MultiplayerGameSetup:OnButtonAvailable(buttonId, locX, locY, available)
	LOG("OnButtonAvailable "..tostring(buttonId).." "..tostring(available))
	
	if not available then
		close_custompopup_menu()
		return Menu.MESSAGE_HANDLED
	end
	
	local player_id = 1
	if buttonId > 200 then		
		buttonId = buttonId - 200
		player_id = 2
	elseif buttonId > 100 then
		buttonId = buttonId - 100
	else			
		return Menu.MESSAGE_HANDLED
	end
	
	if player_id == self.my_player_id then
		if self.players[self.my_player_id] then
			local loadout = self.players[self.my_player_id]:GetAttributeAt("ship_list",self.players[self.my_player_id]:GetAttribute("ship_loadout"))
			if loadout:NumAttributes("items") >= buttonId then	
				_G.GLOBAL_FUNCTIONS.ItemPopup(loadout:GetAttributeAt("items", buttonId), locX-140, locY)
			end
		end
	elseif self.players[self.opponent_player_id] then
		local loadout = self.players[self.opponent_player_id]:GetAttributeAt("ship_list",self.players[self.opponent_player_id]:GetAttribute("ship_loadout"))
		if loadout:NumAttributes("items") >= buttonId then	
			_G.GLOBAL_FUNCTIONS.ItemPopup(loadout:GetAttributeAt("items", buttonId), locX-140, locY)
		end
	end
	
	return Menu.MESSAGE_HANDLED
end


function MultiplayerGameSetup:OnMouseLeave(id,x,y)	
	close_custompopup_menu()		
	
	return Menu.OnMouseLeave(self,id,x,y)
end


--	Update()
--		Update button/string states
--		NOTE:	painfully this currently has to keep the mapping of button ids to tag names
--				this could be fixed by having tag names as str_help_%d where %d is the button it corrosponds to
function MultiplayerGameSetup:Update()
	if self.my_id == self.host_id then
		local ready_to_start = true
		for i=1,2 do
			if self.ready[i]==0 then
				ready_to_start = false
				break
			end
		end
		
		if ready_to_start then--both players ready
			self:activate_widget("butt_start")
		else
			self:activate_widget("ready_"..tostring(self.my_player_id))
			if self.ready[self.my_player_id]==1 then
				self:deactivate_widget("butt_start")--self ready
			else
				self:hide_widget("butt_start")--self not ready			
			end
		end
	end
end


--Clears player object - called when player leaves MP Game
--nils entry in player related lists
--clears UI
function MultiplayerGameSetup:ClearPlayer(player_id)
	LOG(string.format("MPGameSetup:ClearPlayer(%d)",player_id))
	
	
	local mp_id = self.my_id
	LOG(string.format("Clear Player Ids: %d %d",player_id,_G.Hero:GetAttribute("player_id")))
	if player_id ~= _G.Hero:GetAttribute("player_id") then
		mp_id = self.opponent_player_id
		LOG("Clear Opponenent")
	else
		mp_id = self.my_player_id
		LOG("Clear Self")
	end
	
	if not self.players[mp_id] then
		return
	end
	
	self:SetPlayerReady(player_id,0)
	--self.ready[player_id] = 0
	
	if self.host_id == self.my_id and self.players[mp_id] then
		LOG("Cleared "..tostring(player_id))
		LOG("Send Clear Network Event to host id: "..tostring(self.host_id))
		_G.GLOBAL_FUNCTIONS.ClearChar.ClearNetworkHero(self.players[mp_id],self.host_id)
	end

	self:hide_widget(string.format("str_unit_name_%d",self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("icon_portrait_%d",self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("ready_%d",self:GetMultiplayerScreenPosition(player_id)))

	self:hide_widget(string.format("str_player_name_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("str_hero_name_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("str_hero_level_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("str_hero_pilot_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("str_hero_gunnery_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("str_hero_engineer_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("str_hero_science_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("str_hero_intel_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("str_hero_hull_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("str_hero_shield_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("icon_portrait_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("icon_ship_%s", self:GetMultiplayerScreenPosition(player_id)))
	
	self:hide_widget(string.format("butt_portraitnext_%s", self:GetMultiplayerScreenPosition(player_id)))
	self:hide_widget(string.format("butt_portraitprev_%s", self:GetMultiplayerScreenPosition(player_id)))

	--self:set_widget_value(string.format("ready_%d", self:GetMultiplayerScreenPosition(player_id)), 0)	
	--self:deactivate_widget(string.format("ready_%d", self:GetMultiplayerScreenPosition(player_id)))	
	self:hide_widget(string.format("butt_inventory_%s", self:GetMultiplayerScreenPosition(player_id)))
	
	self:ShowInventoryWidgets(player_id)--will show none

	self.players[mp_id]=nil	
end


local function start_callback(result)
	LOG("start callback")
end


local function close_callback()
	LOG("close callback")
	mp_leave_game(CloseGameResult)
end


--Multiplayer callback for system messages
function _G.MPMessage(senderID, messageType, strMessageData)

	LOG("New MP Message. SenderID : " .. senderID .. " Message Type : " .. messageType .. " Message Data : " .. strMessageData)

	if messageType == NetworkMessageIdent.PlayerJoined then
		LOG("PlayerJoined")
		
		if SCREENS.MultiplayerGameSetup.my_id ~= 0 and SCREENS.MultiplayerGameSetup.my_id ~= senderID then
			LOG(tostring(SCREENS.MultiplayerGameSetup.my_player_id).." JOINING "..tostring(SCREENS.MultiplayerGameSetup.my_id).." ~= "..tostring(senderID))
			SCREENS.MultiplayerGameSetup.opponent_id = senderID
			mp_start_game(start_callback)
		end
	
	elseif messageType == NetworkMessageIdent.PlayerLeft then
		LOG(messageType..": Player Left Message ")
		
		if _G.is_open("MultiplayerGameSetup") then
			LOG(string.format("hostID: %d, my_id: %d",SCREENS.MultiplayerGameSetup.host_id,SCREENS.MultiplayerGameSetup.my_id))
			
			local senderPlayerID = 1
			if senderID ~= SCREENS.MultiplayerGameSetup.host_id then
				senderPlayerID = 2
			end
			
			if _G.SCREENS.MultiplayerGameSetup.players[senderPlayerID] then
				--local player_id = _G.SCREENS.MultiplayerGameSetup.players[senderPlayerID]:GetAttribute("player_id")
				_G.SCREENS.MultiplayerGameSetup:ClearPlayer(senderPlayerID)		
			end
			
			local my_id = SCREENS.MultiplayerGameSetup.my_id
			--If player leaves my hosted game
			if my_id ~= senderID and SCREENS.MultiplayerGameSetup.host_id == my_id and not SCREENS.MultiplayerGameSetup.leaving_game then
				SCREENS.MultiplayerGameSetup:ClearWidgets(2)
				SCREENS.MultiplayerGameSetup.opponent_id = 0	
				SCREENS.MultiplayerGameSetup:activate_widget("ready_1")					
				if not is_message_menu_open() then
					LoadAssetGroup("AssetsButtons")				
					open_message_menu("[CONNECTION_LOST]", "[CONNECTION_LOST_MSG]")		

				end
			end	
			if SCREENS.MultiplayerGameSetup.inventory_player == senderPlayerID then
				SCREENS.MultiplayerGameSetup:CloseInventory()
			end			
			
		elseif _G.is_open("GameMenu") then
			--LOG(string.format("hostID: %d, my_id: %d",SCREENS.GameMenu.host_id,SCREENS.GameMenu.my_id))
			LOG("End mp game call")
			if SCREENS.GameMenu.world then
				if SCREENS.GameMenu.world.host then
					local function do_nothing()
						LOG("End MP Game, so others can't join, game obj destruction/returning to mp menu handled by msg_menu callback")
					end
					mp_leave_game(do_nothing)
				end
				_G.SCREENS.GameMenu.world.state = _G.STATE_GAME_OVER
			end	
			
			--if not is_message_menu_open() then
				if is_message_menu_open() then				
					close_message_menu()		
				end
				LoadAssetGroup("AssetsButtons")
				
				open_message_menu("[CONNECTION_LOST]", "[CONNECTION_LOST_MSG]", close_callback)		
				--[[
				_G.HideReceptionStrength()
				if _G.is_open("ReceptionStrengthMenu") then
					SCREENS.ReceptionStrengthMenu:Close()
					SCREENS.MultiplayerGameSetup:hide_widget("icon_wireless_strength")
				end
				--]]	
			--end
		end
		
	elseif messageType == NetworkMessageIdent.HostTerminatedSession then
		LOG(messageType..": Host Terminated Msg")
		--go back to the multiplayer menu screen
		
		if _G.is_open("MultiplayerGameSetup") then
			_G.SCREENS.MultiplayerGameSetup:ClearPlayer(2)
			_G.SCREENS.MultiplayerGameSetup:ClearPlayer(1)
		end
		
		--if not is_message_menu_open() then		
			LoadAssetGroup("AssetsButtons")
			open_message_menu("[HOST_TERMINATED_GAME]", "[HOST_TERMINATED_GAME_MSG]", close_callback)
			
			--[[
			_G.HideReceptionStrength()
			if _G.is_open("ReceptionStrengthMenu") then
				SCREENS.ReceptionStrengthMenu:Close()
				SCREENS.MultiplayerGameSetup:hide_widget("icon_wireless_strength")
			end
			--]]	
		--end
		SCREENS.MultiplayerGameSetup:CloseInventory()
		
	elseif messageType == NetworkMessageIdent.ConnectionLost then
		LOG(messageType..": Connection Lost Msg")

		if _G.is_open("MultiplayerGameSetup") then
			SCREENS.MultiplayerGameSetup:ClearPlayer(2)
			SCREENS.MultiplayerGameSetup:ClearPlayer(1)
		--elseif _G.is_open("GameMenu") and SCREENS.GameMenu.world and SCREENS.GameMenu.world.host then
			--local function do_nothing()
			--	LOG("Host Ends game - so others can't join")
			--end
			--mp_leave_game(do_nothing)
		end
		
		--if not is_message_menu_open() then
			LoadAssetGroup("AssetsButtons")
			open_message_menu("[CONNECTION_LOST]", "[CONNECTION_LOST_MSG]", close_callback)
			local my_id = SCREENS.MultiplayerGameSetup.my_id
			--If player leaves my hosted game
			--[[
			_G.HideReceptionStrength()
			if _G.is_open("ReceptionStrengthMenu") and SCREENS.MultiplayerGameSetup.host_id ~= my_id  then
				SCREENS.ReceptionStrengthMenu:Close()
				SCREENS.MultiplayerGameSetup:hide_widget("icon_wireless_strength")
			end
			--]]
		--end
		
		-- Putting this in OnClose() is too late - the inventory screen remains while the next screen is opening
		SCREENS.MultiplayerGameSetup:CloseInventory()
		
	else
		LOG("Unknown Msg Type: "..messageType)
		
	end
end



function MultiplayerGameSetup:OnClose()
	self:ClearHeroes()	
	close_custompopup_menu()
	return Menu.OnClose(self)
end	



--DS Specific - will setup PC version later
function MultiplayerGameSetup:ClearWidgets(player_id)
	self:set_text(string.format("str_unit_name_%d",self:GetMultiplayerScreenPosition(player_id)),"")
	self:hide_widget(string.format("icon_portrait_%d",self:GetMultiplayerScreenPosition(player_id)))
	self:set_text(string.format("str_player_name_%d",self:GetMultiplayerScreenPosition(player_id)),"")
	self:set_text(string.format("str_hero_name_%d",self:GetMultiplayerScreenPosition(player_id)),"")
	self:set_text(string.format("str_hero_level_%d",self:GetMultiplayerScreenPosition(player_id)),"")
	self:set_text(string.format("str_hero_hull_%d",self:GetMultiplayerScreenPosition(player_id)),"")
	self:set_text(string.format("str_hero_shield_%d",self:GetMultiplayerScreenPosition(player_id)),"")
	self:deactivate_widget(string.format("ready_%d",self:GetMultiplayerScreenPosition(player_id)))
	
	
end



-- return an instance of MultiplayerMenu
return ExportSingleInstance("MultiplayerGameSetup")
