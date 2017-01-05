use_safeglobals()


-- declare our menu
class "RumorIntroMenu" (Menu);

function RumorIntroMenu:__init()
	super()
	
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\RumorIntroMenu.xml")

end


function RumorIntroMenu:OnOpen()
    -- Pause the world
	 add_text_file("RumorText.xml")
    SCREENS.SolarSystemMenu.state = _G.STATE_MENU
    
	self:set_text_raw("str_heading", translate_text("[RUMOR_HEADING]"))
	self:set_text_raw("str_message", translate_text("[RUMOR_INSTRUCTIONS]"))
	self:set_text_raw("str_turns", substitute(translate_text("[TURNS_X]"), tostring(self.cost)))
	self:activate_widget("butt_cancel")
	self:activate_widget("butt_continue")
	self:hide_widget("butt_middlecontinue")
	
	self:SetStats()
		
	return Menu.OnOpen(self)
end

function RumorIntroMenu:Open(callback, rumor, cost)
   assert(callback)
   assert(rumor)
   LOG("Rumor = " .. tostring(rumor))
   self.rumor = rumor
	self.cost = cost
	self.callback = callback
	
	return Menu.Open(self)
end

function RumorIntroMenu:SetStats()
end

function RumorIntroMenu:OnButton(buttonId, clickX, clickY)
	if buttonId == 1 then
		local function transition()
			self.callback(true)
			self:Close()
		end
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "GameMenu", "RumorIntroMenu")
	elseif buttonId == 0 then
		local function transition()
			self.callback(false)
			--self:Close()
		end
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, nil, "RumorIntroMenu")
    end
	
	return Menu.OnButton(self, buttonId, clickX, clickY)
end

function RumorIntroMenu:OnClose()
	self.rumor = nil
	self.cost = nil
	self.callback = nil
	
	return Menu.MESSAGE_HANDLED
end

-- return an instance of CombatResultsMenu
return ExportSingleInstance("RumorIntroMenu")
