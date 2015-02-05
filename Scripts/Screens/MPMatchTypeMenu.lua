-- declare our menu
class "MPMatchTypeMenu" (Menu);

function MPMatchTypeMenu:__init()
    super()
    
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\MPMatchTypeMenu.xml")

end


function MPMatchTypeMenu:OnOpen()
    LOG("MPMatchTypeMenu opened");
    
    self:gray_widget("butt_matchquick");
    self:gray_widget("butt_matchcustom");
	self:gray_widget("butt_matchcreate");
    
    return Menu.OnOpen(self)
end


function MPMatchTypeMenu:OnButton(buttonId, clickX, clickY)
    
    if (buttonId == 1) then
       -- find quick match
    elseif (buttonId == 2) then
       -- find custom match
	   SCREENS.MultiplayerMenu:Open()
	elseif (buttonId == 3) then	   
       -- create match
	elseif (buttonId == 0) then
       -- close this menu
	   self:Close()
    end
    
    return Menu.OnButton(self, buttonId, clickX, clickY)
end

-- return an instance of MPMatchTypeMenu
return ExportSingleInstance("MPMatchTypeMenu")