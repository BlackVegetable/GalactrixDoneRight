use_safeglobals()


-- declare our menu
class "HelpOptionsMenu" (Menu);

function HelpOptionsMenu:__init()
	super()
	
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\HelpAndOptionsMenu.xml")
end


--BEGIN_STRIP_DS
local function SetupRumbleOptions()
	local function RumbleValidate(value)
		if value == 1 or value == 2 then
			return true
		else
			return false
		end
		
	end
	
	local function RumbleSelect(value)
		_G.Rumble = value
		
		if value == 1 then
			Gamepad.LimitRumble(0, 0.8)
			Gamepad.LimitRumble(1, 0.8)
			Gamepad.LimitRumble(2, 0.8)
			Gamepad.LimitRumble(3, 0.8)
		else
			Gamepad.LimitRumble(0, 0.0)
			Gamepad.LimitRumble(1, 0.0)
			Gamepad.LimitRumble(2, 0.0)
			Gamepad.LimitRumble(3, 0.0)
		end
		return true
	end
	
	AddOption("rumble", RumbleValidate, RumbleSelect, { ["[ON]"] = 1, ["[OFF]"] = 2}, Settings:Read('rumble', 1))
	
end	

local function SetupWiiSoundsOptions()
	local function WiiSoundsValidate(value)
		if value == 1 or value == 2 then
			return true
		else
			return false
		end
	
	end
	
	local function WiiSoundsSelect(value)
		_G.WiiRemoteSound = value
		
		if value == 1 then
			_G.SoundFunction = 
				function (s, i, h)
					if h then
						PlayUserSound(s, i)
					else
						PlaySound(s)
					end
				end
		else
			_G.SoundFunction =
				function (s, i, h)
					PlaySound(s)
				end
		end
		return true
	end
	
	AddOption("wiisounds", WiiSoundsValidate, WiiSoundsSelect, { ["[ON]"] = 1, ["[OFF]"] = 2}, Settings:Read('wiisounds', 1))	
end
--END_STRIP_DS




function HelpOptionsMenu:Open(sourceMenu)
	LOG("HelpOptionsMenu:Open()")
	
	
	if sourceMenu then
		self.sourceMenu = sourceMenu
		LOG("HelpOptionsMenu: sourceMenu = "..sourceMenu)
	end
	
	return Menu.Open(self)
end



function HelpOptionsMenu:OnOpen()
	LOG("HelpOptionsMenu opened");
	
	PlaySound("music_overture")
	
	--BEGIN_STRIP_DS
		WiiOnly(SetupRumbleOptions)	
		WiiOnly(SetupWiiSoundsOptions)
	--END_STRIP_DS	

	--self:gray_widget("butt_howtoplay");
	--self:gray_widget("butt_controls");
	if self.sourceMenu and (self.sourceMenu == "GameMenu" or self.sourceMenu == "SolarSystemMenu" or self.sourceMenu == "MapMenu") then
		self:deactivate_widget("butt_credits")
	else
		self:activate_widget("butt_credits")
	end
	
	return Menu.OnOpen(self)
end


function HelpOptionsMenu:OnButton(buttonId, clickX, clickY)
	
	if (buttonId == 51) then
		-- How To Play
		_G.CallScreenSequencer("HelpOptionsMenu", "HowToPlayMenu")		
	elseif (buttonId == 52) then
		-- Controls
		_G.CallScreenSequencer("HelpOptionsMenu", "ControlsMenu")
	elseif (buttonId == 53) then
		local function save_settings(do_save)
			if do_save then
				if not IsProfilePresent(1) then
					open_message_menu("[PROFILE_NOT_FOUND]","[SAVE_FAILURE]",nil)
				else
					OptionsManager:Save()
				end
			end
		end
	
		-- Settings
		open_options_menu(save_settings, false)
	elseif (buttonId == 54) then
		-- Credits
		SCREENS.MainMenu:Close()
		_G.CallScreenSequencer("HelpOptionsMenu", "CreditsMenu")
	elseif (buttonId == 50) then
		-- Done
		_G.CallScreenSequencer("HelpOptionsMenu", self.sourceMenu)
	end
	
	return Menu.OnButton(self, buttonId, clickX, clickY)
end

function HelpOptionsMenu:OnTimer(time)
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_overture")
	end	
	
	return Menu.MESSAGE_HANDLED
end

-- return an instance of HelpOptionsMenu
return ExportSingleInstance("HelpOptionsMenu")
