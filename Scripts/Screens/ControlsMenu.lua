use_safeglobals()

-- declare our menu
class "ControlsMenu" (Menu);

function ControlsMenu:__init()
	super()
	
	self:Initialize("Assets\\Screens\\ControlsMenu.xml")
end



function ControlsMenu:OnOpen()
	LOG("[ControlsMenu] opened")

	self.mode = 1
	return Menu.OnOpen(self)
end

function ControlsMenu:OnClose()
	LOG("[ControlsMenu] closed")

	return Menu.OnClose(self)
end

function ControlsMenu:OnButton(buttonId, clickX, clickY)

	if buttonId == 1 then
		CallScreenSequencer("ControlsMenu", "HelpOptionsMenu")
		return Menu.MESSAGE_HANDLED
	elseif buttonId == 11 then
		-- Only called on the DS
		self.mode = self.mode + 1
		if self.mode > 3 then
			self.mode = 1
		end
		
		if self.mode == 1 then
			self:set_text("str_c_1_h","[WORLD_MAP]")
			self:set_text("str_c_1_1","[WORLD_MAP_SHORTCUT]")
		elseif self.mode == 2 then
			self:set_text("str_c_1_h","[BATTLE_MAP]")
			self:set_text("str_c_1_1","[BATTLE_MAP_SHORTCUT]")
		elseif self.mode == 3 then
			self:set_text("str_c_1_h","[PUZZLE_GAME]")
			self:set_text("str_c_1_1","[PUZZLE_GAME_SHORTCUT]")
		end
		
		return Menu.MESSAGE_HANDLED
	end 

	return Menu.MESSAGE_NOT_HANDLED
end

function ControlsMenu:OnKey(key)
	
	return Menu.OnKey(self, key)
end

function ControlsMenu:OnTimer(time)
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_overture")
	end	
	
	return Menu.MESSAGE_HANDLED
end

function ControlsMenu:OnGamepadJoystick(user, stick, x, y)
	return Menu.MESSAGE_HANDLED
end

function ControlsMenu:OnGamepadDPad(user, dpad, x, y)
	return Menu.MESSAGE_HANDLED
end

-- return an instance of CreateHeroMenu
return ExportSingleInstance("ControlsMenu")
