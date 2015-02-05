use_safeglobals()

-- declare our menu
class "RumorResultsMenu" (Menu);

function RumorResultsMenu:__init()
	super()
	
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\RumorResultsMenu.xml")
end


function RumorResultsMenu:OnOpen()
	LOG("RumorResultsMenu opened")
    
	SCREENS.GameMenu:HideRumorWidgets()
	
	_G.GLOBAL_FUNCTIONS.Pause.Close(false, false)
	--close_yesno_menu(false,false)
	
	if self.victory then
		LOG(" - victory yes")
		self:Victory()
	else
		LOG(" - victory no")
		self:Defeat()
	end

	return Menu.OnOpen(self)
end

function RumorResultsMenu:Open(victory, callback, rumorID, reward)
	assert(callback)
	assert(rumorID)
	
	LOG("RumorResultsMenu Open")
	self.victory = victory
	self.callback = callback
	self.rumorID = rumorID
	self.reward = reward
    
	return Menu.Open(self)
end

function RumorResultsMenu:Defeat()
	self:set_text_raw("str_heading",translate_text("[DEFEAT]"))
	self:set_text_raw("str_message",translate_text("[BATTLE_DEFEAT]"))
	self:set_text_raw("str_rumor",translate_text(string.format("[RUMOR_FAILURE%d]", math.random(1,5))))
    
   self:activate_widget("butt_yes")
   self:activate_widget("butt_no")
   self:activate_widget("str_retry")
	self:hide_widget("butt_continue")
   self:hide_widget("str_intel")
   self:hide_widget("icon_intel")
	self:hide_widget("str_rumor_name")
	self:hide_widget("str_rumor_num")

	self:SetStats()
end

function RumorResultsMenu:Victory()
	self:set_text_raw("str_heading", translate_text("[RUMOR_VICTORY]"))
	self:set_text_raw("str_rumor_name", translate_text("["..self.rumorID.."_TITLE]"))
	self:set_text_raw("str_rumor", translate_text("["..self.rumorID.."_TEXT]"))
	self:set_text_raw("str_rumor_num", string.format("%s %d/%d", translate_text("[RUMOR_]"), tonumber(self.rumorID:sub(2))+1, 50))
    self:set_text_raw("str_intel", string.format("+%d", self.reward))

	self:hide_widget("butt_yes")
	self:hide_widget("butt_no")
	self:hide_widget("str_retry")
   self:activate_widget("butt_continue")
   self:activate_widget("str_intel")
   self:activate_widget("icon_intel")
	self:activate_widget("str_rumor_name")
	self:activate_widget("str_rumor_num")

    self:SetStats()
	 
	_G.Hero:SetAttribute("intel", _G.Hero:GetAttribute("intel") + self.reward) -- taken out of OnEventEndRumor in Hero so that levelup screen works properly
	local intel = _G.Hero:GetAttribute("intel")
	local oldLevel = _G.Hero:GetLevel(intel-self.reward)
	local newLevel = _G.Hero:GetLevel(intel)
	if oldLevel < newLevel then
		_G.Hero:SetAttribute("stat_points", _G.Hero:GetAttribute("stat_points") + (5*(newLevel-oldLevel)))
		SCREENS.LevelUpMenu:Open()
	end
end

function RumorResultsMenu:SetStats()
    -- There are no stats from a rumor game, at this stage
end

function RumorResultsMenu:OnButton(buttonId, clickX, clickY)
	if buttonId == 1 then
		local function transition()
		end
		self.callback()
		remove_text_file("RumorText.xml")
		self:Close()
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "SolarSystemMenu", "RumorResultsMenu")
	elseif buttonId == 0 then
		local function transition()
		end				
		self.callback(false)
		remove_text_file("RumorText.xml")
		self:Close()

		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "SolarSystemMenu", "RumorResultsMenu")
	elseif buttonId == 2 then
		local function transition()
		end	
		SCREENS.GameMenu:ShowRumorWidgets()
		self.callback(true)
		self:Close()			
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, nil, "RumorResultsMenu")
	end
	
	return Menu.OnButton(self, buttonId, clickX, clickY)
end

function RumorResultsMenu:OnClose()
	self.levelUp = nil
	self.callback = nil
   self.rumorID = nil
	self.reward = nil
	
	return Menu.OnClose(self)
end

-- return an instance of RumorResultsMenu
return ExportSingleInstance("RumorResultsMenu")
