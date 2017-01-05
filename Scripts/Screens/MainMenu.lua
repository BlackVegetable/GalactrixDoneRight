
require "safeglobals"

-- declare our menu
class "MainMenu" (Menu);

function MainMenu:__init()
    super()
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets/Screens/MainMenu.xml")
end

-- OnOpen, OnButton and OnKey live in MainMenuPlatform

function MainMenu:OnTimer(time)
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_overture")
	end	
	
	return Menu.MESSAGE_HANDLED
end

--in case someone ever attempts to open MainMenu while passing in a parameter
function MainMenu:Open()	
	
	return Menu.Open(self)
end


function MainMenu:OnOpen()	

	
	local function SPCallback(val)
		LOG("SPCallback("..tostring(val)..")")		
	end	
		
	mp_single_player(SPCallback)	

	self:OnOpenPlatform()		

	if _G.Hero then
		_G.GLOBAL_FUNCTIONS.ClearChar.ClearHero(_G.Hero)
		_G.Hero = nil
	end
		
	if _G.GLOBAL_FUNCTIONS.DemoMode() then
		self:deactivate_widget("butt_multiplayer")		
	else
		self:activate_widget("butt_multiplayer")
	end
	
    return Menu.OnOpen(self)
end



function MainMenu:OnGainFocus()
	if _G.GLOBAL_FUNCTIONS.DemoMode() then
		self:deactivate_widget("butt_multiplayer")		
	else
		self:activate_widget("butt_multiplayer")
	end
	--return Menu.MESSAGE_HANDLED
	return Menu.OnGainFocus(self)
end	



dofile("Assets/Scripts/Screens/MainMenuPlatform.lua")


-- return an instance of Main Menu
return ExportSingleInstance("MainMenu")
