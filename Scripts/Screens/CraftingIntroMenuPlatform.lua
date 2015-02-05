

function CraftingIntroMenu:OnMouseLeave(id, x, y)
	close_custompopup_menu(id)
	return Menu.MESSAGE_HANDLED
end

--[[
function CraftingIntroMenu:UpdatePadData(i, id)
	local item = self.plansList[i]
	
	if string.char(string.byte(item)) == "S" then
		self:set_text(string.format("item%d_name", id), string.format("[%s_NAME]", item))
		self:set_font(string.format("item%d_name", id), "font_info_gold")
		if SHIPS[item].weapons_rating == 0 then
			self:hide_widget(string.format("item%d_weap_val", id))
			self:hide_widget(string.format("item%d_weap_bg",  id))
		else
			self:activate_widget(string.format("item%d_weap_val", id))
			self:activate_widget(string.format("item%d_weap_bg",  id))
			self:set_text_raw(string.format("item%d_weap_val", id), tostring(SHIPS[item].weapons_rating))
		end
		if SHIPS[item].engine_rating == 0 then
			self:hide_widget(string.format("item%d_eng_val", id))
			self:hide_widget(string.format("item%d_eng_bg",  id))
		else
			self:activate_widget(string.format("item%d_eng_val", id))
			self:activate_widget(string.format("item%d_eng_bg",  id))
			self:set_text_raw(string.format("item%d_eng_val", id), tostring(SHIPS[item].engine_rating))
		end
		if SHIPS[item].cpu_rating == 0 then
			self:hide_widget(string.format("item%d_cpu_val", id))
			self:hide_widget(string.format("item%d_cpu_bg",  id))
		else
			self:activate_widget(string.format("item%d_cpu_val", id))
			self:activate_widget(string.format("item%d_cpu_bg",  id))
			self:set_text_raw(string.format("item%d_cpu_val", id), tostring(SHIPS[item].cpu_rating))
		end
	else
		self:set_text(string.format("item%d_name", id), string.format("[%s_NAME]", item))
		self:set_font(string.format("item%d_name", id), "font_info_white")
		
		if ITEMS[item].weapon_requirement == 0 then
			self:hide_widget(string.format("item%d_weap_val", id))
			self:hide_widget(string.format("item%d_weap_bg",  id))
		else
			self:activate_widget(string.format("item%d_weap_val", id))
			self:activate_widget(string.format("item%d_weap_bg",  id))
			self:set_text_raw(string.format("item%d_weap_val", id), tostring(ITEMS[item].weapon_requirement))
		end
		if ITEMS[item].engine_requirement == 0 then
			self:hide_widget(string.format("item%d_eng_val", id))
			self:hide_widget(string.format("item%d_eng_bg",  id))
		else
			self:activate_widget(string.format("item%d_eng_val", id))
			self:activate_widget(string.format("item%d_eng_bg",  id))
			self:set_text_raw(string.format("item%d_eng_val", id), tostring(ITEMS[item].engine_requirement))
		end
		if ITEMS[item].cpu_requirement == 0 then
			self:hide_widget(string.format("item%d_cpu_val", id))
			self:hide_widget(string.format("item%d_cpu_bg",  id))
		else
			self:activate_widget(string.format("item%d_cpu_val", id))
			self:activate_widget(string.format("item%d_cpu_bg",  id))
			self:set_text_raw(string.format("item%d_cpu_val", id), tostring(ITEMS[item].cpu_requirement))
		end
	end
	
	for k=1,4 do
		self:hide_widget(string.format("item%d_gem_%d", id, k))
	end
	
	for k=1, _G.GLOBAL_FUNCTIONS.GetCraftingDifficulty(item) do
		self:activate_widget(string.format("item%d_gem_%d", id, k))
		if string.char(string.byte(item)) == "S" then
			self:set_image(string.format("item%d_gem_%d", id, k), "img_craft_yellow")
		else
			self:set_image(string.format("item%d_gem_%d", id, k), "img_craft_white")
		end
	end
	
	if item == self.current_item then
		self:activate_widget(string.format("item%d_light", id))
	else
		self:hide_widget(string.format("item%d_light", id))
	end
end 
--]]

--[[

function CraftingIntroMenu:OnMouseEnter(id, x, y)
	-- debug - includes a manual check for a deactivated widget
	if id == 0 then	
		close_custompopup_menu()
		return Menu.MESSAGE_HANDLED	
	elseif id >80 then
		id = id - 80		
	end
	if self.top_list_val + id - 1 <= _G.Hero:NumAttributes("plans") then
		local item = self.plansList[self.top_list_val + id - 1]
		if string.char(string.byte(item)) == "S" then
			_G.GLOBAL_FUNCTIONS.ShipPopup(item, x+231, y+228+((id-1)*35))
		else
			_G.GLOBAL_FUNCTIONS.ItemPopup(item, x+231, y+228+((id-1)*35))
		end
	end

	--_G.GLOBAL_FUNCTIONS.CraftingCargoCost.CargoCostPopup(_G.Hero,self.currCargo[costID])
	
	
	return Menu.MESSAGE_HANDLED
end
--]]

function CraftingIntroMenu:PopupOnButton(id, x, y)
end

function CraftingIntroMenu:PopupOnMouseOver(id, x, y)
   local item = self.plansList[self.top_list_val + id - 1]
   if string.char(string.byte(item)) == "S" then
      _G.GLOBAL_FUNCTIONS.ShipPopup(item, x+231, y+228+((id-1)*35))
   else
      _G.GLOBAL_FUNCTIONS.ItemPopup(item, x+231, y+228+((id-1)*35), "CraftingIntroMenu", id)
   end

end
