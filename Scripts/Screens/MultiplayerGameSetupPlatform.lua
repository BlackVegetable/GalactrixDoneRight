function MultiplayerGameSetup:InitialiseWidgets()
	self:hide_widget("butt_portraitprev_1")	
	self:hide_widget("butt_portraitnext_1")	
	self:hide_widget("butt_portraitprev_2")	
	self:hide_widget("butt_portraitnext_2")	

	--self:hide_widget("butt_back")		
	self:hide_widget("butt_start")	
	--self:set_text("butt_start","[LEAVE_GAME]")	
	

	self:hide_widget("icon_portrait_1")	
	self:hide_widget("icon_portrait_2")	
	self:hide_widget("icon_ship_1")		
	self:hide_widget("icon_ship_2")		

	self:set_text("str_player_name_1","")	
	self:set_text("str_hero_name_1","")	
	self:set_text("str_hero_level_1","")	
	self:set_text("str_hero_pilot_1","")	
	self:set_text("str_hero_gunnery_1","")	
	self:set_text("str_hero_engineer_1","")	
	self:set_text("str_hero_science_1","")	
	self:set_text("str_hero_intel_1","")	
	

	self:set_text("str_player_name_2","")	
	self:set_text("str_hero_name_2","")	
	self:set_text("str_hero_level_2","")	
	self:set_text("str_hero_pilot_2","")	
	self:set_text("str_hero_gunnery_2","")	
	self:set_text("str_hero_engineer_2","")	
	self:set_text("str_hero_science_2","")	
	self:set_text("str_hero_intel_2","")			
		
	

	self:deactivate_widget("ready_1")
	self:deactivate_widget("ready_2")		

end


function MultiplayerGameSetup:CloseInventory()
	if _G.is_open("InventoryFrame") then
		SCREENS.InventoryFrame.hero = nil
		SCREENS.InventoryFrame.sourceMenu = nil
		SCREENS.InventoryFrame.opponent = true
		SCREENS.InventoryFrame:GetOverlayScreen():Close()
		SCREENS.InventoryFrame:Close()
	end		
end


function MultiplayerGameSetup:LoadTempHero(heroSave,player_id,slot,mp_enemy)
	
	local newHero
	if mp_enemy then
		LOG("load mP enemy")
		newHero = _G.GLOBAL_FUNCTIONS.LoadHero.LoadMPEnemy(heroSave)
		LOG("after load mp enemy")
	else
		--[[]]
		local save = SaveGameManager:Create(heroSave, 1)
		local objs = save:Load() -- table of loaded objects
		
		if type(objs) == "table" then
			newHero = objs[1]
		end
		--]]
		if not newHero then
			LOG("Temp Load Hero Save Failed")
			--return false
		end
	end
	
--[[
	if _G.Hero then
		_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(_G.Hero)
		_G.Hero = nil
	end	
	--]]
	if newHero then
		newHero:SetAttribute("player_id",player_id)
	end
	--_G.Hero = newHero
	
	return newHero	
	
end

function MultiplayerGameSetup:GetMultiplayerScreenPosition(player_id)
	assert(player_id == 1 or player_id ==2)
	-- 1 is the left side of screen (host's position)
	-- 2 is the right side of screen (client's position)
	if player_id == self.my_player_id then
		-- checking me
		if self.my_id == self.host_id then
			-- I'm host
			return "1"
		else
			-- I'm client
			return "2"
		end
	else
		-- checking my opponent
		if self.my_id == self.host_id then
			-- I'm the host so my opponent can't be
			return "2"
		else
			-- I'm not the host, so my opponenet must be
			return "1"
		end
	end
end


function MultiplayerGameSetup:SetPortraits(hero, player_id, shipID)
	local portrait_name = nil

	if hero:GetAttribute("portrait") then
		portrait_name = string.format("icon_portrait_%s", self:GetMultiplayerScreenPosition(player_id))
		
		self:set_image(portrait_name, hero:GetAttribute("portrait"))
		self:activate_widget(portrait_name)
	end

	portrait_name = string.format("icon_ship_%s", self:GetMultiplayerScreenPosition(player_id))
	self:set_image(portrait_name, string.format("img_%s", shipID))
	self:activate_widget(portrait_name)

end

function MultiplayerGameSetup:SetTextFields(hero, player_id, name)
	local shipID = hero:GetAttributeAt("ship_list",hero:GetAttribute("ship_loadout")):GetAttribute("ship")

	self:activate_widget(string.format("str_player_name_%d",     player_id))
	self:activate_widget(string.format("str_hero_name_%d",     player_id))
	self:activate_widget(string.format("str_hero_level_%d",    player_id))
	self:activate_widget(string.format("str_hero_pilot_%d",    player_id))
	self:activate_widget(string.format("str_hero_gunnery_%d",  player_id))
	self:activate_widget(string.format("str_hero_engineer_%d", player_id))
	self:activate_widget(string.format("str_hero_science_%d",  player_id))
	self:activate_widget(string.format("str_hero_intel_%d",    player_id))
	self:activate_widget(string.format("str_hero_hull_%d",     player_id))
	self:activate_widget(string.format("str_hero_shield_%d",   player_id))
	
	self:set_text_raw(string.format("str_player_name_%d",     player_id), string.upper(self.player_names[player_id]))	
	self:set_text_raw(string.format("str_hero_name_%d",     player_id), translate_text(name))
	self:set_text_raw(string.format("str_hero_level_%d",    player_id), string.format("%s %d", translate_text("[LEVEL_]"),    hero:GetLevel()))
	self:set_text_raw(string.format("str_hero_pilot_%d",    player_id), string.format("%s %d", translate_text("[PILOT_]"),    hero:GetAttribute("pilot")))
	self:set_text_raw(string.format("str_hero_gunnery_%d",  player_id), string.format("%s %d", translate_text("[GUNNERY_]"),  hero:GetAttribute("gunnery")))
	self:set_text_raw(string.format("str_hero_engineer_%d", player_id), string.format("%s %d", translate_text("[ENGINEER_]"), hero:GetAttribute("engineer")))
	self:set_text_raw(string.format("str_hero_science_%d",  player_id), string.format("%s %d", translate_text("[SCIENCE_]"),  hero:GetAttribute("science")))
	self:set_text_raw(string.format("str_hero_intel_%d",    player_id), substitute(translate_text("[INTEL_]"),hero:GetAttribute("intel")))
	self:set_text_raw(string.format("str_hero_hull_%d",     player_id), string.format("%s: %d",translate_text("[HULL]"),SHIPS[shipID].hull))
	self:set_text_raw(string.format("str_hero_shield_%d",   player_id), string.format("%s: %d",translate_text("[SHIELDS]"),SHIPS[shipID].shield))
	
end

function MultiplayerGameSetup:SetInventoryButton(player_id, enable)
		if enable == true and self.selected_hero and self.selected_hero > 0 then -- only enable inv button for actual heroes
			self:activate_widget(string.format("butt_inventory_%d", player_id))
		else
			self:deactivate_widget(string.format("butt_inventory_%d", player_id))
		end
end

function MultiplayerGameSetup:ShowInventoryWidgets(player_id, currLoadout)

	local energyList = {"weapon","cpu","engine"}
	
	for i=1, 8 do
		if currLoadout and i <= currLoadout:NumAttributes("items") then
			local itemID = currLoadout:GetAttributeAt("items",i)
			self:activate_widget(string.format("butt_item_%d_%d", i, player_id))
			self:activate_widget(string.format("item_%d_icon_%d", i, player_id))
			self:set_image(string.format("item_%d_icon_%d", i, player_id),ITEMS[itemID].icon)
			for j,v in pairs(energyList) do
				if ITEMS[itemID][string.format("%s_requirement", v)] > 0 then
					self:set_text_raw(string.format("item_%d_%s_%d_req", i, v, player_id),tostring(ITEMS[itemID][string.format("%s_requirement", v)]))
					self:set_image(string.format("item_%d_%s_%d", i, v, player_id), string.format("img_item_%s_active", v))
					self:activate_widget(string.format("item_%d_%s_%d_req", i, v, player_id))
					self:activate_widget(string.format("item_%d_%s_%d", i, v, player_id))
				else
					self:hide_widget(string.format("item_%d_%s_%d_req", i, v, player_id))
					self:hide_widget(string.format("item_%d_%s_%d", i, v, player_id))
				end
			end
		else
			self:deactivate_widget(string.format("butt_item_%d_%d", i, player_id))
			self:hide_widget(string.format("item_%d_icon_%d", i, player_id))
			for j,v in pairs(energyList) do
				self:hide_widget(string.format("item_%d_%s_%d_req", i, v, player_id))
				self:hide_widget(string.format("item_%d_%s_%d", i, v, player_id))
			end
		end
	end
end

function MultiplayerGameSetup:SetPlayerReady(player_id,ready)
	self.ready[player_id]=ready
	self:set_widget_value(string.format("ready_%d", self:GetMultiplayerScreenPosition(player_id)), ready)
	if player_id == self.my_player_id then
		if ready == 1 then  
			self:SetInventoryButton(player_id,false)
			self:deactivate_widget(string.format("butt_portraitprev_%d", player_id))
			self:deactivate_widget(string.format("butt_portraitnext_%d", player_id))
			self:hide_widget("butt_back")
		else
			self:SetInventoryButton(player_id,true)
			self:activate_widget(string.format("butt_portraitprev_%d", player_id))
			self:activate_widget(string.format("butt_portraitnext_%d", player_id))

			self:hide_widget("butt_start")
			self:activate_widget("butt_back")
		end
	else
		self:SetInventoryButton(player_id,true)
	end
	
	self:Update()
end



function MultiplayerGameSetup:LoadGraphics()
	
end



function MultiplayerGameSetup:UpdateSignalStrength()
--Does nothing
end

--Load Hero saves - puts Hero saves into array .actual_heroes
--Also sets self.selected_hero 
function MultiplayerGameSetup:LoadHeroSaves(curr_hero)
	local hero_count = 1
	for k,v in ipairs(self.heroes_list) do		
		local hero = self:LoadTempHero(self.heroes_list[k],self.my_player_id,k)--loads into  _G.Hero
		
		if hero then
			self.actual_heroes[hero_count] = hero				
			LOG("actual_hero" .. hero:GetAttribute("name"))
			hero_count = hero_count + 1
		end			
	end
	if self.actual_heroes[1] then
		_G.Hero = self.actual_heroes[1]
		self.selected_hero = 1
	else
		self.selected_hero = -1
		--_G.Hero = self:LoadTempHero(_G.DATA.MP_Enemies[self.selected_hero],self.my_player_id,-self.selected_hero,true)--loads enemy profile into  _G.Hero		
	end
end
