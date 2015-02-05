
use_safeglobals()

-- declare menu

class "InvFitout" (Menu);

--[[ For reference:
pad and button id's used in PC and DS .xml files:
1-8   = the pad that is selected to change the item (overlays the line of text on PC or the icon on the DS)
11-18 = the unequip button on PC
60    = the pad overlaying the ship graphic on PC
71-78 = the unequip button on DS
81-88 = the pad overlaying the ? on the DS

The unequip button ids are different on PC and DS because they're handled differently.
]]

local current_item -- id of currently selected item
local max_items    -- max number of items that can be equipped on current ship

function InvFitout:__init()
	super()
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\InvFitout.xml")
end


function InvFitout:OnOpen()
	LOG("InvFitout Menu Opened")
	local loadout = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"))
	self.lastTime = GetGameTime()
	
	self:set_text_raw("str_plans_info", string.format("%s %s",translate_text("[PLANS_]"), tostring(SCREENS.InventoryFrame.hero:NumAttributes("plans"))))
	local enemy = false
	if SCREENS.InventoryFrame.hero.mp_enemy then
		enemy = true
	end
	-- set ship logo and info
	local shipID = loadout:GetAttribute("ship")
	self:set_text("str_shipname", string.format("[%s_NAME]", shipID))
	self:set_image("icon_ship_large", string.format("img_%s_L", shipID))
	self:set_image("icon_ship", string.format("img_%s", shipID))
	
	for i=1, SHIPS[shipID].max_items do
		LOG(string.format("activate item list %d", i))
		self:set_alpha(string.format("item%d_frame", i), 1.0)
		self:activate_widget(string.format("item%d_pad", i))
		self:activate_widget(string.format("item%d_name", i))
		self:set_text(string.format("item%d_name", i), "")
      self:activate_widget(string.format("item%d_icon_bg", i))
		
		if SCREENS.InventoryFrame.hero == _G.Hero and not enemy then	
			self:activate_widget(string.format("item%d_unequip", i))	
		else
			self:hide_widget(string.format("item%d_unequip", i))
		end
	end
	
	for i=SHIPS[shipID].max_items+1,8 do
		LOG(string.format("Hide Widgets %d", i))
		self:hide_widget(string.format("item%d_type", i))
		self:set_alpha(string.format("item%d_frame", i), 0.5)
		self:hide_widget(string.format("item%d_pad", i))
		self:hide_widget(string.format("item%d_name", i))
		self:hide_widget(string.format("item%d_weap_bg", i))
		self:hide_widget(string.format("item%d_weap_val", i))
		self:hide_widget(string.format("item%d_cpu_bg", i))
		self:hide_widget(string.format("item%d_cpu_val", i))
		self:hide_widget(string.format("item%d_eng_bg", i))
		self:hide_widget(string.format("item%d_eng_val", i))
		self:hide_widget(string.format("item%d_unequip", i))
      self:hide_widget(string.format("item%d_icon_bg", i))
	end
	
	-- set energy usage information
	--local loadout = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"))

	self:set_text_raw("str_ship_class", substitute(translate_text("[_CLASS]"), translate_text(_G.GLOBAL_FUNCTIONS.GetShipClass(SHIPS[shipID].max_items))))
	self:set_text_raw("str_ship_slots", "("..substitute(translate_text("[_SLOTS]"), SHIPS[shipID].max_items)..")")	
	self:set_text_raw("str_ship_slots", string.format("(%s)", substitute(translate_text("[_SLOTS]"), SHIPS[shipID].max_items)))	
	
	self:ResetItemList()
	if SCREENS.InventoryFrame.mp then	
		self:deactivate_widget("butt_reviewplans")
		if SCREENS.InventoryFrame.opponent then
			for i=1,8 do
				self:deactivate_widget("item"..tostring(i).."_pad")
			end
		end
	end
	
	for i=1,8 do
		self:hide_widget(string.format("item%d_light", i))
	end
	
	self:hide_widget("icon_gp_a")
	self:hide_widget("str_gp_a")
	
	-- gamepad functionality - if gamepads are used then set the 'selected' item

	local function ShowGamepad()
		self.selectedWidget = 1
		self:activate_widget("item1_light")
		self:activate_widget("icon_gp_a")
		self:activate_widget("str_gp_a")
		if SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout")):NumAttributes("items") > 0 then
			self:activate_widget("icon_gp_x")
			self:activate_widget("str_gp_x")
			self:activate_widget("icon_gp_y")
			self:activate_widget("str_gp_y")
			
			-- hack to use shorter text tag in Spanish coz the normal one doesn't fit.
			if get_language() == 3 then
				self:set_text("str_gp_y", "[MOREINFO_SHORT]")
			end
			
		else
			self:hide_widget("icon_gp_x")
			self:hide_widget("str_gp_x")
			self:hide_widget("icon_gp_y")
			self:hide_widget("str_gp_y")
		end
		for i=1,8 do
			self:hide_widget(string.format("item%d_unequip", i))
		end
	end
	
	_G.XBoxOnly(ShowGamepad)
	_G.ShowTutorialFirstTime(14, _G.Hero)
	return Menu.MESSAGE_HANDLED
end

function InvFitout:OnClose()
	if self.showInfo then
		close_custompopup_menu()
	end
	
	self.selectedWidget = nil
	self.showInfo       = nil
	self.current_item   = nil
	self.lastTime 		= nil
	
	return Menu.MESSAGE_HANDLED
end

function InvFitout:OnGamepadDPad(user, dpad, x, y)
	if y ~= 0 then
		local hero = SCREENS.InventoryFrame.hero
		local maxItems = SHIPS[hero:GetAttributeAt("ship_list", hero:GetAttribute("ship_loadout")):GetAttribute("ship")].max_items
		self:hide_widget(string.format("item%d_light", self.selectedWidget))
		close_custompopup_menu(self.selectedWidget)
		self.selectedWidget = self.selectedWidget - y
		if self.selectedWidget < 1 then
			self.selectedWidget = maxItems
		elseif self.selectedWidget > maxItems then
			self.selectedWidget = 1
		end
		local loadout = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", hero:GetAttribute("ship_loadout"))
		if self.selectedWidget <= loadout:NumAttributes("items") then
			if self.showInfo then
				_G.GLOBAL_FUNCTIONS.ItemPopup(loadout:GetAttributeAt("items", self.selectedWidget), 450+x, 247 + (34 * (self.selectedWidget-1)) + y, "InvEquipment", self.selectedWidget)
			end
			self:activate_widget("icon_gp_x")
			self:activate_widget("str_gp_x")
			self:activate_widget("icon_gp_y")
			self:activate_widget("str_gp_y")
			
			-- hack to use shorter text tag in Spanish coz the normal one doesn't fit.
			if get_language() == 3 then
				self:set_text("str_gp_y", "[MOREINFO_SHORT]")
			end
			
		else
			self:hide_widget("icon_gp_x")
			self:hide_widget("str_gp_x")
			self:hide_widget("icon_gp_y")
			self:hide_widget("str_gp_y")			
		end
		self:activate_widget(string.format("item%d_light", self.selectedWidget))
		PlaySound("snd_mapmenuclick")
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvFitout:OnGamepadJoystick(user, joystick, x_dir, y_dir)
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

function InvFitout:OnGamepadButton(user, button, value)
	
	if value == 1 then
		local hero = SCREENS.InventoryFrame.hero
		local loadout = hero:GetAttributeAt("ship_list", hero:GetAttribute("ship_loadout"))
		
		if button == _G.BUTTON_A then
			PlaySound("snd_buttclick")
			self:OnMouseLeftButton(self.selectedWidget,0,0,0)
			return Menu.MESSAGE_HANDLED
		elseif button == _G.BUTTON_X then
			if self.selectedWidget <= loadout:NumAttributes("items") then
				PlaySound("snd_buttclick")
				self:OnButton(self.selectedWidget + 10, 0, 0)
				return Menu.MESSAGE_HANDLED
			end
		elseif button == _G.BUTTON_Y then
			self.showInfo = not self.showInfo
			if self.selectedWidget <= loadout:NumAttributes("items") then
				PlaySound("snd_buttclick")
				
				if self.showInfo then
					_G.GLOBAL_FUNCTIONS.ItemPopup(loadout:GetAttributeAt("items", self.selectedWidget), 450, 247 + (34 * (self.selectedWidget-1)), "InvEquipment", self.selectedWidget)
				else
					close_custompopup_menu(self.selectedWidget)
				end
			end
		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvFitout:ResetItemList()
	local loadout = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"))
	
	local function DSClickText(i)
		self:set_text(string.format("item%d_name", i), "[TOUCH_HERE_TO_EQUIP]")
	end
	
	local function NotDSClickText(i)
		self:set_text(string.format("item%d_name", i), "[CLICK_HERE_TO_EQUIP]")
	end	
	
	for i=1,8 do
		if i <= loadout:NumAttributes("items") then
			LOG(string.format("Reset Item List %d", i))
			-- show equipment in this slot
			self:set_font(string.format("item%d_name", i), "font_info_white")
			local item = loadout:GetAttributeAt("items", i)
			if GetScreenWidth() <= 256 then
            self:set_text(string.format("item%d_name", i), "") -- don't show a name on DS, we're showing an icon instead
         else
			local myName = translate_text(string.format("[%s_NAME]", item))
			local myWidth = self:get_widget_w(string.format("item%d_name", i))
			myName = fit_text_to("font_info_white", myName, myWidth)
            self:set_text(string.format("item%d_name", i), myName)         
         end
         
         self:activate_widget(string.format("item%d_query", i))
         self:activate_widget(string.format("item%d_query_pad", i))
         self:set_image(string.format("item%d_icon", i), string.format("%s_L", tostring(ITEMS[item].icon))) 
         self:set_alpha(string.format("item%d_icon_bg", i), 0.8)
		 
			if not IsGamepadActive() then
				if SCREENS.InventoryFrame.hero == _G.Hero and not _G.Hero.mp_enemy then	
					self:activate_widget(string.format("item%d_unequip", i))	
				else
					self:hide_widget(string.format("item%d_unequip", i))
				end
			end
			
			if ITEMS[item].weapon_requirement == 0 then
				self:hide_widget(string.format("item%d_weap_val",i))
				self:hide_widget(string.format("item%d_weap_bg",i))
			else
				self:activate_widget(string.format("item%d_weap_val",i))
				self:activate_widget(string.format("item%d_weap_bg",i))
				self:set_text(string.format("item%d_weap_val",i), tostring(ITEMS[item].weapon_requirement))
			end
			if ITEMS[item].cpu_requirement == 0 then
				self:hide_widget(string.format("item%d_cpu_val", i))
				self:hide_widget(string.format("item%d_cpu_bg", i))
			else
				self:activate_widget(string.format("item%d_cpu_val", i))
				self:activate_widget(string.format("item%d_cpu_bg", i))
				self:set_text(string.format("item%d_cpu_val",i), tostring(ITEMS[item].cpu_requirement))
			end
			if ITEMS[item].engine_requirement == 0 then
				self:hide_widget(string.format("item%d_eng_val", i))
				self:hide_widget(string.format("item%d_eng_bg", i))
			else
				self:activate_widget(string.format("item%d_eng_val", i))
				self:activate_widget(string.format("item%d_eng_bg", i))
				self:set_text(string.format("item%d_eng_val",i), tostring(ITEMS[item].engine_requirement))
			end
			self:activate_widget(string.format("item%d_type", i))
			LOG("Processing item type")
			if ITEMS[item].weapon_requirement >= ITEMS[item].cpu_requirement then
				LOG("weapon > cpu")
				if ITEMS[item].weapon_requirement >= ITEMS[item].engine_requirement then
					LOG("weapon > engine")
					self:set_image(string.format("item%d_type", i), "img_weap_icon")
				else
					LOG("engine > weapon")
					self:set_image(string.format("item%d_type", i), "img_eng_icon")
				end
			else
				LOG("cpu > weapon")
				if ITEMS[item].cpu_requirement >= ITEMS[item].engine_requirement then
					LOG("cpu > engine")
					self:set_image(string.format("item%d_type", i), "img_cpu_icon")
				else
					LOG("engine > cpu")
					self:set_image(string.format("item%d_type", i), "img_eng_icon")
				end
			end
		else
			-- blank slot
			if GetScreenWidth() <= 256 then
				self:set_image(string.format("item%d_icon", i), "")
			end
			
			_G.DSOnly(DSClickText, i)	
			--BEGIN_STRIP_DS
			_G.NotDS(NotDSClickText, i)			
			--END_STRIP_DS
			
			self:set_font(string.format("item%d_name", i), "font_info_gray")
			
			--BEGIN_STRIP_DS
			WiiOnly(self.set_font, self, string.format("item%d_name", i), "font_info_white")
			--END_STRIP_DS
			
			self:hide_widget(string.format("item%d_query", i))
			self:hide_widget(string.format("item%d_query_pad", i))
			self:hide_widget(string.format("item%d_type", i))
			self:hide_widget(string.format("item%d_weap_val", i))
			self:hide_widget(string.format("item%d_cpu_val", i))
			self:hide_widget(string.format("item%d_eng_val", i))
			self:hide_widget(string.format("item%d_weap_bg", i))
			self:hide_widget(string.format("item%d_cpu_bg", i))
			self:hide_widget(string.format("item%d_eng_bg", i))
			self:hide_widget(string.format("item%d_unequip", i))
         self:set_alpha(string.format("item%d_icon_bg", i), 0.5)
			
			if SCREENS.InventoryFrame.hero ~= _G.Hero or SCREENS.InventoryFrame.hero.mp_enemy then	
				self:hide_widget(string.format("item%d_name", i))
				self:set_alpha(string.format("item%d_frame", i), 0.5)				
			end			
		end
	end
	
	self:UpdateScrollBars()
	
	if self.selectedWidget and SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout")):NumAttributes("items") >= self.selectedWidget then
		self:activate_widget("icon_gp_x")
		self:activate_widget("str_gp_x")
		self:activate_widget("icon_gp_y")
		self:activate_widget("str_gp_y")
			
		-- hack to use shorter text tag in Spanish coz the normal one doesn't fit.
		if get_language() == 3 then
			self:set_text("str_gp_y", "[MOREINFO_SHORT]")
		end
			
	else
		self:hide_widget("icon_gp_x")
		self:hide_widget("str_gp_x")
		self:hide_widget("icon_gp_y")
		self:hide_widget("str_gp_y")			
	end
end

function InvFitout:OnMouseLeave(id, x, y)
	self:hide_widget(string.format("item%d_light", id))
	if not _G.is_open("TutorialMenu") then
		close_custompopup_menu(id)
	end
	return Menu.MESSAGE_HANDLED
end

function InvFitout:UpdateScrollBars(item_id)
	local loadout = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"))
	local energyUsed = { cpu = 0, engine = 0, weapons = 0 }
	local shipID = loadout:GetAttribute("ship")
	for i=1,loadout:NumAttributes("items") do
		if item_id ~= i then
			local item = loadout:GetAttributeAt("items", i)
			energyUsed.cpu = energyUsed.cpu + ITEMS[item].cpu_requirement
			energyUsed.engine = energyUsed.engine + ITEMS[item].engine_requirement
			energyUsed.weapons = energyUsed.weapons + ITEMS[item].weapon_requirement
		end
	end

	self:set_text_raw("str_ship_weaps_val", string.format("%d/%d", energyUsed.weapons, SHIPS[shipID].weapons_rating))
	self:set_text_raw("str_ship_cpu_val", string.format("%d/%d", energyUsed.cpu, SHIPS[shipID].cpu_rating))
	self:set_text_raw("str_ship_eng_val", string.format("%d/%d", energyUsed.engine, SHIPS[shipID].engine_rating))
	self:set_progress("prog_weaps", (energyUsed.weapons / SHIPS[shipID].weapons_rating) * 100)
	self:set_progress("prog_cpu", (energyUsed.cpu / SHIPS[shipID].cpu_rating) * 100)
	self:set_progress("prog_eng", (energyUsed.engine / SHIPS[shipID].engine_rating) * 100)
end

function InvFitout:OnMouseEnter(id, x, y)
	if SCREENS.InventoryFrame.hero then
		local hero = SCREENS.InventoryFrame.hero
      local loadout = hero:GetAttributeAt("ship_list", hero:GetAttribute("ship_loadout"))
		if id == 60 then
			_G.GLOBAL_FUNCTIONS.ShipPopup(loadout:GetAttribute("ship"), x+119, y+251)
		else
			if id <= loadout:NumAttributes("items") then
				_G.GLOBAL_FUNCTIONS.ItemPopup(loadout:GetAttributeAt("items", id), 450+x, 247 + (34 * (id-1)) + y, "InvEquipment", id)
			elseif (id > 80 and id < 89 and id-80 <= loadout:NumAttributes("items")) then
            id = id - 80
				_G.GLOBAL_FUNCTIONS.ItemPopup(loadout:GetAttributeAt("items", id), 450+x, 247 + (34 * (id-1)) + y, "InvEquipment", id)
         end
			if id <= _G.SHIPS[loadout:GetAttribute("ship")].max_items and SCREENS.InventoryFrame.hero == _G.Hero and not enemy then	
				--if id <= loadout:NumAttributes("items") then
					PlaySound("snd_mapmenuclick")
				--else
					--PlaySound("snd_buttclick")
				--end
				self:activate_widget(string.format("item%d_light", id))
			end
		end
	end
	return Menu.MESSAGE_HANDLED
end

function InvFitout:OnMouseLeftButton(id, x, y, up)
	if id > 10 and id < 20 then -- PC unequip button
		self.current_item = id - 10
		self:UnequipItem()
		return Menu.MESSAGE_HANDLED
	elseif id == 60 then
		return Menu.MESSAGE_HANDLED
   	elseif id > 80 and id <90 then
      id = id - 80
		local hero = SCREENS.InventoryFrame.hero
      local loadout = hero:GetAttributeAt("ship_list", hero:GetAttribute("ship_loadout"))
      _G.GLOBAL_FUNCTIONS.ItemPopup(loadout:GetAttributeAt("items", id), 450+x, 247 + (34 * (id-1)) + y, "InvEquipment", id)
	else
		PlaySound("snd_mapmenuclick")
		--sound - player selected a slot on the InvFitout screen
		close_custompopup_menu()
		self.current_item = id
      	SCREENS.InvEquipment:LoadGraphics()
		SCREENS.InvEquipment:Open()
		
		local loadout = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"))
		if self.current_item > loadout:NumAttributes("items") then
			SCREENS.InvEquipment:set_font("item_none_name", "font_info_red")
			SCREENS.InvEquipment:deactivate_widget("item_none_pad")
		else
			SCREENS.InvEquipment:activate_widget("item_none_pad")
			SCREENS.InvEquipment:set_font("item_none_name", "font_info_white")
			self:UpdateScrollBars(self.current_item)
		end
	end
	return Menu.MESSAGE_HANDLED
end

-- called from self. Unequips the current item
function InvFitout:UnequipItem()
	local loadout = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"))
	loadout:EraseAttribute("items", loadout:GetAttributeAt("items", self.current_item))
	PlaySound("snd_click")
	self:ResetItemList()	
	_G.Hero:SetToSave()
end

-- called from InvEquipment. Equips a new item into the selected slot
function InvFitout:EquipItem(itemID)
	local loadout = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"))
	
	-- First check if an item is equipped into this slot, and if so replace it
	if self.current_item <= loadout:NumAttributes("items") then
		--loadout:EraseAttribute("items", loadout:GetAttributeAt("items", self.current_item))
		loadout:SetAttributeAt("items",self.current_item,itemID)
	else
		-- add in the new item to end of list
		loadout:PushAttribute("items", itemID)
	end
	self:ResetItemList()
	_G.Hero:SetToSave()
end

function InvFitout:OnButton(id, x, y)
	close_custompopup_menu()
	if id == 1 then
		SCREENS.InvPlans:Open()
		return Menu.MESSAGE_HANDLED
	elseif id > 10 and id < 20 then
		self.current_item = id - 10
		self:UnequipItem()	
		return Menu.MESSAGE_HANDLED
	elseif id > 70 and id < 79 then
      close_custompopup_menu(id) -- in case the popup is open, can only happen on DS
		self.current_item = id - 70
		self:UnequipItem()
		return Menu.MESSAGE_HANDLED
	end
	
	return Menu.MESSAGE_NOT_HANDLED
end

-- return an instance of InvFitout
return ExportSingleInstance("InvFitout")