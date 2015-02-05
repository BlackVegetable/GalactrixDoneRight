
class "InvPlans" (Menu)


function InvPlans:__init()
	super()
	
	self:Initialize("Assets\\Screens\\InvPlans.xml")
end

function InvPlans:OnOpen()
	LOG("Mem = " .. gcinfo())
	LOG("InvPlans OnOpen()")
	self:PlatformVars()
	self.current_item = nil
	self.planList = { }
	self.selectedWidget = 0
	self.planNameWidth = 295
	
	self.lastTime = GetGameTime()



	for i=1,SCREENS.InventoryFrame.hero:NumAttributes("plans") do
		table.insert(self.planList, SCREENS.InventoryFrame.hero:GetAttributeAt("plans", i))
	end

	-- next and prev buttons on DS, scrollbar on the rest
   if #self.planList <= self.maxListValue then
		self:deactivate_widget("butt_next")
		self:deactivate_widget("scroll_items")
   else
		self:activate_widget("butt_next")
		if IsGamepadActive() then
			self:set_scrollbar_range("scroll_items", 0, math.max(0, #self.planList - 1))
		else
			self:set_scrollbar_range("scroll_items", 0, #self.planList-self.maxListValue)
		end
   end
	self:hide_widget("butt_prev")
	self:set_scrollbar_value("scroll_items", 0)

	self.planList = _G.GLOBAL_FUNCTIONS.TableSort(self.planList, _G.GLOBAL_FUNCTIONS.Plans.sortByDifficulty)
	--table.sort(self.planList, sortByDifficulty)
	self:deactivate_widget("butt_craft")
	self:UpdateList(1)
	
	for i=1, #self.planList do
		LOG(string.format("Plan %d = %s (%s)", i, self.planList[i], translate_text(string.format("[%s_NAME]", self.planList[i]))))
	end
	
	for i=1,self.maxListValue do
		self:activate_widget(string.format("item%d_frame", i))
		self:activate_widget(string.format("item%d_gem_bg", i))
		self:hide_widget(string.format("item%d_light", i))
	end
	
	self:HideCargo()

	if IsGamepadActive() then
		if #self.planList > 0 then
			self.selectedWidget = 1
			self:activate_widget("item1_light")
			self:ShowCargo(self.planList[1])
		else
			self:hide_widget("icon_gp_y")
			self:hide_widget("str_gp_y")
		end
		self.showInfo = false
	else
		self:hide_widget("icon_gp_y")
		self:hide_widget("str_gp_y")
	end
	
	LOG("Final purge")
	purge_garbage()
	LOG("InvPlans OnOpen() end")
	return Menu.OnOpen(self)
end

function InvPlans:OnClose()
	self.selectedWidget = 0
	self.showInfo = false
	close_custompopup_menu()
	LOG("Mem = " .. gcinfo())
	return Menu.MESSAGE_HANDLED
end

function InvPlans:Open(callback)
	self.callback = callback
	return Menu.Open(self)
end

function InvPlans:ShowCargo(item)
	LOG(string.format("ShowCargo %s (%s)",item, translate_text(string.format("[%s_NAME]", item))))
	
	self.currCargo = _G.GLOBAL_FUNCTIONS.CraftingCargoCost.GetCraftingCost(item)
	
	local screenID = 1
	for i,v in pairs(self.currCargo) do
		if v > 0 then			
			self:set_image(string.format("cargo%d",screenID),string.format("img_cargo%d",i))
			local text_widget = string.format("cargo%d_req",screenID)
			self:set_text_raw(text_widget,tostring(v))
			self:activate_widget(string.format("cargo%d",screenID))	
			self:activate_widget(string.format("cargo%d_req",screenID))
			
			if _G.Hero:GetAttributeAt("cargo",i) >= v then
				self:set_font(text_widget,"font_info_green")
			else
				self:set_font(text_widget,"font_info_red")
			end
				
			
			screenID = screenID + 1
		end		
	end
   
   if screenID > 1 then
      self:HideTitle()
   end
	
	for i=9, screenID, -1 do -- hard coded 9 coz there's 9 cargo icons
		self:hide_widget(string.format("cargo%d",i))
		self:hide_widget(string.format("cargo%d_req",i))
	end
end

function InvPlans:HideCargo()
	for i = 1,9 do -- there's 9 cargo types for plans
      self:hide_widget(string.format("cargo%d",i))
      self:hide_widget(string.format("cargo%d_req",i))
   end
   self:activate_widget("str_heading")
end

function InvPlans:UpdateList(topID)
	self.top_list_val = topID
	local maxDisplayed = math.min(#self.planList - topID + 1, self.maxListValue)
	
	for i=1, maxDisplayed do
		self:ActivateItem(i)
	end
	
	if maxDisplayed < self.maxListValue then
		for i=maxDisplayed + 1, self.maxListValue do
			self:HideItem(i)
		end
	end
	
	for i=topID, topID+maxDisplayed-1 do
		local itemID = self.planList[i]
		local id = i-topID+1
		_G.GLOBAL_FUNCTIONS.Plans.UpdatePlanData(self,itemID,id)
      
		--[[
		if string.char(string.byte(item)) == "S" then
			
			local myName = translate_text(string.format("[%s_NAME]", item))
			myName = fit_text_to("font_info_white", myName , self.planNameWidth)
			
            self:set_text_raw(string.format("item%d_name", id), myName)
            self:set_image(string.format("icon_item%d", id), string.format("img_%s_50",item)) -- for DS
            self:set_font(string.format("item%d_name", id), "font_info_gold")
			if SHIPS[item].weapons_rating == 0 then
				self:hide_widget(string.format("item%d_weap_val", id))
				self:hide_widget(string.format("item%d_weap_bg", id))
			else
				self:activate_widget(string.format("item%d_weap_val", id))
				self:activate_widget(string.format("item%d_weap_bg", id))
				self:set_text_raw(string.format("item%d_weap_val", id), tostring(SHIPS[item].weapons_rating))
			end

			if SHIPS[item].engine_rating == 0 then
				self:hide_widget(string.format("item%d_eng_val", id))
				self:hide_widget(string.format("item%d_eng_bg", id))
			else
				self:activate_widget(string.format("item%d_eng_val", id))
				self:activate_widget(string.format("item%d_eng_bg", id))
				self:set_text_raw(string.format("item%d_eng_val", id), tostring(SHIPS[item].engine_rating))
			end
			
			if SHIPS[item].cpu_rating == 0 then
				self:hide_widget(string.format("item%d_cpu_val", id))
				self:hide_widget(string.format("item%d_cpu_bg", id))
			else
				self:activate_widget(string.format("item%d_cpu_val", id))
				self:activate_widget(string.format("item%d_cpu_bg", id))
				self:set_text_raw(string.format("item%d_cpu_val", id), tostring(SHIPS[item].cpu_rating))
			end
		else
			
			local myName = translate_text(string.format("[%s_NAME]", item))
			myName = fit_text_to("font_info_white", myName , self.planNameWidth)
			
   		    self:set_text_raw(string.format("item%d_name", id), myName)
            self:set_image(string.format("icon_item%d", id), string.format("%s_L", ITEMS[item].icon)) -- for DS
			self:set_font(string.format("item%d_name", id), "font_info_white")
			
			if ITEMS[item].weapon_requirement == 0 then
				self:hide_widget(string.format("item%d_weap_val", id))
				self:hide_widget(string.format("item%d_weap_bg", id))
			else
				self:activate_widget(string.format("item%d_weap_val", id))
				self:activate_widget(string.format("item%d_weap_bg", id))
				self:set_text_raw(string.format("item%d_weap_val", id), tostring(ITEMS[item].weapon_requirement))
			end
			
			if ITEMS[item].engine_requirement == 0 then
				self:hide_widget(string.format("item%d_eng_val", id))
				self:hide_widget(string.format("item%d_eng_bg", id))
			else
				self:activate_widget(string.format("item%d_eng_val", id))
				self:activate_widget(string.format("item%d_eng_bg", id))
				self:set_text_raw(string.format("item%d_eng_val", id), tostring(ITEMS[item].engine_requirement))
			end

			if ITEMS[item].cpu_requirement == 0 then
				self:hide_widget(string.format("item%d_cpu_val", id))
				self:hide_widget(string.format("item%d_cpu_bg", id))
			else
				self:activate_widget(string.format("item%d_cpu_val", id))
				self:activate_widget(string.format("item%d_cpu_bg", id))
				self:set_text_raw(string.format("item%d_cpu_val", id), tostring(ITEMS[item].cpu_requirement))
			end
		end
		
		for k=1,4 do
			self:hide_widget(string.format("item%d_gem_%d", id, k))
		end
		
		for k=1,_G.GLOBAL_FUNCTIONS.GetCraftingDifficulty(item) do
			if string.char(string.byte(item)) == "S" then
				self:activate_widget(string.format("item%d_gem_%d", id, k))
				self:set_image(string.format("item%d_gem_%d", id, k), "img_craft_yellow")
			else
				self:activate_widget(string.format("item%d_gem_%d", id, k))
				self:set_image(string.format("item%d_gem_%d", id, k), "img_craft_white")
			end
		end
	
		if itemID == self.current_item then
			self:activate_widget(string.format("item%d_light", id))
		else
			self:hide_widget(string.format("item%d_light", id))
		end
		--]]	
	end
	purge_garbage()
end

function InvPlans:OnButton(id, x, y)
	if id == 99 then
		self:Close()
   elseif id == 95 then -- << button on DS
      self:UpdateList(self.top_list_val - self.maxListValue)
		if self.top_list_val - self.maxListValue < 0 then
			self:hide_widget("butt_prev")
		end
		self:activate_widget("butt_next")
		PlaySound("snd_mapmenuclick")
		  ClearAutoLoadTables()
		  collectgarbage()	  		
		
   elseif id == 96 then -- >> button on DS
      self:UpdateList(self.top_list_val + self.maxListValue)
		if self.top_list_val + self.maxListValue > #self.planList then
			self:hide_widget("butt_next")
		end
		self:activate_widget("butt_prev")
		PlaySound("snd_mapmenuclick")
		
		  ClearAutoLoadTables()
		  collectgarbage()	  		
	elseif id >10 and id < 19 then
      id = id - 10
      self:OnMouseEnter(id, x, y)
   end

	return Menu.MESSAGE_HANDLED
end

function InvPlans:OnMouseLeftButton(id, x, y, up)
	if not up then
      PlaySound("snd_mapmenuclick")
	end

	return Menu.MESSAGE_HANDLED
end

function InvPlans:OnMouseLeave(id, x, y)
	close_custompopup_menu(id)
	self:HideCargo()
   return Menu.MESSAGE_HANDLED
end

function InvPlans:OnMouseEnter(id, x, y)
	-- debug - includes a manual check for a deactivated widget
	if self.top_list_val + id - 1 <= #self.planList then
		self:ShowPopupInfo(id, x, y)
		local item = self.planList[self.top_list_val + id - 1]
		self:ShowCargo(item)
	end
	
	return Menu.MESSAGE_HANDLED
end

function InvPlans:OnGamepadButton(user, button, value)
	if button == _G.BUTTON_Y and value == 1 and #self.planList > 0 then
		PlaySound("snd_buttclick")
		if self.showInfo then
			close_custompopup_menu()
		else
			self:ShowPopupInfo(self.selectedWidget)
		end
		
		self.showInfo = not self.showInfo
	end
	
	return Menu.MESSAGE_HANDLED
end

function InvPlans:ShowPopupInfo(id, x, y)
	if not x then
		x = self:get_widget_x(string.format("item%d_frame", id))
	end

	if not y then
		y = self:get_widget_y(string.format("item%d_frame", id))
	end

	local item = self.planList[self.top_list_val + id - 1]
	if string.char(string.byte(item)) == "S" then
		_G.GLOBAL_FUNCTIONS.ShipPopup(item, x+231, y+228+((id-1)*35))
	else
		_G.GLOBAL_FUNCTIONS.ItemPopup(item, x+231, y+228+((id-1)*35), "InvPlans", id)
	end
	
end

function InvPlans:OnGamepadDPad(user, dpad, x, y)
	LOG(string.format("InvPlans: On GamepadDPad(user:%d, dpad:%d, x:%d, y:%d)", user, dpad, x, y))
	if self.selectedWidget == 0 or #self.planList == 0  then
		-- no plans (both of the above should be true)
		return Menu.MESSAGE_HANDLED
	end

	if (x ~= 0 and y ~= 0) then
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

	LOG(string.format("top_list_val: %d, selectedWidget: %d, #plans: %d", self.top_list_val, self.selectedWidget, #self.planList))
	LOG("move_amount = "..move_amount)
	
	if move_amount ~= 0 then
		local selectedPlanID = self.top_list_val + self.selectedWidget - 1
		LOG("selectedPlanID = " .. selectedPlanID)
		if move_amount > 0 then
			self:hide_widget(string.format("item%d_light", self.selectedWidget))
			-- move down
			LOG("Moving down...")
			if selectedPlanID + move_amount > #self.planList then
				-- can't move that far, cap how far to move
				move_amount = #self.planList - selectedPlanID
				LOG("move_amount capped at "..move_amount)
			end

			if self.selectedWidget + move_amount > self.maxListValue then
				-- move by the amount that the new plan is beyond the max displayed currently
				self:UpdateList(self.top_list_val + ((self.selectedWidget + move_amount) - self.maxListValue) ) -- parentheses for readability
				self.selectedWidget = self.maxListValue
				LOG(string.format("Scrolling List, new top_list_val = %d. New selectedWidget = %d.", self.top_list_val, self.selectedWidget))

			else
				-- don't need to scroll
				self.selectedWidget = self.selectedWidget + move_amount
				LOG(string.format("No scrolling needed. New selectedWidget = %d.", self.selectedWidget))
			end

--			if (1 - self.top_list_val + self.selectedWidget) >= self.maxListValue and (self.top_list_val + 2) < #self.planList then
--				self:UpdateList(self.top_list_val + move_amount)
--			end
			
		else
			self:hide_widget(string.format("item%d_light", self.selectedWidget))
			-- move up
			LOG("Moving Up...")
			if selectedPlanID + move_amount < 1 then
				-- can't move that far, cap how far to move
				move_amount = - self.top_list_val + 1
				LOG("move_amount capped at "..move_amount)
			end
		
			if self.selectedWidget + move_amount < 1 then
				-- move by the amount that the new plan is beyond the start of the currently displayed list
				self:UpdateList(self.top_list_val + ((self.selectedWidget + move_amount) - 1) ) -- parentheses for readability
				self.selectedWidget = 1
				LOG(string.format("Scrolling List, new top_list_val = %d. New selectedWidget = %d.", self.top_list_val, self.selectedWidget))

			else
				-- don't need to scroll
				self.selectedWidget = self.selectedWidget + move_amount
				LOG(string.format("No scrolling needed. New selectedWidget = %d.", self.selectedWidget))
			end

			--[[
			if self.selectedWidget - 1 + move_amount <= 0 then
				move_amount = math.max(move_amount, -1*(self.selectedWidget - 1))
			end
			self:hide_widget(string.format("item%d_light", oldWidget))
			self.selectedWidget = self.selectedWidget + move_amount
			if 1 - self.top_list_val + self.selectedWidget <= 2 then
				self:UpdateList(math.max(1, self.selectedWidget-2))
			end
			]]
		end

		self:activate_widget(string.format("item%d_light", self.selectedWidget))
		
		if self.showInfo then
			close_custompopup_menu()
			self:ShowPopupInfo(self.selectedWidget)
		end
		self:HideCargo()
		self:ShowCargo(self.planList[self.top_list_val + self.selectedWidget - 1])
		self:set_scrollbar_value("scroll_items", self.top_list_val + self.selectedWidget - 2)
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvPlans:OnGamepadJoystick(user, dpad, x, y)	
	if self.lastTime < GetGameTime() - 250 then
		if y >= 100 then
			self:OnGamepadDPad(user, 0, 0, 1)
			self.lastTime = GetGameTime()
			return Menu.MESSAGE_HANDLED

		elseif y <= -100 then
			self:OnGamepadDPad(user, 0, 0, -1)
			self.lastTime = GetGameTime()
			return Menu.MESSAGE_HANDLED

		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end



function InvPlans:OnScrollbar(id, value)

	PlaySound("snd_click")
	
	self:UpdateList(value+1)
	
	return Menu.MESSAGE_HANDLED
end



function InvPlans:PlatformVars()
   self.maxListValue = 9
   self.planNameWidth = 295
end

function InvPlans:HideTitle()
   -- nothing on PC, title shouldn't get hidden as cargo req'd icons are in a different location
end

function InvPlans:ActivateItem(i)
   self:set_alpha(string.format("item%d_frame", i), 1.0)
   self:set_alpha(string.format("item%d_gem_bg", i), 1.0)
   self:activate_widget(string.format("item%d_pad", i))
   self:activate_widget(string.format("item%d_name", i))
   self:activate_widget(string.format("item%d_type", i))
   --self:activate_widget(string.format("item%d_light", i))
   
   self:activate_widget(string.format("item%d_weap_bg", i))
   self:activate_widget(string.format("item%d_eng_bg", i))
   self:activate_widget(string.format("item%d_cpu_bg", i))
   self:activate_widget(string.format("item%d_weap_val", i))
   self:activate_widget(string.format("item%d_eng_val", i))
   self:activate_widget(string.format("item%d_cpu_val", i))
   
   self:activate_widget(string.format("item%d_gem_1", i))
   self:activate_widget(string.format("item%d_gem_2", i))
   self:activate_widget(string.format("item%d_gem_3", i))
   self:activate_widget(string.format("item%d_gem_4", i))
end

function InvPlans:HideItem(i)
   self:set_alpha(string.format("item%d_frame", i), 0.5)
   self:set_alpha(string.format("item%d_gem_bg", i), 0.5)
   self:deactivate_widget(string.format("item%d_pad", i))
   self:hide_widget(string.format("item%d_name", i))
   self:hide_widget(string.format("item%d_type", i))
   --self:hide_widget(string.format("item%d_light", i))
   
   self:hide_widget(string.format("item%d_weap_bg", i))
   self:hide_widget(string.format("item%d_eng_bg", i))
   self:hide_widget(string.format("item%d_cpu_bg", i))
   self:hide_widget(string.format("item%d_weap_val", i))
   self:hide_widget(string.format("item%d_eng_val", i))
   self:hide_widget(string.format("item%d_cpu_val", i))

   self:hide_widget(string.format("item%d_gem_1", i))
   self:hide_widget(string.format("item%d_gem_2", i))
   self:hide_widget(string.format("item%d_gem_3", i))
   self:hide_widget(string.format("item%d_gem_4", i))
end


return ExportSingleInstance("InvPlans")