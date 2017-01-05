function InvEquipment:LoadGraphics()

end

function InvEquipment:UnloadGraphics()

end

function InvEquipment:PlatformVar()
   self.maxListValue = 10
end

function InvEquipment:OnButton(id, x, y)
	if id == 14 then
		-- equip clicked
		local item = self.itemList[self.selectedWidget + self.top_list_val - 1]
		SCREENS.InvFitout:EquipItem(item)
		--SCREENS.InvFitout:UnequipItem()
		self:Close()
	elseif id == 15 then
		-- cancel clicked
		self:Close()
	end

	return Menu.MESSAGE_HANDLED
end

function InvEquipment:OnMouseEnter(id, x, y)
	if id == 0 then
		
	elseif id <= (#self.itemList - self.top_list_val + 1) then
		_G.GLOBAL_FUNCTIONS.ItemPopup(self.itemList[id + self.top_list_val - 1], 452 + x, 187 + y + ((id-1)*34), "InvEquipment", id)	
	end
	return Menu.MESSAGE_HANDLED
end

function InvEquipment:OnMouseLeave(id, x, y)
	close_custompopup_menu(id)
	return Menu.MESSAGE_HANDLED
end

function InvEquipment:OnMouseLeftButton(id, x, y, up)
	if up == false then
		for i=1,self.maxListValue do
			self:hide_widget("item"..i.."_light")
		end
		PlaySound("snd_mapmenuclick")
		self.selectedWidget = id 
		self:activate_widget("item"..id.."_light")
		self:activate_widget("butt_equip")
	end
	
	return Menu.MESSAGE_HANDLED
end

