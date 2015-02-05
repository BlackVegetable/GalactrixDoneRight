
use_safeglobals()

-- declare menu

class "InvFactions" (Menu);

function InvFactions:__init()
	super()
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\InvFactions.xml")
end


function InvFactions:OnOpen()
	LOG("InvFactionsMenu opened");
	
	self:UpdateFactions()
	
	self.lastTime = GetGameTime()

	if IsGamepadActive() then
		self.selectedIndex = 1
		self:set_widget_position("icon_gp_cursor", 108, 194)
		self:OnMouseEnter(1, 0, 0)
	else
		self:hide_widget("grp_gp")
	end
	
	_G.ShowTutorialFirstTime(17,_G.Hero)
	
	return Menu.OnOpen(self)
end

function InvFactions:UpdateFactions()
	LOG("Updating Faction List")
	
	local highestFaction = { standing = -100, id = 1 }
	
	for i=1, _G.NUM_FACTIONS do
		self:hide_widget(string.format("str_faction%d", i))
		self:hide_widget("str_faction_summary")
		self:hide_widget(string.format("prog_faction%d_bad", i))
		self:hide_widget(string.format("prog_faction%d_good", i))	
		self:set_alpha(string.format("prog_faction%d_bad", i),0)
		self:set_alpha(string.format("prog_faction%d_good", i),0)
	end
	
	local numEncounteredFactions = SCREENS.InventoryFrame.hero:NumAttributes("encountered_factions")
	for i=1, numEncounteredFactions do
		local factionId = SCREENS.InventoryFrame.hero:GetAttributeAt("encountered_factions", i)
		local factionData = _G.DATA.Factions[factionId]
		self:activate_widget(string.format("str_faction%d", i))
		self:set_text(string.format("str_faction%d", i), string.format(factionData.name,"NAME"))
		--LOG("Name: " .. string.format(factionData.name,"NAME"))
		self:activate_widget(string.format("prog_faction%d_bad", i))
		self:activate_widget(string.format("prog_faction%d_good", i))
		self:set_alpha(string.format("prog_faction%d_bad", i),1)
		self:set_alpha(string.format("prog_faction%d_good", i),1)
		
		local standing = SCREENS.InventoryFrame.hero:GetAttributeAt("faction_standings", factionId)
		
		if highestFaction.standing <= standing then
			highestFaction.standing = standing
			highestFaction.id = i
		end
		
		if standing < 0 then
			self:set_progress(string.format("prog_faction%d_bad", i), standing*-1)
			self:set_progress(string.format("prog_faction%d_good", i), 0)
		else
			self:set_progress(string.format("prog_faction%d_good", i), standing)
			self:set_progress(string.format("prog_faction%d_bad", i), 0)
		end
	end
	
	self:OnMouseMove(highestFaction.id, 0, 0, false)
end

function InvFactions:OnMouseEnter(id, x, y)
	
	if(id > SCREENS.InventoryFrame.hero:NumAttributes("encountered_factions")) then
		LOG("Non-encountered faction")
	   return Menu.MESSAGE_HANDLED
	end
	local factionId = SCREENS.InventoryFrame.hero:GetAttributeAt("encountered_factions", id)
	
	-- if the faction is visible, then update the information
	-- in the current faction window
	if CollectionContainsAttribute(SCREENS.InventoryFrame.hero, "encountered_factions", factionId) then
		PlaySound("snd_mapmenuclick")
		local factionData = _G.DATA.Factions[factionId]
		self:activate_widget("str_faction_summary")
		self:set_text("str_curr_faction", string.format(factionData.name,"NAME"))
		self:set_text("str_faction_desc", string.format(factionData.name,"DESC"))
		self:set_text("str_faction_system", string.format(factionData.name,"SYSTEM"))
		--self:set_text("str_faction_summary", string.format(factionData.name,"SUMMARY"))
		self:set_image("icon_curr_faction", factionData.icon)
		local standing = SCREENS.InventoryFrame.hero:GetFactionStanding(factionId)
		
		if standing == _G.STANDING_CRIMINAL then
			self:set_text("str_faction_status", "[CRIMINAL]")
			self:set_font("str_faction_status", "font_info_red")
		elseif standing == _G.STANDING_SUSPECT then -- > -49
			self:set_text("str_faction_status", "[SUSPECT]")
			self:set_font("str_faction_status", "font_info_red")
		elseif standing == _G.STANDING_NEUTRAL then-- > -10
			self:set_text("str_faction_status", "[NEUTRAL]")
			self:set_font("str_faction_status", "font_info_white")
		elseif standing == _G.STANDING_FRIENDLY then -- > 50
			self:set_text("str_faction_status", "[FRIENDLY]")
			self:set_font("str_faction_status", "font_info_blue")
		elseif standing == _G.STANDING_ALLIED then
			self:set_text("str_faction_status", "[ALLY]")
			self:set_font("str_faction_status", "font_info_blue")
		end	
		
		
	end
	
	--return Menu.MESSAGE_HANDLED
	return Menu.OnMouseEnter(self, id, x, y)
end

function InvFactions:OnGamepadDPad(user, dpad, x, y)
	if y ~= 0 then
		self.selectedIndex = self.selectedIndex - y
		if self.selectedIndex < 1 then
			self.selectedIndex = SCREENS.InventoryFrame.hero:NumAttributes("encountered_factions")
		elseif self.selectedIndex > SCREENS.InventoryFrame.hero:NumAttributes("encountered_factions") then
			self.selectedIndex = 1
		end
		self:OnMouseEnter(self.selectedIndex, 0, 0)
		self:set_widget_position("icon_gp_cursor", 108, 194 + ((self.selectedIndex-1) * 31))
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvFactions:OnGamepadJoystick(user, joystick, x_dir, y_dir)
	if self.lastTime < GetGameTime() - 250 then
		if y_dir >= 100 then
			self:OnGamepadDPad(user, 0, 0, 1)
			self.lastTime = GetGameTime()
			return Menu.MESSAGE_HANDLED

		elseif y_dir <= -100 then
			self:OnGamepadDPad(user, 0, 0, -1)
			self.lastTime = GetGameTime()
			return Menu.MESSAGE_HANDLED

		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end

-- return an instance of InvFactions
return ExportSingleInstance("InvFactions")