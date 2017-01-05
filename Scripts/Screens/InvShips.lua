
use_safeglobals()

-- declare menu

class "InvShips" (Menu);

function InvShips:__init()
	super()
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\InvShips.xml")
end


function InvShips:OnOpen()
	LOG("InvShipsMenu opened");
	self.lastTime = GetGameTime()
	self:ResetShipList()
	
	
	local numShips = SCREENS.InventoryFrame.hero:NumAttributes("ship_list")
	assert(numShips<=3,string.format("Too many ships in ship_list %d", numShips))
	if numShips > 3 then
		numShips = 3
	end
	for i=1,numShips do
		local shipID = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", i):GetAttribute("ship")
		self:set_text(string.format("str_ship%d", i), string.format("[%s_NAME]", shipID))
		self:set_image(string.format("icon_ship%d", i), string.format("img_%s", shipID))

		self:activate_widget(string.format("str_ship%d_class", i))
		self:activate_widget(string.format("str_ship%d_slots", i))
		
		
		if i == SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout") then
			self:set_image(string.format("icon_ship%d_bg", i), "img_portrait_bg_light")
			self:set_text("str_ship_name", string.format("[%s_NAME]", shipID))
			self:set_image("icon_ship", string.format("img_%s_L", shipID))
		end
		
		self:set_text_raw(string.format("str_ship%d_class", i), substitute(translate_text("[_CLASS]"), translate_text(_G.GLOBAL_FUNCTIONS.GetShipClass(SHIPS[shipID].max_items))))
		self:set_text_raw(string.format("str_ship%d_slots", i), string.format("(%s)", substitute(translate_text("[_SLOTS]"), SHIPS[shipID].max_items)))
	end
	
	for i=numShips+1, 3 do		
		self:hide_widget(string.format("str_ship%d_class", i))
		self:hide_widget(string.format("str_ship%d_slots", i))
	end
	
	if SCREENS.InventoryFrame.opponent then
		for i=1,3 do
			self:deactivate_widget(string.format("pad_ship%d", i))
		end
	end
	
	if IsGamepadActive() and GetScreenWidth() >= 1024 then -- running Xbox
		self:hide_widget("str_action_desc")
	else
		self:hide_widget("grp_gp")
	end
	_G.ShowTutorialFirstTime(13,_G.Hero)
	
	
	--Shown in DS Screens Only
	local shipID = _G.Hero:GetAttributeAt("ship_list", _G.Hero:GetAttribute("ship_loadout")):GetAttribute("ship")
	local speedData = math.max(1, math.min(5, math.floor(SHIPS[shipID].max_speed / 30)))
	self:set_text_raw("str_ship_speed_val",    tostring(speedData))
	self:set_text_raw("str_ship_slots_val",    tostring(SHIPS[shipID].max_items))
	self:set_text_raw("str_ship_weaps_val",    tostring(SHIPS[shipID].weapons_rating))
	self:set_text_raw("str_ship_eng_val",      tostring(SHIPS[shipID].engine_rating))
	self:set_text_raw("str_ship_cpu_val",      tostring(SHIPS[shipID].cpu_rating))
	self:set_text_raw("str_ship_capacity_val", tostring(SHIPS[shipID].cargo_capacity))
	self:set_text_raw("str_ship_hull_val",     tostring(SHIPS[shipID].hull))
	self:set_text_raw("str_ship_shields_val",  tostring(SHIPS[shipID].shield))
	
	return Menu.OnOpen(self)
end

function InvShips:OnClose()
	self.lastTime = nil
	if self.showInfo then
		LOG("InvHero:OnClose()")		
		close_custompopup_menu()
	end
	self.showInfo = nil
	return Menu.MESSAGE_HANDLED
end

function InvShips:ResetShipList()
	for i=1,3 do
		self:set_text_raw(string.format("str_ship%d", i), "")
		self:set_image(string.format("icon_ship%d", i), "")
		self:set_image(string.format("icon_ship%d_bg", i), "img_portrait_bg_dark")
		self:set_text_raw(string.format("str_ship%d_weaps_val", i), "")
		self:set_text_raw(string.format("str_ship%d_cpu_val", i), "")
		self:set_text_raw(string.format("str_ship%d_eng_val", i), "")
		self:set_text_raw(string.format("str_ship%d_capacity_val", i), "")
		self:set_text_raw(string.format("str_ship%d_shields_val", i), "")
		self:set_text_raw(string.format("str_ship%d_hull_val", i), "")
	end
end

function InvShips:OnMouseLeftButton(id, x, y, up)
	-- reselecting the current ship, or selecting a blank slot - do nothing
	if id == SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout") or id > SCREENS.InventoryFrame.hero:NumAttributes("ship_list") then
		return Menu.MESSAGE_HANDLED
	else
		PlaySound("snd_mapmenuclick")
		-- update display
		local currId = SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout")
		self:set_image(string.format("icon_ship%d_bg", currId), "img_portrait_bg_dark")
		self:set_image(string.format("icon_ship%d_bg", id), "img_portrait_bg_light")
		
		-- update internal information
		local shipID = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", id):GetAttribute("ship")
		if not SCREENS.InventoryFrame.mp then
			-- Destroy the current "curr_ship"
			local ship = SCREENS.InventoryFrame.hero:GetAttribute("curr_ship")
			_G.GLOBAL_FUNCTIONS.ClearShip(ship)
			ship = _G.GLOBAL_FUNCTIONS.LoadShip(shipID)
			SCREENS.InventoryFrame.hero:SetAttribute("curr_ship", ship)
			ship.pilot=SCREENS.InventoryFrame.hero
			
			_G.SCREENS.InventoryFrame:UpdateHeroView()
			
			if _G.SCREENS.MiningIntroMenu:IsOpen() then
				_G.SCREENS.MiningIntroMenu:SetPlayerShip()
			end
		end
		SCREENS.InventoryFrame.hero:SetAttribute("ship_loadout", id)
		
		-- update top screen (DS version only)
		self:UpdateShipInfo(shipID)
	
		_G.Hero:SetToSave()		
	end
	
	return Menu.MESSAGE_HANDLED
end


--[[
function InvShips:OnMouseEnter(id, x, y)
	if id <= SCREENS.InventoryFrame.hero:NumAttributes("ship_list") then
		_G.GLOBAL_FUNCTIONS.ShipPopup(SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", id):GetAttribute("ship"), x, y)
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end
--]]
function InvShips:OnMouseLeave(id, x, y)
	LOG("InvShips:OnLoseFocus()")
	close_custompopup_menu()
	return Menu.MESSAGE_HANDLED
end

function InvShips:OnGamepadDPad(user, dpad, x, y)
	LOG(string.format("InvShips:OnGamepadDPad(user:%d, dpad:%d, x:%d, y:%d)", user, dpad, x, y))
	if self.lastTime < GetGameTime() - 250 then
		local loadout = SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout")
		if x == -1 and loadout > 1 then
			self:OnMouseLeftButton(loadout-1, nil, nil, nil)
			self.lastTime = GetGameTime()
		elseif x == 1 then
			self:OnMouseLeftButton(loadout+1, nil, nil, nil)
			self.lastTime = GetGameTime()
		end
		if x ~= 0 and self.showInfo then
			close_custompopup_menu()
			self:OnMouseEnter(SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"), 119 + (SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout") - 1) * 265, 251)
		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvShips:OnGamepadJoystick(user, joystick, x_dir, y_dir)
	LOG(string.format("InvShips:OnGamepadJoystick(user:%d, joystick:%d, x_dir:%d, y_dir:%d)", user, joystick, x_dir, y_dir))
	LOG("GamepadInput.GAMEPAD_JOYSTICK = "..GamepadInput.GAMEPAD_JOYSTICK)
	--if joystick == GamepadInput.GAMEPAD_JOYSTICK and self.lastTime < GetGameTime() - 250 then
	if self.lastTime < GetGameTime() - 250 then
		local loadout = SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout")
		LOG("Loadout = "..loadout)
		if x_dir < -100 and loadout > 1 then
			self:OnMouseLeftButton(loadout-1, nil, nil, nil)
			self.lastTime = GetGameTime()
			
		elseif x_dir > 100 then
			self:OnMouseLeftButton(loadout+1, nil, nil, nil)
			self.lastTime = GetGameTime()
			--self:OnGamepadDPad(user, 0, -1, 0)
		
		end
		
		if (x_dir > 50 or x_dir < -50)  and self.showInfo then
			close_custompopup_menu()
			self:OnMouseEnter(SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"), 119 + (SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout") - 1) * 265, 251)
		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvShips:OnGamepadButton(user, button, value)
	if value == 1 and button == _G.BUTTON_Y then
		PlaySound("snd_buttclick")
		self.showInfo = not self.showInfo
		if self.showInfo then
			self:OnMouseEnter(SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"), 0, 0)
		else
			close_custompopup_menu()
		end
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

dofile("Assets/Scripts/Screens/InvShipsPlatform.lua")

-- return an instance of InvShips
return ExportSingleInstance("InvShips")
