
function MultiplayerMenu:OnOpen()	

	--remove_text_file("ItemText.xml")	
	
	--clear any currently listed games (could leave them up but they may be old entries)

	self:set_text('butt_find', '[FIND_GAMES]')	

	--clear any currently listed games (could leave them up but they may be old entries)
	self:reset_list("list_games")
	
	self.button_clicked = nil
	
	self:set_list_value("list_games", 1)
	
	if Settings:ValueExists("mp_name") then
		self:set_text("edit_mp_name",Settings:Read("mp_name",""))
	end
	
	return Menu.OnOpen(self)
end


function MultiplayerMenu:NameCheck(name)
	return _G.ValidName(name)
end

function MultiplayerMenu:SetMPUsername()
		Settings:Write("mp_name",tostring(self:GetMPUsername()))
		Settings:Save()
end


function MultiplayerMenu:GetMPUsername()

	return self:get_text("edit_mp_name")
end


function MultiplayerMenu:LoadGraphics()
	
end


function MultiplayerMenu:ShowWirelessIcons()
   -- nothing to do on PC
end


function MultiplayerMenu:HideWirelessIcons()
   -- nothing to do on PC
end
