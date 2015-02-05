
class "CraftingIntroMenu" (Menu)


function CraftingIntroMenu:__init()
	super()
	
   SCREENS.SolarSystemMenu:HideWidgets()
	self:Initialize("Assets\\Screens\\CraftingIntroMenu.xml")
	

	self.max_screen_items = 9	
end

function CraftingIntroMenu:OnOpen()
	LOG("CraftingIntroMenu OnOpen()")
	--add_text_file("ItemText.xml")
	
	self.current_item = nil
	self.plansList = { } 	

	self.currCargo = {}
	
	self.lastTime = GetGameTime()

	--Get Heroes Cargo Levels	
	self.heroCargo = { }
	for i=1, _G.NUM_CARGOES do
		self.heroCargo[i]=_G.Hero:GetAttributeAt("cargo",i)
	end	
	
	-- only shows on DS
	self:set_alpha("str_info_bg", 0.4)
	-- local shipID = _G.Hero:GetAttributeAt("ship_list", _G.Hero:GetAttribute("ship_loadout")):GetAttribute("ship")
	-- self:set_image("img_ship_bg", string.format("img_%s_L", shipID))

	self:set_scrollbar_range("scroll_items", 0, _G.Hero:NumAttributes("plans")-self.max_screen_items)
	self:set_scrollbar_value("scroll_items", 0)
	

	for i=1,_G.Hero:NumAttributes("plans") do
		table.insert(self.plansList, _G.Hero:GetAttributeAt("plans", i))
	end

	self.plansList = _G.GLOBAL_FUNCTIONS.TableSort(self.plansList, _G.GLOBAL_FUNCTIONS.Plans.sortByDifficulty)
		
	self:DeselectItems()
   --self:deactivate_widget("butt_craft")
	self:UpdateList(1)

	--self:hide_widget("cargo_req_info")
	--[[
	self:hide_widget("icon_weap_components")
	self:hide_widget("icon_eng_components")
	self:hide_widget("icon_cpu_components")
	self:hide_widget("str_weap_components")
	self:hide_widget("str_eng_components")
	self:hide_widget("str_cpu_components")
	self:hide_widget("str_craft_desc")
	self:hide_widget("icon_craft_ship")
	self:hide_widget("icon_craft_item")
	self:hide_widget("str_craft_stat1")
	self:hide_widget("str_craft_stat2")
	self:hide_widget("str_craft_stat3")
	self:hide_widget("str_craft_stat4")
	self:hide_widget("str_craft_stat5")
	self:hide_widget("str_craft_stat6")
	self:hide_widget("str_craft_stat7")
	self:hide_widget("str_craft_stat1_val")
	self:hide_widget("str_craft_stat2_val")
	self:hide_widget("str_craft_stat3_val")
	self:hide_widget("str_craft_stat4_val")
	self:hide_widget("str_craft_stat5_val")
	self:hide_widget("str_craft_stat6_val")
	self:hide_widget("str_craft_stat7_val")
	self:hide_widget("str_illegal_craft")
	
	for i=1,10 do
		self:hide_widget(string.format("cargo%d", i))
		self:hide_widget(string.format("cargo%d_req", i))
	end
   ]]--
	
	for i=1,self.max_screen_items do
		self:activate_widget(string.format("item%d_frame", i))
		self:activate_widget(string.format("item%d_gem_bg", i))
	end
	

	if IsGamepadActive() then
		self.selectedIndex = 1
		self:activate_widget("item1_light")
		if #self.plansList > 0 then
			self:OnMouseLeftButton(1, 0, 0, 0)
		end
	end
	return Menu.OnOpen(self)
end


function CraftingIntroMenu:OnClose()

	--close_custompopup_menu()	

	_G.UnloadAssetGroup("AssetsInventory")	
	_G.UnloadAssetGroup("AssetsItems")	
	--_G.UnloadAssetGroup("AssetsBattleGrounds")			
	
   SCREENS.SolarSystemMenu:ShowWidgets()

	self.selectedIndex = nil
	
	--[[
	self.currCargo =    nil
	self.current_item = nil
	self.plansList =    nil
	self.heroCargo =    nil
	self.plansList =    nil
	self.callback  =    nil
	]]--
	
	return Menu.OnClose(self)
end


function CraftingIntroMenu:ShowCargo(item)
	LOG(string.format("ShowCargo %s",item))
	
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
	
	for i=9, screenID, -1 do -- 9 cargo gems
		self:hide_widget(string.format("cargo%d",i))
		self:hide_widget(string.format("cargo%d_req",i))
	end
	
	
end


function CraftingIntroMenu:Open(callback)

	self.callback = callback
	SCREENS.SolarSystemMenu.state = _G.STATE_MENU
	
	return Menu.Open(self)
end

function CraftingIntroMenu:UpdateList(topID)
	self.top_list_val = topID
   
   if self.top_list_val+self.max_screen_items <= _G.Hero:NumAttributes("plans") then
      self:activate_widget("butt_next")
   else
      self:hide_widget("butt_next")
   end
   
   if self.top_list_val-self.max_screen_items >= 0 then
      self:activate_widget("butt_prev")
   else
      self:hide_widget("butt_prev")
   end
   
	local maxDisplayed = math.min(_G.Hero:NumAttributes("plans") - topID, self.max_screen_items)
	
	
	for i=1, maxDisplayed + 2  do		-- why +2 ???
		self:activate_widget(string.format("item%d_frame", i))
		self:set_alpha(string.format("item%d_gem_bg", i), 1.0)
--		self:activate_widget(string.format("item%d_frame", i))
--		self:activate_widget(string.format("item%d_gem_bg", i))
		self:activate_widget(string.format("item%d_pad", i))
		self:activate_widget(string.format("item%d_name", i))
		self:activate_widget(string.format("item%d_type", i))
		self:activate_widget(string.format("item%d_gem_1", i))
		self:activate_widget(string.format("item%d_gem_2", i))
		self:activate_widget(string.format("item%d_gem_3", i))
		self:activate_widget(string.format("item%d_gem_4", i))
      self:activate_widget(string.format("item%d_icon", i))
      self:activate_widget(string.format("item%d_icon_bg", i))
      self:activate_widget(string.format("item%d_bar", i))
		
	end
	
	if maxDisplayed < self.max_screen_items then
		for i=maxDisplayed + 2, self.max_screen_items do
--			self:hide_widget(string.format("item%d_frame", i))
--			self:hide_widget(string.format("item%d_gem_bg", i))
			self:set_alpha(string.format("item%d_frame", i), 0.5)
			self:set_alpha(string.format("item%d_gem_bg", i), 0.5)
			self:deactivate_widget(string.format("item%d_pad", i))
			self:hide_widget(string.format("item%d_weap_bg", i))
			self:hide_widget(string.format("item%d_eng_bg", i))
			self:hide_widget(string.format("item%d_cpu_bg", i))
			self:hide_widget(string.format("item%d_weap_val", i))
			self:hide_widget(string.format("item%d_eng_val", i))
			self:hide_widget(string.format("item%d_cpu_val", i))
			self:hide_widget(string.format("item%d_gem_1" ,i))
			self:hide_widget(string.format("item%d_gem_2", i))
			self:hide_widget(string.format("item%d_gem_3", i))
			self:hide_widget(string.format("item%d_gem_4", i))
			
			self:hide_widget(string.format("item%d_name", i))
			self:hide_widget(string.format("item%d_type", i))
			self:hide_widget(string.format("item%d_light", i))
			self:hide_widget(string.format("item%d_icon", i))
			self:hide_widget(string.format("item%d_icon_bg", i))
			self:hide_widget(string.format("item%d_bar", i))
		end
	end
	
	for i=topID, topID+maxDisplayed do
		self:UpdatePadData(i, i - topID+1)
		--[[local item = self.plansList[i]
		local id = i-topID+1
		
		
		
		if string.char(string.byte(item)) == "S" then
			self:set_text(string.format("item%d_name", id), string.format("[%s_NAME]", item))
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
			self:set_text(string.format("item%d_name", id), string.format("[%s_NAME]", item))
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
--			self:set_image(string.format("item%d_gem_%d", id, k), "img_craft_gray")
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
		
		self:set_progress(string.format("item%d_bar", id), _G.GLOBAL_FUNCTIONS.GetCraftingDifficulty(item)*25)
		
		if item == self.current_item then
			self:activate_widget(string.format("item%d_light", id))
		else
			self:hide_widget(string.format("item%d_light", id))
		end
		]]--
	end	
end

function CraftingIntroMenu:GetCraftingReqs(itemID)
	local weap = ITEMS[itemID].weapon_requirement
	local eng  = ITEMS[itemID].engine_requirement
	local cpu  = ITEMS[itemID].cpu_requirement
	if ITEMS[itemID].rarity == 10 then
		weap = weap * 2
		eng  = eng  * 2
		cpu  = cpu  * 2
	end
	
	return weap,eng,cpu
end


function CraftingIntroMenu:UpdatePadData(i, id)
	local itemID = self.plansList[i]
	_G.GLOBAL_FUNCTIONS.Plans.UpdatePlanData(self,itemID,id)
	
	--[[
	
	local myName = translate_text(string.format("[%s_NAME]", itemID))
	local myWidth = self:get_widget_w(string.format("item%d_name", id))
	local function adjust_name()
		myName = fit_text_to("font_info_white", myName, myWidth)
	end
	_G.XBoxOnly(adjust_name)
	
	--Display Crafting Requirements
	local weap,eng,cpu = self:GetCraftingReqs(itemID)	
	if weap == 0 then
		self:hide_widget(string.format("item%d_weap_val", id))
		self:hide_widget(string.format("item%d_weap_bg",  id))
	else
		self:activate_widget(string.format("item%d_weap_val", id))
		self:activate_widget(string.format("item%d_weap_bg",  id))
		self:set_text_raw(string.format("item%d_weap_val", id), tostring(weap))
	end
	if eng == 0 then
		self:hide_widget(string.format("item%d_eng_val", id))
		self:hide_widget(string.format("item%d_eng_bg",  id))
	else
		self:activate_widget(string.format("item%d_eng_val", id))
		self:activate_widget(string.format("item%d_eng_bg",  id))
		self:set_text_raw(string.format("item%d_eng_val", id), tostring(eng))
	end
	if cpu == 0 then
		self:hide_widget(string.format("item%d_cpu_val", id))
		self:hide_widget(string.format("item%d_cpu_bg",  id))
	else
		self:activate_widget(string.format("item%d_cpu_val", id))
		self:activate_widget(string.format("item%d_cpu_bg",  id))
		self:set_text_raw(string.format("item%d_cpu_val", id), tostring(cpu))
	end	
	
	--Set Name/font color
	if string.char(string.byte(itemID)) == "S" then
		self:set_text(string.format("item%d_name", id), myName)
		self:set_font(string.format("item%d_name", id), "font_info_gold")
	else--ITEM
		self:set_text(string.format("item%d_name", id), myName)
		self:set_font(string.format("item%d_name", id), "font_info_white")		
	end
	
	--Hide all difficulty indicators
	for k=1,4 do
		self:hide_widget(string.format("item%d_gem_%d", id, k))
	end
	
	--Set all Difficulty indicators
	for k=1, _G.GLOBAL_FUNCTIONS.GetCraftingDifficulty(itemID) do
		self:activate_widget(string.format("item%d_gem_%d", id, k))
		if string.char(string.byte(itemID)) == "S" then
			self:set_image(string.format("item%d_gem_%d", id, k), "img_craft_yellow")
		else
			self:set_image(string.format("item%d_gem_%d", id, k), "img_craft_white")
		end
	end
	--Highlight current item
	if itemID == self.current_item then
		self:activate_widget(string.format("item%d_light", id))
	else
		self:hide_widget(string.format("item%d_light", id))
	end
	--]]
end 


function CraftingIntroMenu:OnButton(id, x, y)
	close_custompopup_menu()
   PlaySound("snd_mapmenuclick")
	if id == 99 then
		--_G.CallScreenSequencer("CraftingIntroMenu", sourceMenu)
		self.callback(true)--closemenu
   elseif id == 95 then -- back button
      --if self.top_list_val - self.max_screen_items >=0 then
         self:UpdateList(self.top_list_val - self.max_screen_items)
         self:DeselectItems()
         -- self:deactivate_widget("butt_craft") -- forces reselection of a new item
      --end
	  
	  ClearAutoLoadTables()
	  collectgarbage()
   
   elseif id == 96 then -- forward button
      --if self.top_list_val + self.max_screen_items <= _G.Hero:NumAttributes("plans") then
         self:UpdateList(self.top_list_val+self.max_screen_items)
         self:DeselectItems()
         -- self:deactivate_widget("butt_craft") -- forces reselection of a new item
      --end
	  
	  ClearAutoLoadTables()
	  collectgarbage()	  
      
   elseif id == 7 then -- 'Begin' button
--		local item = self.currentitemplansList[self.top_list_val + id - 1]
--      LOG(string.format("item set to %s", tostring(item)))
      local function transition()
         self:Close()
         self.callback(false, self.current_item)
      end

      if self:AlreadyGotItem(self.current_item) == true then
         local function ConfirmCraft(yes)
            close_custompopup_menu()
            if yes then				
               SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "GameMenu", "CraftingIntroMenu")
            end
         end
         open_yesno_menu("[DUPE_HEADING]", "[DUPE_TEXT]", ConfirmCraft, "[YES]", "[NO]" )
      
      else
		transition()
      --	local craft_callback = self.callback
      --	local function double_callback()
      --	   craft_callback(false,self.current_item)					
      --	end
      --	open_message_menu("[INSTRUCTIONS]", "[CRAFTING_INSTR]", double_callback)
         --self.callback(true, self.current_item)
         
         -- _G.GLOBAL_FUNCTIONS.Backdrop.Open()		
         --_G.CallScreenSequencer(sourceMenu, "GameMenu", sourceMenu, player1, "B010", event)
      end
	end

	return Menu.MESSAGE_HANDLED
end
function CraftingIntroMenu:AlreadyGotItem(item)
   local gotItem = false
   LOG(string.format("item is %s", tostring(gotItem)))
	for i=1,_G.Hero:NumAttributes("items") do
		local invItem = _G.Hero:GetAttributeAt("items", i)
      LOG(string.format("testing against: %s", tostring (invItem)))
      if item == invItem then
         LOG("Match!")
         gotItem = true
      else
         LOG("No Match")
      end
	end
   
   return gotItem
end

function CraftingIntroMenu:OnMouseLeftButton(id, x, y, up)
	if not up and id ~= 0 then
		PlaySound("snd_mapmenuclick")
		return Menu.MESSAGE_HANDLED
	end
	
		
	if id == 0 then
		self:DeselectItems()
      --[[
      close_custompopup_menu()
		self:deactivate_widget("butt_craft")
      self:hide_widget("cargo_req_info")
      self:hide_widget("str_illegal_craft")
	   for i=1,10 do
   		self:hide_widget(string.format("cargo%d", i))
   		self:hide_widget(string.format("cargo%d_req", i))
   	end
      ]]
      return Menu.MESSAGE_HANDLED	
	elseif id > 80 then
		id = id - 80
      self:PopupOnButton(id, x, y)
	end
	
	self:activate_widget("butt_craft")
	local item = self.plansList[self.top_list_val + id - 1]
	for i=1,9 do
		self:hide_widget(string.format("item%d_light", i))
	end
	self:activate_widget(string.format("item%d_light", id))
   self:ShowCargo(item)
	self.current_item = item
	--LOG("Item = " .. tostring(item))
   
	if _G.GLOBAL_FUNCTIONS.CraftingCargoCost.HasRequiredCargo(_G.Hero,self.currCargo) == false then
		LOG("Craft Intro: not enough cargo")
		self:deactivate_widget("butt_craft")
		self:activate_widget("cargo_req_info")
      self:hide_widget("str_illegal_craft")
	else
		LOG("Craft Intro: Activate craft")
		self:activate_widget("butt_craft")
		self:hide_widget("cargo_req_info")
      self:hide_widget("str_illegal_craft")
	end
	
	if string.char(string.byte(item)) == "S" and _G.Hero:NumAttributes("ship_list") == 3 then
      LOG("Craft Intro: Too many ships")
		self:deactivate_widget("butt_craft")
		--self:hide_widget("cargo_req_info")
		self:activate_widget("str_illegal_craft")
	end
	
	return Menu.MESSAGE_HANDLED
end


function CraftingIntroMenu:OnMouseEnter(id, x, y)
	-- debug - includes a manual check for a deactivated widget
	if id == 0 then	
		close_custompopup_menu()
		return Menu.MESSAGE_HANDLED	
	elseif id >80 then
		id = id - 80		
	end
   
	if self.top_list_val + id - 1 <= _G.Hero:NumAttributes("plans") then
		self:PopupOnMouseOver(id, x, y)
	end
--[[
   if self.top_list_val + id - 1 <= _G.Hero:NumAttributes("plans") then
		local item = self.plansList[self.top_list_val + id - 1]
		if string.char(string.byte(item)) == "S" then
			_G.GLOBAL_FUNCTIONS.ShipPopup(item, x+231, y+228+((id-1)*35))
		else
			_G.GLOBAL_FUNCTIONS.ItemPopup(item, x+231, y+228+((id-1)*35), "CraftingIntroMenu", id)
		end
	end
]]
	--_G.GLOBAL_FUNCTIONS.CraftingCargoCost.CargoCostPopup(_G.Hero,self.currCargo[costID])
	
	
	return Menu.MESSAGE_HANDLED
end

function CraftingIntroMenu:OnScrollbar(id, value)
	if not up and ((value) > 0) and ((value+1) < (_G.Hero:NumAttributes("plans") - self.max_screen_items )) then
		PlaySound("snd_butthover")
	end
	
	self:UpdateList(value+1)
	return Menu.MESSAGE_HANDLED
end

function CraftingIntroMenu:DeselectItems()
		close_custompopup_menu()
		self:deactivate_widget("butt_craft")
      self:hide_widget("cargo_req_info")
      self:hide_widget("str_illegal_craft")
	   for i=1,10 do
   		self:hide_widget(string.format("cargo%d", i))
   		self:hide_widget(string.format("cargo%d_req", i))
   	end
end

dofile("Assets/Scripts/Screens/CraftingIntroMenuPlatform.lua")

return ExportSingleInstance("CraftingIntroMenu")