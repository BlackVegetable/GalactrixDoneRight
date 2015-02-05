
use_safeglobals()

class "InvEquipment" (Menu)

dofile("Assets/Scripts/Screens/InvEquipmentPlatform.lua")

local top_list_val

function InvEquipment:__init()
	super()
	self:Initialize("Assets\\Screens\\InvEquipment.xml")
end

function InvEquipment:OnOpen()

	--self:reset_list("list_items")

	self.lastTime = GetGameTime()

	self.itemList = { }
	for i=1,SCREENS.InventoryFrame.hero:NumAttributes("items") do
		table.insert(self.itemList, SCREENS.InventoryFrame.hero:GetAttributeAt("items",i))
	end
	
	local function stringSort(a,b)
		local name1, name2
		name1 = translate_text(string.format("[%s_NAME]", a))
		name2 = translate_text(string.format("[%s_NAME]", b))
		if name1 < name2 then
			return true
		else
			return false
		end
	end
	
	self.itemList = _G.GLOBAL_FUNCTIONS.TableSort(self.itemList, stringSort)
	--table.sort(self.itemList, stringSort)
	LOG("Number of items held by player: "..#self.itemList)
	
	self:PlatformVar()
    local energy = self:GetEnergyLeft()
	self:set_text("str_weap_left_val", tostring(energy.weaps))
	self:set_text("str_eng_left_val",  tostring(energy.eng))
	self:set_text("str_cpu_left_val",  tostring(energy.cpu))
	
	local max_sbar = #self.itemList-self.maxListValue
	if max_sbar <= 1 then
		max_sbar = 2
		self:deactivate_widget("scroll_items")
	else
		self:activate_widget("scroll_items")
	end
	self:set_scrollbar_range("scroll_items", 1, #self.itemList-self.maxListValue+1)
	
	self.selectedWidget = nil
	self:deactivate_widget("butt_equip")
	self:deactivate_widget("butt_equip")
	self:hide_widget("str_equip")
	for i=1, self.maxListValue do
		self:hide_widget(string.format("item%d_light", i))
	end
   
    self.itemEquippable ={ } --will be filled and updated in Update list with true/false values - only stores the items currently shown ie 1-8
	self:UpdateList(1)
   
	--[[ -- DS ONLY
	self:hide_widget("butt_prev")
	if #self.itemList > 8 then
		self:activate_widget("butt_next")
	end
	]]
   
	--[[
	if IsGamepadActive() then
		self.selectedWidget = 1
		self:activate_widget("item1_light")
		--if #self.itemList ~= 0 and self:get_font("item1_name") == "font_info_white" then
		if #self.itemList ~= 0 and self.itemEquippable == true then
			self:activate_widget("butt_equip") -- first item exists and can be equipped
		end
	end
	]]--
	local function InitialSelect()
   	if #self.itemList ~= 0 then
   		self.selectedWidget = 1
   		self:activate_widget("item1_light")
   		if self.itemEquippable[1] then
   			self:activate_widget("butt_equip")
			self:activate_widget("str_equip")
   		end
   	end
   end

   _G.XBoxOnly(InitialSelect)
			
	self:set_scrollbar_value("scroll_items",1)
	_G.ShowTutorialFirstTime(19, _G.Hero)
	return Menu.OnOpen(self)
end


function InvEquipment:OnClose()
	self.lastTime = GetGameTime()
	self:UnloadGraphics()
	self.selectedWidget = nil
	self.top_list_val = nil
	self.itemList = nil
	
	SCREENS.InvFitout:UpdateScrollBars()
	
	return Menu.MESSAGE_HANDLED
end

function InvEquipment:OnGamepadDPad(user, dpad, x, y)
	-- in this function 'ID' means the position of the referred to item within self.itemList
	if not self.selectedWidget then
		return Menu.MESSAGE_NOT_HANDLED
	end
	if x == 0 and y == 0 then
		-- somehow this got called even though there's no x or y movement
		return Menu.MESSAGE_HANDLED
	end

	LOG(string.format("OnGamepadDPad(user:%d, dpad:%d, x:%d, y:%d)", user, dpad, x, y))
	
	if x ~= 0 and y ~= 0 then
		-- ignore diagonal input
		return Menu.MESSAGE_HANDLED
	end
	
	local move_amount = 0
	if y > 0 then
		move_amount = - 1
	elseif y < 0 then
		move_amount = 1
	elseif x > 0 then
		move_amount = self.maxListValue
	elseif x < 0 then
		move_amount = -self.maxListValue
	end
	LOG(string.format("move_amount is %d", move_amount))

	local oldItemID = self.top_list_val + self.selectedWidget - 1
	local selectedItemID = oldItemID
	--LOG(string.format("selectedWidget is %d", self.selectedWidget))
	--LOG(string.format("selectedItemID (before changes) is %d", selectedItemID))
	if move_amount ~= 0 then
		if move_amount > 0 then
			-- move down
			LOG("Moving down...")
			if selectedItemID + move_amount >= _G.Hero:NumAttributes("items") then
				-- if trying to scroll beyond the end of the list of items, stop at the end
				move_amount = _G.Hero:NumAttributes("items") - selectedItemID
			end	
			
			self:hide_widget(string.format("item%d_light", self.selectedWidget))
			--- Move the selected widget
			self.selectedWidget = self.selectedWidget + move_amount
			selectedItemID = self.top_list_val + self.selectedWidget - 1 -- recalculate the ID of the selected item
			
			-- Now check if it's beyond the bottom of the current page
			if self.selectedWidget > self.maxListValue then 
				-- if so, scroll the list by the difference between the newly selected item's ID and the ID of the item in the lowest displayed position
				local maxListItemID = self.top_list_val + self.maxListValue - 1
				local newTop = self.top_list_val + (selectedItemID - maxListItemID)
				self.selectedWidget = self.maxListValue
				self:UpdateList(newTop)
				selectedItemID = self.top_list_val + self.selectedWidget - 1 -- recalculate the ID of the selected item again (coz selectedWidget changed)
			end
			--LOG(string.format("selectedItemID is now %d", selectedItemID))

		else
			-- move up
			LOG("Moving up...")
			if selectedItemID + move_amount < 1 then
				move_amount = 1 - selectedItemID
				LOG(string.format("move_amount capped at %d", move_amount))
			end
			LOG(string.format("hiding item%d_light", self.selectedWidget))
			self:hide_widget(string.format("item%d_light", self.selectedWidget))
			self.selectedWidget = self.selectedWidget + move_amount
			if self.selectedWidget < 1 then
				local newTop = self.top_list_val + self.selectedWidget - 1
				LOG(string.format("Scrolling list: newTop (%d) = self.top_list_val (%d) - self.selectedWidget (%d) - 1", newTop, self.top_list_val, self.selectedWidget))
				self:UpdateList(newTop)
				self.selectedWidget = 1
			end
			selectedItemID = self.top_list_val + self.selectedWidget - 1 -- recalculate the ID of the selected item again (coz selectedWidget changed)
			--LOG(string.format("selectedItemID is now %d", selectedItemID))
		end

		--LOG(string.format("activating item%d_light", self.selectedWidget))
		self:activate_widget(string.format("item%d_light", self.selectedWidget))

		-- check if we need to show or close the info popup
		if selectedItemID ~= oldItemID then
			PlaySound("snd_mapmenuclick")

			if self.showInfo then
				close_custompopup_menu(oldItemID)
				_G.GLOBAL_FUNCTIONS.ItemPopup(self.itemList[selectedItemID], 225, 450, "InvEquipment", selectedItemID)	
			end
		end			

		--if self:get_font(string.format("item%d_name", 1- self.top_list_val + self.selectedWidget)) ~= "font_info_white" then
		local actualItemID = selectedItemID - self.top_list_val + 1
		if self.itemEquippable[actualItemID] ~= true then
			self:deactivate_widget("butt_equip")
			self:hide_widget("str_equip")
		else
			self:activate_widget("butt_equip")
			self:activate_widget("str_equip")
		end
		self:set_scrollbar_value("scroll_items", selectedItemID)
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvEquipment:OnGamepadJoystick(user, joystick, x_dir, y_dir)
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

-- returns a table containing cpu, engine, and weaps keys mapped to the amount
-- of energy remaining on each stat for the current ship
function InvEquipment:GetEnergyLeft()
	local loadout = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"))
	local shipID = loadout:GetAttribute("ship")
	local energyLeft = {cpu = SHIPS[shipID].cpu_rating, eng=SHIPS[shipID].engine_rating, weaps=SHIPS[shipID].weapons_rating }

   
	--LOG("Current Item: " .. tostring(SCREENS.InvFitout.current_item))
   for i=1,loadout:NumAttributes("items") do
		--LOG("i = " .. i)
		local item = loadout:GetAttributeAt("items", i)
		if not (i == SCREENS.InvFitout.current_item) then
			--LOG("Processed item")
			energyLeft.cpu = energyLeft.cpu - ITEMS[item].cpu_requirement
			energyLeft.eng = energyLeft.eng - ITEMS[item].engine_requirement
			energyLeft.weaps = energyLeft.weaps - ITEMS[item].weapon_requirement
		end
   end 
	
   return energyLeft
end

-- updates the items displayed in the list
function InvEquipment:UpdateList(topID)
	self.top_list_val = topID
	LOG(string.format("Updating List with topID=%d", topID))
	
	if #self.itemList == 0 then
		self:hide_widget("str_equip")
		self:hide_widget("butt_equip")
		self:hide_widget("str_info")
		self:hide_widget("icon_moreinfo")
	else
		self:activate_widget("str_info")
		self:activate_widget("icon_moreinfo")
	end
	
	local equippedTable = {}
	local loadout = SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", SCREENS.InventoryFrame.hero:GetAttribute("ship_loadout"))
	
	for i=1,loadout:NumAttributes("items") do
		equippedTable[i] = loadout:GetAttributeAt("items", i)
	end

	local energyAvailable = self:GetEnergyLeft()
	local maxDisplayed = #self.itemList - topID + 1
	if maxDisplayed > self.maxListValue then
		maxDisplayed = self.maxListValue
	end

	for i=1,maxDisplayed do
		self:activate_widget(string.format("item%d_type", i))
--		self:activate_widget(string.format("item%d_frame", i))
		self:set_alpha(string.format("item%d_frame", i), 1.0)
		self:activate_widget(string.format("item%d_name", i))
		self:activate_widget(string.format("item%d_weap_bg", i))
		self:activate_widget(string.format("item%d_weap_val", i))
		self:activate_widget(string.format("item%d_eng_bg", i))
		self:activate_widget(string.format("item%d_eng_val", i))
		self:activate_widget(string.format("item%d_cpu_bg", i))
		self:activate_widget(string.format("item%d_cpu_val", i))
		self:activate_widget(string.format("item%d_pad", i))
		-- DS ONLY
		--self:activate_widget(string.format("item%d_icon", i))
		--self:activate_widget(string.format("item%d_icon_bg", i))
	end
	
	if maxDisplayed < self.maxListValue then
		for i=maxDisplayed + 1, self.maxListValue do
			self:hide_widget(string.format("item%d_type", i))
--			self:hide_widget(string.format("item%d_frame", i))
			self:set_alpha(string.format("item%d_frame", i), 0.5)
			self:hide_widget(string.format("item%d_light", i))
			self:hide_widget(string.format("item%d_name", i))
			self:hide_widget(string.format("item%d_weap_bg", i))
			self:hide_widget(string.format("item%d_weap_val", i))
			self:hide_widget(string.format("item%d_eng_bg", i))
			self:hide_widget(string.format("item%d_eng_val", i))
			self:hide_widget(string.format("item%d_cpu_bg", i))
			self:hide_widget(string.format("item%d_cpu_val", i))
			self:deactivate_widget(string.format("item%d_pad", i))
			-- DS ONLY
			--self:hide_widget(string.format("item%d_icon", i))
			--self:hide_widget(string.format("item%d_icon_bg", i))
		end
	end
	
	for i=topID,maxDisplayed+topID-1 do
		local item = self.itemList[i]
		local equippable = 0
		local id = i-topID+1
		local widgetName = string.format("item%d_name", id)
		local itemName = string.format("[%s_NAME]", item)
		itemName = fit_text_to("font_info_white", itemName, self:get_widget_w(widgetName))
		self:set_text(widgetName,itemName)
		local energyNeeds = { weaps=ITEMS[item].weapon_requirement,eng=ITEMS[item].engine_requirement,cpu=ITEMS[item].cpu_requirement }
		
		if energyNeeds.weaps > energyNeeds.eng then
			-- weaps > engine
			if energyNeeds.weaps > energyNeeds.cpu then
				-- weaps > cpu and engine
				self:set_image(string.format("item%d_type", id), "img_weap_icon")
			else
				-- cpu > weaps > engine
				self:set_image(string.format("item%d_type", id), "img_cpu_icon")
			end
		else
			-- weaps < engine
			if energyNeeds.cpu > energyNeeds.eng then
				-- cpu > engine > weaps
				self:set_image(string.format("item%d_type", id), "img_cpu_icon")
			else
				-- engine > cpu > weaps
				self:set_image(string.format("item%d_type", id), "img_eng_icon")
			end
		end
		      
		-- check weapon requirements
		if energyNeeds.weaps == 0 then
			self:hide_widget(string.format("item%d_weap_val", id))
			self:hide_widget(string.format("item%d_weap_bg", id))
		else
			self:activate_widget(string.format("item%d_weap_val", id))
			self:activate_widget(string.format("item%d_weap_bg", id))
			self:set_text(string.format("item%d_weap_val", id), tostring(ITEMS[item].weapon_requirement))
			if energyNeeds.weaps > energyAvailable.weaps then
				equippable = 1
			end
		end
		
		-- check engine requirements
		if energyNeeds.eng == 0 then
			self:hide_widget(string.format("item%d_eng_val", id))
			self:hide_widget(string.format("item%d_eng_bg", id))
		else
			self:activate_widget(string.format("item%d_eng_val", id))
			self:activate_widget(string.format("item%d_eng_bg", id))
			self:set_text(string.format("item%d_eng_val", id), tostring(ITEMS[item].engine_requirement))
			if energyNeeds.eng > energyAvailable.eng then
				equippable = 1
			end
		end	

		-- check cpu requirements
		if energyNeeds.cpu == 0 then
			self:hide_widget(string.format("item%d_cpu_val", id))
			self:hide_widget(string.format("item%d_cpu_bg", id))
		else
			self:activate_widget(string.format("item%d_cpu_val", id))
			self:activate_widget(string.format("item%d_cpu_bg", id))
			self:set_text(string.format("item%d_cpu_val", id), tostring(ITEMS[item].cpu_requirement))
			if energyNeeds.cpu > energyAvailable.cpu then
				equippable = 1
			end
		end

		-- check if this item is equipped on the current ship
		LOG(string.format("Checking item %d (%s) at widget %d", i, tostring(self.itemList[i]), id))
		if self:CheckForMatchingItem(self.itemList[i], equippedTable) == true then
			equippable = 2
			LOG(string.format("item %d is already equipped!", i))
		end		

      --self:set_image(string.format("item%d_icon", id), string.format("%s_L", ITEMS[item].icon)) -- DS ONLY
      self.itemEquippable[id] = true
		if equippable ~= 0 then
			if equippable == 1 then -- can't meet requirements
				self:set_font(string.format("item%d_name", id), "font_info_gray")
				self:set_font(string.format("item%d_weap_val", id), "font_info_red")
				self:set_font(string.format("item%d_eng_val", id), "font_info_red")
				self:set_font(string.format("item%d_cpu_val", id), "font_info_red")
			elseif equippable == 2 then -- already equipped
				self:set_font(string.format("item%d_name", id), "font_info_gray")
				self:set_font(string.format("item%d_weap_val", id), "font_info_gray")
				self:set_font(string.format("item%d_eng_val", id), "font_info_gray")
				self:set_font(string.format("item%d_cpu_val", id), "font_info_gray")
			end
			self.itemEquippable[id] = false
			-- self:deactivate_widget(string.format("item%d_icon", id)) -- DS ONLY
			self:deactivate_widget(string.format("item%d_pad", id))
			self:set_image(string.format("item%d_weap_bg", id), "img_weapsquare_unlit")
			--self:set_font(string.format("item%d_weap_val", id), "font_info_gray")	
			self:set_image(string.format("item%d_cpu_bg", id), "img_cpusquare_unlit")
			--self:set_font(string.format("item%d_cpu_val", id), "font_info_gray")
			self:set_image(string.format("item%d_eng_bg", id), "img_engsquare_unlit")
			--self:set_font(string.format("item%d_eng_val", id), "font_info_gray")					
		else
			--self:set_alpha(string.format("item%d_icon", id), 1.0) -- DS ONLY
			self:set_font(string.format("item%d_name", id), "font_info_white")
			self:activate_widget(string.format("item%d_pad", id))
			self:set_image(string.format("item%d_cpu_bg", id), "img_cpusquare_lit")
			self:set_font(string.format("item%d_cpu_val", id), "font_info_white")
			self:set_image(string.format("item%d_eng_bg", id), "img_engsquare_lit")
			self:set_font(string.format("item%d_eng_val", id), "font_info_white")
			self:set_image(string.format("item%d_weap_bg", id), "img_weapsquare_lit")
			self:set_font(string.format("item%d_weap_val", id), "font_info_white")
		end
	end
end

-- simply iterates through a set of items and returns true if the specified item
-- is present in the loadout
function InvEquipment:CheckForMatchingItem(item, equipTable)
	for i=1,8 do
		LOG(string.format("Checking item %s against slot %d: %s", tostring(item), i, tostring(equipTable[i])))
		if equipTable[i] == item then
			equipTable[i] = nil
			return true
		end
	end
	return false
end

function InvEquipment:OnScrollbar(id, value)
	PlaySound("snd_click")
	
	self:UpdateList(value)
	
	return Menu.MESSAGE_HANDLED
end

function InvEquipment:OnGamepadButton(user, button, value)
	
	if value == 1 then
		
		if  button == _G.BUTTON_Y then
			PlaySound("snd_buttclick")
			self.showInfo = not self.showInfo
			if self.showInfo and self.selectedWidget <= (#self.itemList - self.top_list_val + 1) then
					_G.GLOBAL_FUNCTIONS.ItemPopup(self.itemList[self.selectedWidget + self.top_list_val - 1], 225, 450, "InvEquipment", self.selectedWidget)	
			else
				close_custompopup_menu()
			end
		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end

return ExportSingleInstance("InvEquipment")
