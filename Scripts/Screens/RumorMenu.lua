use_safeglobals()


-- declare our menu
class "RumorMenu" (Menu);

function RumorMenu:__init()
	super()
	
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\RumorIntroMenu.xml")

end


function RumorMenu:OnOpen()
	LOG("RumorMenu opened");
	add_text_file("RumorText.xml")
	
    -- Pause the world
    SCREENS.SolarSystemMenu.state = _G.STATE_MENU
    
	self:set_text_raw("str_heading",translate_text("[RUMOR_HEADING]"))
	self:set_text_raw("str_message",translate_text("["..self.rumor.."_TITLE]"))
	self:set_text_raw("str_rumor",translate_text("["..self.rumor.."_TEXT]"))
	self:hide_widget("butt_cancel")
	self:hide_widget("butt_continue")
	self:activate_widget("butt_middlecontinue")

	self:SetStats()

	return Menu.OnOpen(self)
end

function RumorMenu:OnClose()
    -- Remove the contents of the autoload table (stop the cached rumors from building up)
    ClearAllRumors()
	
	remove_text_file("RumorText.xml")

    return Menu.OnClose(self)
end

function RumorMenu:Open(victory,rumor,callback)
    assert(rumor)
    assert(callback)
    
    LOG("RumorMenu Open")
    
	self.victory = victory
   self.rumor = rumor
	self.callback = callback
	
	return Menu.Open(self)
end

function RumorMenu:SetStats()
end

function RumorMenu:OnButton(buttonId, clickX, clickY)

	if buttonId == 1 then
		local function transition()
			self:Close()
			self.callback()
		end
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, nil, "RumorMenu")
	elseif buttonId == 0 then
		local function transition()
			self:Close()
			self.callback(false)
		end
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, nil, "RumorMenu")
	elseif buttonId == 2 then
		local function transition()
			self:Close()
			self.callback(true)	
		end	
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, nil, "RumorMenu")
	end
	
	return Menu.OnButton(self, buttonId, clickX, clickY)
end
-- return an instance of CombatResultsMenu
return ExportSingleInstance("RumorMenu")
