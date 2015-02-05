
class "SplashMenu" (Menu);


function SplashMenu:__init()
    super()
	self:LoadGraphics()
	add_text_file("MenuText.xml")
    self:Initialize("Assets/Screens/SplashMenu.xml")
end


function SplashMenu:OnOpen()
	LOG("splash screen opened");
   
	self:set_text("str_continue", "[PRESSCONT]");
	
	self:StartAnimation("blink")
	
	self:UpdateLogoHighlight(0)
	
	-- WHY are version numbers here and not a global _G.GAME_VERSION in each platforms Application.lua ?
	
	
	self:set_text_raw("str_version",_G.GAME_VERSION) --"RC.1","XB.9"
	--LOG(string.format("Game Version: %s", tostring(_G.GAME_VERSION)))
	
	
	self:OpenPlatform()
	
	

	
	local SPCallback = function()
		LOG("Set Single Player")
	end
	
	mp_single_player(SPCallback)

	return Menu.OnOpen(self)
end


function SplashMenu:OnAnimBlink(param)
	if param == 1 then
		self:StartAnimation("blink")
	end
end


function SplashMenu:OnMouseLeftButton(button, clickX, clickY, pressed)
	LOG("OnMouseLeftButton")
    -- User released mouse left button. transition screens
    if (not pressed) then
        self:OnKey(0)
    end

    return Menu.MESSAGE_HANDLED
end


function SplashMenu:OnGamepadButton(user, button, pressed)
    -- User released button. transition screens
	LOG("SplashMenu:OnGamepadButton entry")
    if pressed == 0 then
		if PlayerToUser(1) == -1 then
			if self:SetupPlayer(user) then
				return self:OnKey(0)
			end
		else
			return self:OnKey(0)
		end
    end
    
    return Menu.MESSAGE_HANDLED
end


function SplashMenu:OnKey(key)
	LOG("SplashMenu:OnKey entry")
	if PlayerToUser(1) ~= -1 then
	    -- Rumble the pad just for the hell of it
		LOG("SplashMenu:OnKey button pressed")
	    Gamepad.Rumble(0, 0.5, 100)
		_G.CallScreenSequencer("SplashMenu", "MainMenu")
	end
    
	return Menu.MESSAGE_HANDLED
end


function SplashMenu:OnTimer(time)
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_overture")
	end	
	
	return Menu.MESSAGE_HANDLED
end


function SplashMenu:OnDraw(time)
		
	self:UpdateLogoHighlight(time)
	
    return Menu.OnDraw(self, time);
end
	

dofile("Assets/Scripts/Screens/SplashMenuPlatform.lua")

-- return an instance of Splash Menu
return ExportSingleInstance("SplashMenu")