-- declare our menu
class "MPTypeMenu" (Menu);

function MPTypeMenu:__init()
    super()
    
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\MPTypeMenu.xml")

end


function MPTypeMenu:OnOpen()
    LOG("MPTypeMenu opened");
    
	--self:gray_widget("butt_headtohead");
	--self:gray_widget("butt_systemlink");
	--self:gray_widget("butt_xboxliveunranked");
	--self:gray_widget("butt_xboxliveranked");
	--self:deactivate_widget("butt_internet");
	if IsGamepadActive() then
		MenuSystem.SetGamepadWidget(self, "butt_headtohead");
		self:deactivate_widget("butt_systemlink")
		self:deactivate_widget("butt_xboxliveunranked")
		self:deactivate_widget("butt_xboxliveranked")
	end
	return Menu.OnOpen(self)
end


function MPTypeMenu:OnButton(buttonId, clickX, clickY)
    
    if (buttonId == 21) then
       -- LAN game - open Create/Join menu
	   _G.CONNECTION_TYPE = NetworkConnectionType.TCPIPLAN
	   _G.CallScreenSequencer("MPTypeMenu", "MultiplayerMenu")
    elseif (buttonId == 22) then
       -- Internet game  -doesn't exist yet
	   _G.CONNECTION_TYPE = NetworkConnectionType.TCPIP
	   _G.CallScreenSequencer("MPTypeMenu", "MultiplayerMenu")
	  --_G.SCREENS.IPMenu:Open()
    elseif (buttonId == 23) then
		--HeadToHead
		_G.CallScreenSequencer("MPTypeMenu", "MPLocalSetup")
    elseif (buttonId == 24) then	
		--SystemLink
		--_G.CONNECTION_TYPE = NetworkConnectionType.TCPIPLAN
		--_G.CallScreenSequencer("MPTypeMenu", "MultiplayerMenu")
	elseif (buttonId == 25) then	   
       -- xBox Live unranked match. Open match type menu
	   SCREENS.MPMatchTypeMenu:Open()
	elseif (buttonId == 26) then    
	   -- xBox Live ranked match. Open match type menu
	   SCREENS.MPGameSetupMenu:Open()
	elseif (buttonId == 20) then
       -- close this menu, back to MainMenu
	   _G.CallScreenSequencer("MPTypeMenu", "MainMenu")
    end
    
    return Menu.OnButton(self, buttonId, clickX, clickY)
end


-- return an instance of MPTypeMenu
return ExportSingleInstance("MPTypeMenu")