
function ShopMenu:ActivateWidgets(shopID)	
	self:activate_widget(string.format("item%d_type",shopID))
--		self:activate_widget(string.format("item%d_frame",shopID))
--		self:activate_widget(string.format("item%d_cost_frame",shopID))
		self:set_alpha(string.format("item%d_frame",shopID), 1.0)
		self:set_alpha(string.format("item%d_cost_frame",shopID),1.0)
		self:activate_widget(string.format("item%d_name",shopID))
		self:activate_widget(string.format("item%d_weap_bg",shopID))
		self:activate_widget(string.format("item%d_eng_bg",shopID))
		self:activate_widget(string.format("item%d_cpu_bg",shopID))
		self:activate_widget(string.format("item%d_weap_val",shopID))
		self:activate_widget(string.format("item%d_eng_val",shopID))
		self:activate_widget(string.format("item%d_cpu_val",shopID))
		self:activate_widget(string.format("item%d_cost",shopID))
		self:activate_widget(string.format("item%d_pad",shopID))		
	
end



function ShopMenu:HideWidgets(shopID)	
	self:hide_widget(string.format("item%d_type",shopID))
--		self:hide_widget(string.format("item%d_frame",shopID))
--		self:hide_widget(string.format("item%d_cost_frame",shopID))
		self:set_alpha(string.format("item%d_frame",shopID), 0.5)
		self:set_alpha(string.format("item%d_cost_frame",shopID), 0.5)
		self:hide_widget(string.format("item%d_name",shopID))
		self:hide_widget(string.format("item%d_weap_bg",shopID))
		self:hide_widget(string.format("item%d_eng_bg",shopID))
		self:hide_widget(string.format("item%d_cpu_bg",shopID))
		self:hide_widget(string.format("item%d_weap_val",shopID))
		self:hide_widget(string.format("item%d_eng_val",shopID))
		self:hide_widget(string.format("item%d_cpu_val",shopID))
		self:hide_widget(string.format("item%d_cost",shopID))
		self:deactivate_widget(string.format("item%d_pad",shopID))		
	
end

function ShopMenu:OnMouseLeave(id, x, y)
	LOG("OnMouseLeave " .. id)
	close_custompopup_menu(id)
	return Menu.OnMouseLeave(self, id, x, y)
end

function ShopMenu:UpdatePadData(i, id, selling, ship)
	self:ActivateWidgets(i)
	if selling then
		local itemEquipped = false
		for k=1, _G.Hero:NumAttributes("ship_list") do
			for l=1, _G.Hero:GetAttributeAt("ship_list", k):NumAttributes("items") do
				if _G.Hero:GetAttributeAt("ship_list", k):GetAttributeAt("items", l) == id then
					itemEquipped = true
				end
			end
		end
		if itemEquipped then
			self:set_font(string.format("item%d_name", i), "font_info_red")
			self:set_font(string.format("item%d_cost", i), "font_info_red")
		else
			self:set_font(string.format("item%d_name", i), "font_info_white")
			self:set_font(string.format("item%d_cost", i), "font_info_white")
		end
	else
		self:set_font(string.format("item%d_name", i), "font_info_white")
		self:set_font(string.format("item%d_cost", i), "font_info_white")
	end
	
	local energyData = {}
	local cost
	
	if ship then
		self:set_image(string.format("item%d_type", i), "img_cpu_icon")
		self:set_font(string.format("item%d_name", i), "font_info_gold")
		self:set_font(string.format("item%d_cost", i), "font_info_gold")
		energyData.weap = SHIPS[id].weapons_rating
		energyData.eng  = SHIPS[id].engine_rating
		energyData.cpu  = SHIPS[id].cpu_rating
		
		cost = self:GetCost(id, selling, true) --math.floor(SHIPS[id].cost - (SHIPS[id].cost*(1-self.costMultiplier)))
		self:set_text_raw(string.format("item%d_cost", i), substitute(translate_text("[N_CREDITS]"), tonumber(cost)))
	else
		self:set_image(string.format("item%d_type", i), "img_weap_icon")
		self:set_text(string.format("item%d_name", i), string.format("[%s_NAME]", id))
		
		energyData.weap = ITEMS[id].weapon_requirement
		energyData.eng = ITEMS[id].engine_requirement
		energyData.cpu = ITEMS[id].cpu_requirement
		
		cost = self:GetCost(id, selling, false) --math.floor(ITEMS[id].cost - (ITEMS[id].cost*(1-self.costMultiplier)))
		
		self:set_text_raw(string.format("item%d_cost", i), substitute(translate_text("[N_CREDITS]"), tostring(cost)))
	end

	local max_width = self:get_widget_w(string.format("item%d_name", i))
	local name = fit_text_to("font_info_white", translate_text(string.format("[%s_NAME]", id)), max_width) 
	self:set_text(string.format("item%d_name", i), name)
	
	if cost > _G.Hero:GetAttribute("credits") and not selling then
		self:set_font(string.format("item%d_name", i), "font_info_gray")
		self:set_font(string.format("item%d_cost", i), "font_info_gray")
		self:set_image(string.format("item%d_weap_bg", i), "img_weapsquare_unlit")
		self:set_image(string.format("item%d_eng_bg", i), "img_engsquare_unlit")
		self:set_image(string.format("item%d_cpu_bg", i), "img_cpusquare_unlit")
	else
		self:set_image(string.format("item%d_weap_bg", i), "img_weapsquare_lit")
		self:set_image(string.format("item%d_eng_bg", i), "img_engsquare_lit")
		self:set_image(string.format("item%d_cpu_bg", i), "img_cpusquare_lit")
	end
	
	if energyData.weap == 0 then
		self:hide_widget(string.format("item%d_weap_val", i))
		self:hide_widget(string.format("item%d_weap_bg",  i))
	else
		self:activate_widget(string.format("item%d_weap_val", i))
		self:activate_widget(string.format("item%d_weap_bg",  i))
		self:set_text_raw(string.format("item%d_weap_val", i), tostring(energyData.weap))
	end
	if energyData.eng == 0 then
		self:hide_widget(string.format("item%d_eng_val", i))
		self:hide_widget(string.format("item%d_eng_bg",  i))	
	else
		self:activate_widget(string.format("item%d_eng_val", i))
		self:activate_widget(string.format("item%d_eng_bg",  i))
		self:set_text_raw(string.format("item%d_eng_val", i), tostring(energyData.eng))
	end
	if energyData.cpu == 0 then
		self:hide_widget(string.format("item%d_cpu_val", i))
		self:hide_widget(string.format("item%d_cpu_bg",  i))
	else
		self:activate_widget(string.format("item%d_cpu_val", i))
		self:activate_widget(string.format("item%d_cpu_bg",  i))
		self:set_text_raw(string.format("item%d_cpu_val", i), tostring(energyData.cpu))
	end
end

function ShopMenu:EnableBuySellButton()
   -- No Buy/Sell button on PC
end

function ShopMenu:DisableBuySellButton()
   -- No Buy/Sell button on PC
end

function ShopMenu:SetBuySellButton(buy)
   -- No Buy/Sell button on PC
end

function ShopMenu:ItemSelected(id)
	if self.buying then
		if string.char(string.byte(self.buyTable[id+self.first_list_val])) == "S" then
			self:BuyShip(self.buyTable[id+self.first_list_val], id + self.first_list_val)
		else
			self:BuyItem(self.buyTable[id+self.first_list_val], id + self.first_list_val)
		end
	else
		if string.char(string.byte(self.sellTable[id + self.first_list_val])) == "S" then
			self:SellShip(self.sellTable[id + self.first_list_val], id + self.first_list_val)
		else
			self:SellItem(self.sellTable[id + self.first_list_val], id + self.first_list_val)
		end
	end  
end

function ShopMenu:ItemDeselected()
   -- You don't actually select itmes on PC etc so this does nothing
end
