
-- declare our menu
class "CreditsMenu" (Menu);


function CreditsMenu:__init()
    super()
	add_text_file("CreditsText.xml")
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\CreditsMenu.xml")

    self.down = false
end

--[[
function test_yes_no()
    --open_message_menu("Test Menu", "lorem ipsum")

    return true
end
--]]



-- normally we'd put special widget setup code here but man is a splash screen ever basic!
function CreditsMenu:OnOpen()
    LOG("CreditsMenu opened");	

	PlaySound("music_credits")
    
    -- allow all gamepads to send events. (so we can find active player)
    Gamepad.UnfilterGamepads();


	self.rolling = false
	self.ready = false
	
    return Menu.OnOpen(self)
end


function CreditsMenu:OnClose()
    LOG("credits menu closed");
	SCREENS.CreditsMenu = nil
	self.ready = false
	
	remove_text_file("CreditsText.xml")
    return Menu.OnClose(self)
end



function CreditsMenu:OnMouseLeftButton(button, clickX, clickY, pressed)

    -- User released mouse left button. transition screens
    if (pressed == 0) then
        self:OnKey(0);
    end

    return Menu.MESSAGE_HANDLED;
end


function CreditsMenu:OnGamepadButton(user, button, pressed)

	LOG("CREDITS MENU: Button pressed: "..tostring(button).."("..tostring(pressed)..")")
	LOG("self.down = "..tostring(self.down))
    -- User released button. transition screens
    if (pressed == 0 and self.down) then
        self:OnKey(0);
        return Menu.MESSAGE_HANDLED;
    end
    
    -- user pressed button. mark it as pressed
    if (pressed) then
        self.down = true
    end

    return Menu.MESSAGE_HANDLED;
end


function CreditsMenu:OnKey(key)
	LOG("OnKey")
    -- RUmble the pad just for the hell of it
	if self.ready then
	    Gamepad.Rumble(0, 0.5, 100)
		LOG("open Main")
		--_G.CallScreenSequencer("CreditsMenu", "MainMenu", true)
		_G.CallScreenSequencer("CreditsMenu", "HelpOptionsMenu")
		--SCREENS.HelpOptionsMenu:Open()
	end
    --open_cutscene_menu("Assets\\CutScenes\\Chap1_Intro.xml", open_main)
    --open_conversation_menu("Assets\\Conversations\\Conv_Q0T0a.xml", "Zaphod Beeblebrox", "Assets\\Portraits\\Avatar2.png", "youngmale", "Space Castle", "Assets\\Conversations\\Conv_BartoniaThroneRoom.jpg", , 500, 500)
	return Menu.MESSAGE_HANDLED
end

function CreditsMenu:OnTimer(time)
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_credits")
	end
	
	return Menu.OnTimer(self, time)
end

function CreditsMenu:OnAnimOpen(data)
	LOG("Animation Open Finished")
	if data==1 then
		self.rolling = true
		self.ready = true
		self:StartAnimation("RollCredits")		
	end
end


function CreditsMenu:OnAnimRollCredits(data)

	if data==1 then
		_G.CallScreenSequencer("CreditsMenu", "HelpOptionsMenu")
	end
end

-- return an instance of Splash Menu
return ExportSingleInstance("CreditsMenu")