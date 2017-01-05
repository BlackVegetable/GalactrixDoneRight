


local function quit_confirm(confirmed)
    if (confirmed) then
    	if _G.GLOBAL_FUNCTIONS.DemoMode() then
    		_G.CallScreenSequencer("MainMenu", "DemoMenu")
    	else
        	ForceExit()
    	end
    end
end


_G.DemoMsg = false

function MainMenu:OnOpenPlatform()
	

	if _G.GLOBAL_FUNCTIONS.DemoMode() and not _G.DemoMsg then
		open_message_menu("[DEMO_MSG1]", "[DEMO_MSG2]")
		_G.DemoMsg = true
	end
	
	--Move to Wii only platform file - if it ever exists
	WiiOnly(self.deactivate_widget, self, "butt_multiplayer")
	
	
end


function MainMenu:OnButton(buttonID, clickX, clickY)
	if (buttonID == self:get_widget_id("butt_singleplayer")) then
		-- Singleplayer
		
		local saves = SaveGameManager.Enumerate()
		
		if #saves > 0 then		
			_G.CallScreenSequencer("MainMenu", "SelectHeroMenu")
		else
			_G.CallScreenSequencer("MainMenu", "CreateHeroMenu")
		end
	
	elseif (buttonID == self:get_widget_id("butt_multiplayer")) then
		-- Multiplayer
		_G.CallScreenSequencer("MainMenu", "MPTypeMenu")
		
	elseif (buttonID == self:get_widget_id("butt_helpoptions")) then
		-- Help and Options
		SCREENS.HelpOptionsMenu:Open("MainMenu")
		
		--BEGIN_STRIP_DS
		local function WiiCloseMain()
			self:Close()
		end
		WiiOnly(WiiCloseMain)
		--END_STRIP_DS
		
	elseif (buttonID == self:get_widget_id("butt_quit")) then
		-- Quit
		open_yesno_menu("[QUIT]", "[QUITCONFIRM]", quit_confirm, "[YES]", "[NO]" )

	else
		return Menu.OnButton(self, buttonID, clickX, clickY)
	end

	return Menu.MESSAGE_HANDLED
end


function MainMenu:OnKey(key)
	if key == Keys.SK_ESCAPE then
        
        open_yesno_menu("[QUIT]", "[QUITCONFIRM]", quit_confirm,  "[YES]", "[NO]" )     
                
        
        return Menu.MESSAGE_HANDLED
    end
	
    return Menu.MESSAGE_NOT_HANDLED
end
