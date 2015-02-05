

function CargoTrader:ShowSelected()
	
end



function CargoTrader:UpdateInfoFields()
	local maximumCargo = 0
	local currentCargo = 0
	for i=1,_G.Hero:NumAttributes("ship_list") do
		local shipID = _G.Hero:GetAttributeAt("ship_list", i):GetAttribute("ship")
		maximumCargo = maximumCargo + _G.SHIPS[shipID].cargo_capacity
	end	
	
	for i=1, _G.NUM_CARGOES do
		currentCargo = currentCargo + _G.Hero:GetAttributeAt("cargo", i)
	end

	local percent = math.floor((currentCargo / maximumCargo) * 100)
	self:set_text_raw("str_info_amount", substitute(translate_text("[_FULL]"), percent))
	self:set_text_raw("str_info_capacity", string.format("%s: %d", translate_text("[CAPACITY]"), maximumCargo))
	self:set_text_raw("str_info_credits", substitute(translate_text("[N_CREDITS]"), _G.Hero:GetAttribute("credits")))
	
	
end



function CargoTrader:OnMouseEnter(id, x, y)
	local value = self.cargo_values[id]
	if value then
		_G.GLOBAL_FUNCTIONS.CargoPopup(id, 600, 400, value)
	end
	return Menu.MESSAGE_HANDLED
end

function CargoTrader:OnMouseLeave(id, x, y)
	close_custompopup_menu()
	return Menu.MESSAGE_HANDLED
end