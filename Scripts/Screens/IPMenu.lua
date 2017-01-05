-- declare our menu
class "IPMenu" (Menu);

function IPMenu:__init()
	super()
	LOG("IPMenu:Init()")
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\IPMenu.xml")
    

	
end

function IPMenu:Open(callback)
	LOG("IPMenu:Open()")
	self.callback = callback
	
	return Menu.Open(self)
end

function IPMenu:OnOpen()
	LOG("IPMenu:OnOpen")

	
	--self:unfocus_editor("edit_ip")
	self:activate_editor("edit_ip")
	

	self.SHIFT = false
	self.CAPSLOCK  = false		
	
	self:activate_editor("edit_ip")
	
	return Menu.OnOpen(self)
end


function IPMenu:OnTimer(time)
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_overture")
	end
	
	self:activate_editor("edit_ip")
	
	return Menu.MESSAGE_HANDLED
end


function IPMenu:IPCheck(ip)
	LOG("IPCheck "..tostring(ip))
	local valid = false

		
	for i,j,k,l in string.gmatch(ip, "(%d+).(%d+).(%d+).(%d+)") do
		if tonumber(i) < 256 and tonumber(j) < 256 and tonumber(k) < 256 and tonumber(l) < 256 then
			valid = true			
		end
		LOG(string.format("i=%s,j=%s,k=%s,l=%s",tostring(i),tostring(j),tostring(k),tostring(l)))
	end
	
	return valid
end


function IPMenu:OnClose()
	
	
	
	return Menu.OnClose(self)
end

function IPMenu:OnButton(buttonId, clickX, clickY)
	LOG("IPMenu:OnButton "..tostring(buttonId))
	_G.SetFadeToBlack(false)
	if (buttonId == 0) then
		-- Cancel
		self:Close()
			
		
	elseif (buttonId == 1) then
		local ip_address = self:get_text("edit_ip")
		
		if not self:IPCheck(ip_address) then
			open_message_menu("[INVALID_IP]", "[INVALID_IP_MSG]", nil)
			
			return Menu.MESSAGE_HANDLED
		end
		

		SCREENS.MultiplayerMenu.ip_address = ip_address		
		
		if self.callback then
			self.callback()
		end
		
	    self:Close()
		
		--_G.CallScreenSequencer("MPTypeMenu", "MultiplayerMenu",ip_address)
				
	
		-- Next
	
	elseif (buttonId == 11) then
			-- open the keyboard
			self:StartAnimation("open_keypad")
			return Menu.MESSAGE_HANDLED		
	
	elseif (buttonId >= 100 and buttonId < 400) then
		-- alpha buttons
		LOG("Alpha Buttons "..tostring(buttonId))
		local change = self:get_text("edit_ip")
		if string.len(change) >= 11 then
			return Menu.MESSAGE_HANDLED
		end
		subtract = 100
		
		if self.SHIFT then
			subtract = subtract+32
		end
		
		change = change .. string.format('%c', (buttonId-subtract))
		
		
		self:set_text_raw("edit_ip", change)
		
		if self.SHIFT then
			self:DoShift()
		end
				
		return Menu.MESSAGE_HANDLED
	
	elseif (buttonId == 1000) then
		-- SPACEBAR
		local change = self:get_text("edit_ip")
		if string.len(change) >= 11 then
			return Menu.MESSAGE_HANDLED
		end		
		change = change .. " "
		self:set_text_raw("edit_ip", change)
		return Menu.MESSAGE_HANDLED	
	elseif (buttonId >= 500 and buttonId < 600) then
		-- num buttons
		if(self.SHIFT == false)then
			local change = self:get_text("edit_ip")
			if string.len(change) >= 11 then
				return Menu.MESSAGE_HANDLED
			end			
			change = change .. buttonId-500
			self:set_text_raw("edit_ip", change)
		else
			local change = self:get_text("edit_ip")
			if string.len(change) >= 11 then
				return Menu.MESSAGE_HANDLED
			end			
			
			if(buttonId == 501)then
				change = change .. "!"
			elseif(buttonId == 502)then
				change = change .. "@"
			elseif(buttonId == 503)then
				change = change .. "#"
			elseif(buttonId == 504)then
				change = change .. "$"
			elseif(buttonId == 505)then
				change = change .. "%"
			elseif(buttonId == 506)then
				change = change .. "^"
			elseif(buttonId == 507)then
				change = change .. "&"
			elseif(buttonId == 508)then
				change = change .. "*"
			elseif(buttonId == 509)then
				change = change .. "("
			elseif(buttonId == 500)then
				change = change .. ")"
			end
			
			self:set_text_raw("edit_ip", change)
			self:DoShift()
		end
		return Menu.MESSAGE_HANDLED
		
	elseif (buttonId >= 700 and buttonId < 800) then
		-- symbol buttons
		if(self.SHIFT == false)then
			local change = self:get_text("edit_ip")
			if string.len(change) >= 11 then
				return Menu.MESSAGE_HANDLED
			end			
			change = change .. string.format('%c', (buttonId-700))
			self:set_text_raw("edit_ip", change)
		else
			local change = self:get_text("edit_ip")
			if string.len(change) >= 11 then
				return Menu.MESSAGE_HANDLED
			end			
						
			if(buttonId == 796)then
				change = change .. "~"
			elseif(buttonId == 745)then
				change = change .. "_"
			elseif(buttonId == 761)then
				change = change .. "+"
			elseif(buttonId == 791)then
				change = change .. "{"
			elseif(buttonId == 793)then
				change = change .. "}"
			elseif(buttonId == 792)then
				change = change .. "|"
			elseif(buttonId == 759)then
				change = change .. ":"
			elseif(buttonId == 739)then
				change = change .. "\""
			elseif(buttonId == 744)then
				change = change .. "<"
			elseif(buttonId == 746)then
				change = change .. ">"
			elseif(buttonId == 747)then
				change = change .. "?"				
			end
			
			self:set_text_raw("edit_ip", change)
			self:DoShift()			
		end
		return Menu.MESSAGE_HANDLED

				
	end		

	-- functionality buttons
	if(buttonId == 801 or buttonId == 1801)then
		--BACKSPACE - delete a letter
		local change = self:get_text("edit_ip")
		change = string.sub(change, 1, string.len(change)-1)
		self:set_text_raw("edit_ip", change)		
		return Menu.MESSAGE_HANDLED			
	end
	
	if(buttonId == 802 or buttonId == 805)then
		--ENTER - close the keypad
		self:StartAnimation("close_keypad")
		return Menu.MESSAGE_HANDLED			
	end
	
	if(buttonId == 803)then
		--SHIFT
		
		self:DoShift()
		
		return Menu.MESSAGE_HANDLED			
	end
	
	if(buttonId == 804)then
		--CAPSLOCK
		if(self.SHIFT)then
			self.CAPSLOCK = false
		else
			self.CAPSLOCK = true
		end

		self:DoShift()				
		return Menu.MESSAGE_HANDLED			
	end			
	
	if(buttonId == 999)then

		self.CAPSLOCK = false
		self.SHIFT = true
		self:DoShift()	
	
	
		if self.accented then			
			self:set_alpha("grp_keypad_accented", 0.0)
			self:deactivate_widget("grp_keypad_accented")
			self:activate_widget("grp_keypad_alpha")
			self:set_alpha("grp_keypad_alpha", 1.0)
			self.accented = false	
		else
			self:set_alpha("grp_keypad_alpha", 0.0)		
			self:deactivate_widget("grp_keypad_alpha")
			self:activate_widget("grp_keypad_accented")
			self:set_alpha("grp_keypad_accented", 1.0)			
			self.accented = true
		end
		
		return Menu.MESSAGE_HANDLED			
	end			

	return Menu.MESSAGE_HANDLED
end



function IPMenu:OnEditor(editorId, text)
    
	LOG("OnEditor() "..tostring(editorId).." "..tostring(text))
	
	self:set_text_raw("edit_ip", text)
	--self:activate_editor("edit_ip")

	return Menu.MESSAGE_HANDLED
    --return Menu.OnEditor(self, editorId,text)
end

--[[
function IPMenu:OnKey(key)
	LOG("OnKey")
	--self:activate_editor("edit_ip")
	
	return Menu.OnKey(self, key)
end
--]]

function IPMenu:DoShift()
	LOG("DoShift")
	if(self.SHIFT and self.CAPSLOCK == false)then -- turn shift off
		for letter = 1, 26 do
			local change = self:get_text("txt_a_"..letter)
			change = string.lower(change)
			self:set_text_raw("txt_a_"..letter, change)				
		end
		
		local change = self:get_text("txt_n_1")
		change = "1"
		self:set_text_raw("txt_n_1", change)
		change = self:get_text("txt_n_2")
		change = "2"
		self:set_text_raw("txt_n_2", change)
		change = self:get_text("txt_n_3")
		change = "3"
		self:set_text_raw("txt_n_3", change)
		change = self:get_text("txt_n_4")
		change = "4"
		self:set_text_raw("txt_n_4", change)
		change = self:get_text("txt_n_5")
		change = "5"
		self:set_text_raw("txt_n_5", change)
		change = self:get_text("txt_n_6")
		change = "6"
		self:set_text_raw("txt_n_6", change)
		change = self:get_text("txt_n_7")
		change = "7"
		self:set_text_raw("txt_n_7", change)
		change = self:get_text("txt_n_8")
		change = "8"
		self:set_text_raw("txt_n_8", change)
		change = self:get_text("txt_n_9")
		change = "9"
		self:set_text_raw("txt_n_9", change)
		change = self:get_text("txt_n_0")
		change = "0"
		self:set_text_raw("txt_n_0", change)
		
		local change = self:get_text("txt_s_1")
		change = "`"
		self:set_text_raw("txt_s_1", change)
		change = self:get_text("txt_s_2")
		change = "-"
		self:set_text_raw("txt_s_2", change)
		change = self:get_text("txt_s_3")
		change = "="
		self:set_text_raw("txt_s_3", change)
		change = self:get_text("txt_s_4")
		change = "["
		self:set_text_raw("txt_s_4", change)
		change = self:get_text("txt_s_5")
		change = "]"
		self:set_text_raw("txt_s_5", change)
		change = self:get_text("txt_s_6")
		change = "\\"
		self:set_text_raw("txt_s_6", change)
		change = self:get_text("txt_s_7")
		change = ";"
		self:set_text_raw("txt_s_7", change)
		change = self:get_text("txt_s_8")
		change = "'"
		self:set_text_raw("txt_s_8", change)
		change = self:get_text("txt_s_9")
		change = ","
		self:set_text_raw("txt_s_9", change)
		change = self:get_text("txt_s_10")
		change = "."
		self:set_text_raw("txt_s_10", change)
		change = self:get_text("txt_s_11")
		change = "/"
		self:set_text_raw("txt_s_11", change)		

		self.SHIFT = false								
		
	else	--turn shift on
		for letter = 1, 26 do
			change = self:get_text("txt_a_"..letter)
			change = string.upper(change)
			self:set_text_raw("txt_a_"..letter, change)
		end		
		
		local change = self:get_text("txt_n_1")
		change = "!"
		self:set_text_raw("txt_n_1", change)
		change = self:get_text("txt_n_2")
		change = "@"
		self:set_text_raw("txt_n_2", change)
		change = self:get_text("txt_n_3")
		change = "#"
		self:set_text_raw("txt_n_3", change)
		change = self:get_text("txt_n_4")
		change = "$"
		self:set_text_raw("txt_n_4", change)
		change = self:get_text("txt_n_5")
		change = "%"
		self:set_text_raw("txt_n_5", change)
		change = self:get_text("txt_n_6")
		change = "^"
		self:set_text_raw("txt_n_6", change)
		change = self:get_text("txt_n_7")
		change = "&"
		self:set_text_raw("txt_n_7", change)
		change = self:get_text("txt_n_8")
		change = "*"
		self:set_text_raw("txt_n_8", change)
		change = self:get_text("txt_n_9")
		change = "("
		self:set_text_raw("txt_n_9", change)
		change = self:get_text("txt_n_0")
		change = ")"
		self:set_text_raw("txt_n_0", change)
		
		local change = self:get_text("txt_s_1")
		change = "~"
		self:set_text_raw("txt_s_1", change)
		change = self:get_text("txt_s_2")
		change = "_"
		self:set_text_raw("txt_s_2", change)
		change = self:get_text("txt_s_3")
		change = "+"
		self:set_text_raw("txt_s_3", change)
		change = self:get_text("txt_s_4")
		change = "{"
		self:set_text_raw("txt_s_4", change)
		change = self:get_text("txt_s_5")
		change = "}"
		self:set_text_raw("txt_s_5", change)
		change = self:get_text("txt_s_6")
		change = "|"
		self:set_text_raw("txt_s_6", change)
		change = self:get_text("txt_s_7")
		change = ":"
		self:set_text_raw("txt_s_7", change)
		change = self:get_text("txt_s_8")
		change = "\""
		self:set_text_raw("txt_s_8", change)
		change = self:get_text("txt_s_9")
		change = "<"
		self:set_text_raw("txt_s_9", change)
		change = self:get_text("txt_s_10")
		change = ">"
		self:set_text_raw("txt_s_10", change)
		change = self:get_text("txt_s_11")
		change = "?"
		self:set_text_raw("txt_s_11", change)	
		
		self.SHIFT = true													
	end	
end


-- return an instance of IPMenu
return ExportSingleInstance("IPMenu")
