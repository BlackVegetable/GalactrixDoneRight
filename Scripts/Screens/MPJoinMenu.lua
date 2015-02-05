-- declare menu
class "MPJoinMenu" (Menu);

function MPJoinMenu:__init()
	super()
	
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\MPJoinMenu.xml")
end


function MPJoinMenu:OnOpen()
	LOG("MPJoinMenu opened");
		
	self:gray_widget("butt_join")
	
	return Menu.OnOpen(self)
end

function MPJoinMenu:OnButton(buttonId, clickX, clickY)
	       
    if (buttonId == 0) then
        -- Done
        self:Close()
    end
    
    return Menu.OnButton(self, buttonId, clickX, clickY)
end

function MPJoinMenu:OnAnimClose(data)
	SCREENS.MultiplayerMenu:Open()
end

-- return an instance of MPJoinMenu
return ExportSingleInstance("MPJoinMenu")