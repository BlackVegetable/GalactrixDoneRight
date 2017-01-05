
use_safeglobals()

-- declare menu

class "InvCargo" (Menu);

function InvCargo:__init()
	super()
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\InvCargo.xml")
end


function InvCargo:OnOpen()
	LOG("InvCargoMenu opened");

	self.lastTime = GetGameTime()

	local shipID = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout")):GetAttribute("ship")
	self:set_text("str_shipname", string.format("[%s_NAME]", shipID))
	self:set_image("icon_ship_large", string.format("img_%s_L", shipID))
	self:set_image("icon_ship", string.format("img_%s", shipID))
	
	self:set_text_raw("str_ship_class", substitute(translate_text("[_CLASS]"), translate_text(_G.GLOBAL_FUNCTIONS.GetShipClass(SHIPS[shipID].max_items))))
	self:set_text_raw("str_ship_slots", string.format("%s%s%s", "(", substitute(translate_text("[_SLOTS]"), SHIPS[shipID].max_items), ")"))
	
	self:set_text_raw("str_ship_weaps_val",    tostring(SHIPS[shipID].weapons_rating))
	self:set_text_raw("str_ship_eng_val",      tostring(SHIPS[shipID].engine_rating))
	self:set_text_raw("str_ship_cpu_val",      tostring(SHIPS[shipID].cpu_rating))
	self:set_text_raw("str_ship_capacity_val", tostring(SHIPS[shipID].cargo_capacity))
	self:set_text_raw("str_ship_hull_val",     tostring(SHIPS[shipID].hull))
	self:set_text_raw("str_ship_shields_val",  tostring(SHIPS[shipID].shield))
	
	local hasCargo = false
	self:activate_widget("butt_jett")
	self:activate_widget("icon_jett")
	self:activate_widget("str_jett")
	
	for i=1,_G.NUM_CARGOES do
		if SCREENS.InventoryFrame.hero:GetAttributeAt("cargo", i) ~= 0 then
			hasCargo = true
			self:activate_widget(string.format("butt_cargo%d_jett", i))
		else
			self:deactivate_widget(string.format("butt_cargo%d_jett", i))
		end
		self:set_text_raw(string.format("str_cargo%d_weight", i), tostring(SCREENS.InventoryFrame.hero:GetAttributeAt("cargo", i)))
		self:set_text_raw(string.format("str_cargo%d_value", i), tostring(_G.DATA.Cargo[i].cost))
	end
	
	if SCREENS.InventoryFrame.mp or (not hasCargo) then
		self:deactivate_widget("butt_jett")
		self:hide_widget("icon_jett")
		self:hide_widget("str_jett")
	end
	
	self:set_text_raw("str_percent", string.format("%d%% %s", self:CalculatePercentFull(), translate_text("[CAPACITY]")))
	
	if IsGamepadActive() then
		self.selectedWidget = 1
		self:hide_widget("grp_not_gp")
		self:set_widget_position("icon_gp_select", 396, 222)
		if SCREENS.InventoryFrame.hero:GetAttributeAt("cargo", 1) > 0 then
			self:activate_widget("icon_jett_type")
			self:activate_widget("str_jett_type")
		else
			self:hide_widget("icon_jett_type")
			self:hide_widget("str_jett_type")
		end
	else
		self:hide_widget("grp_gp")
	end
	
	local function DS_LanguageResize()
		if get_language() == 4 then -- italian
			self:set_widget_w("butt_jett", 160)
			self:set_widget_position("butt_jett", 48, self:get_widget_y("butt_jett"))
		end
	end
	
	_G.DSOnly(DS_LanguageResize)
	
	_G.ShowTutorialFirstTime(15, _G.Hero)
	
	return Menu.OnOpen(self)
end

function InvCargo:OnGamepadDPad(user, dpad, x, y)
	if y ~= 0 then
		self.selectedWidget = self.selectedWidget - y
		if self.selectedWidget > 10 then
			self.selectedWidget = 1
		elseif self.selectedWidget < 1 then
			self.selectedWidget = 10
		end
		if _G.Hero:GetAttributeAt("cargo", self.selectedWidget) > 0 then
			self:activate_widget("icon_jett_type")
			self:activate_widget("str_jett_type")
		else
			self:hide_widget("icon_jett_type")
			self:hide_widget("str_jett_type")
		end
		self:set_widget_position("icon_gp_select", 396, 222 + ((self.selectedWidget - 1) * 34))
		PlaySound("snd_mapmenuclick")
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvCargo:OnGamepadJoystick(user, joystick, x_dir, y_dir)
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

function InvCargo:OnGamepadButton(user, button, value)
	if (button == _G.BUTTON_Y) then -- XBox Jettison Type button
		PlaySound("snd_buttclick")
		if _G.Hero:GetAttributeAt("cargo", self.selectedWidget) > 0 then
			self:OnButton(self.selectedWidget + 20, 0, 0)
		end
		return Menu.MESSAGE_HANDLED

	elseif (button == _G.BUTTON_X) then
		if self:HasCargo() then
			PlaySound("snd_buttclick")
			self:OnButton(14, 0, 0)
		end
		return Menu.MESSAGE_NOT_HANDLED
  
	else
		return Menu.MESSAGE_NOT_HANDLED
	end
end

function InvCargo:OnButton(id, x, y)
	LOG("InvCargo:OnButton")
	local contraband = SCREENS.InventoryFrame.hero:GetAttributeAt("cargo",_G.CARGO_CONTRABAND)
	LOG(string.format("Curr Contraband = %d", contraband))
	
	--BEGIN_STRIP_DS
	local function CancelEncounter()
		local newCont = SCREENS.InventoryFrame.hero:GetAttributeAt("cargo",_G.CARGO_CONTRABAND)
		if _G.SCREENS.SolarSystemMenu:IsOpen() and contraband > newCont then
			local world = _G.SCREENS.SolarSystemMenu:GetWorld()
			for i,v in pairs(world.encounters) do
				if v.contraband_detected and SCREENS.InventoryFrame.hero:GetFactionStanding(v.enemy:GetAttribute("faction")) >= _G.STANDING_NEUTRAL then
					v.contraband_detected = nil
					v.targetObj = nil
					v.enemy.particle = "N"
				end
			end
		end
	end
	--END_STRIP_DS	
	
	if id == 14 and self:HasCargo() then
		PlaySound("snd_click")
		-- jettison all cargo
		local function ConfirmJettison(yes_clicked)
			if yes_clicked then
				PlaySound("snd_jettison")
				-- sound to indicate cargo jettisoned here
				
				local isXBox = IsGamepadActive()
				for i=1, _G.NUM_CARGOES do
					SCREENS.InventoryFrame.hero:SetAttributeAt("cargo", i, 0)
					self:set_text_raw(string.format("str_cargo%d_weight", i), "0")
					if isXBox == false then
						self:deactivate_widget(string.format("butt_cargo%d_jett", i))
					end
				end
				self:deactivate_widget("butt_jett")
				self:set_text_raw("str_percent", "0%")
				self:hide_widget("icon_jett_type")
				self:hide_widget("str_jett_type")
				self:hide_widget("icon_jett")
				self:hide_widget("str_jett")
				
				_G.NotDS(CancelEncounter)
				SCREENS.InventoryFrame.hero:SetToSave()
			end
		end
		
		open_yesno_menu("[JETTISON_CARGO]", "[JETTISON_CARGO_QUERY]", ConfirmJettison, "[YES]", "[NO]" )
		return Menu.MESSAGE_HANDLED
	elseif id > 20 and id < 31 then
		id = id - 20
		PlaySound("snd_click")
		local function ConfirmJettison(yes_clicked)
			if yes_clicked then
				PlaySound("snd_jettison")
				SCREENS.InventoryFrame.hero:SetAttributeAt("cargo", id, 0)
				self:set_text_raw(string.format("str_cargo%d_weight", id), "0")
				self:deactivate_widget(string.format("butt_cargo%d_jett", id))
				local hasCargo = false
				for i=1,_G.NUM_CARGOES do
					if SCREENS.InventoryFrame.hero:GetAttributeAt("cargo", i) ~= 0 then
						hasCargo = true
					end
				end
				if hasCargo then
					self:activate_widget("butt_jett")
					self:activate_widget("icon_jett")
					self:activate_widget("str_jett")
				else
					self:deactivate_widget("butt_jett")
					self:hide_widget("icon_jett")
					self:hide_widget("str_jett")
				end
				self:set_text_raw("str_percent", string.format("%d%%", self:CalculatePercentFull()))
				self:hide_widget("icon_jett_type")
				self:hide_widget("str_jett_type")

				_G.NotDS(CancelEncounter)	
				SCREENS.InventoryFrame.hero:SetToSave()							
			end
		end
		if SCREENS.InventoryFrame.hero:GetAttributeAt("cargo", id) ~= 0 then
			open_yesno_menu("[JETTISON_CARGO]", "[JETTISON_CARGO_TYPE_QUERY]", ConfirmJettison, "[YES]", "[NO]" )
		end
		LOG(string.format("Jettison Cargo type %d", id))
		return Menu.MESSAGE_HANDLED
	end
	
	
	
	return Menu.MESSAGE_NOT_HANDLED
end

function InvCargo:OnMouseEnter(id, x, y)
	if id == 20 then
		local hero = SCREENS.InventoryFrame.hero
		_G.GLOBAL_FUNCTIONS.ShipPopup(hero:GetAttributeAt("ship_list", hero:GetAttribute("ship_loadout")):GetAttribute("ship"), x+119, y+251)
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvCargo:OnMouseLeave()
	close_custompopup_menu()
	return Menu.MESSAGE_HANDLED
end

-- Calculates and returns what percentage of the player's fleet filled with cargo
function InvCargo:CalculatePercentFull()
	local maximumCargo = 0
	for i=1,SCREENS.InventoryFrame.hero:NumAttributes("ship_list") do
		local shipID = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", i):GetAttribute("ship")
		maximumCargo = maximumCargo + _G.SHIPS[shipID].cargo_capacity
	end
	
	local currentCargo = 0
	for i=1, _G.NUM_CARGOES do
		currentCargo = currentCargo + SCREENS.InventoryFrame.hero:GetAttributeAt("cargo", i)
	end
	
	return math.floor((currentCargo / maximumCargo) * 100)
end

function InvCargo:HasCargo()
	for i=1, _G.NUM_CARGOES do
		if SCREENS.InventoryFrame.hero:GetAttributeAt("cargo", i) > 0 then
			return true
		end
	end
	return false
end

-- return an instance of InvCargo
return ExportSingleInstance("InvCargo")