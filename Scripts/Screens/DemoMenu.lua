
class "DemoMenu" (Menu);


function DemoMenu:__init()
    super()
    self:Initialize("Assets/Screens/DemoMenu.xml")
end


function DemoMenu:OnOpen()
	self.canExit = false
	self.exitTime = GetGameTime() + 8000
	return Menu.OnOpen(self)
end



function DemoMenu:OnMouseLeftButton(button, clickX, clickY, pressed)
	LOG("OnMouseLeftButton")
    -- User released mouse left button. transition screens
    if (not pressed) then
        self:OnKey(0)
    end

    return Menu.MESSAGE_HANDLED
end


function DemoMenu:OnKey(key)

	if self.canExit then
		ForceExit()
	end
	return Menu.MESSAGE_HANDLED
end


function DemoMenu:OnTimer(time)
	
	if time > self.exitTime then
		self.canExit = true
	end
	
	if not Sound.IsMusicPlaying() then
	   PlaySound("music_overture")
	end	
	
	return Menu.MESSAGE_HANDLED
end

	

-- return an instance of Splash Menu
return ExportSingleInstance("DemoMenu")