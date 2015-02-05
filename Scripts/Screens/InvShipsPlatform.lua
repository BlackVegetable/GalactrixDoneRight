

function InvShips:OnMouseEnter(id, x, y)
	LOG("InvShips:OnMouseEnter()")
	if id <= SCREENS.InventoryFrame.hero:NumAttributes("ship_list") then
		_G.GLOBAL_FUNCTIONS.ShipPopup(SCREENS.InventoryFrame.hero:GetAttributeAt("ship_list", id):GetAttribute("ship"), x, y)
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvShips:UpdateShipInfo(shipID)
end
