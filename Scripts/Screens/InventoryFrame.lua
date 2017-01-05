
use_safeglobals()

class "InventoryFrame" (Menu)

local menuOpen

function InventoryFrame:__init()
	super()
	
	self:Initialize("Assets\\Screens\\InventoryFrame.xml")
end

function InventoryFrame:Open(sourceMenu, tabID,mp,opponent,encounter_timer)
	LOG("InventoryFrame:Open()")
	self.menuOpen = tabID
	self.sourceMenu = sourceMenu
	if not self.sourceMenu then
		self.sourceMenu=1
	end
	self.opponent = nil
	self.last_click_time = GetGameTime()
	
	self.hero = _G.Hero
	self.mp = mp
	if opponent then
		LOG(tostring(SCREENS.MultiplayerGameSetup.my_player_id).." set opponent Inventory Hero "..tostring(opponent:GetAttribute("player_id")))
		self.hero = opponent
		self.opponent = true
	else
		LOG("Set My _G.Hero")
	end

	if encounter_timer then
		self.encounter_timer = encounter_timer
	end
	
	--for testing
	--self.opponent = true
	--self.mp = true

	return Menu.Open(self)
end

function InventoryFrame:OnOpen()	
	
	
	if (_G.is_open("BlockingMessageMenu")) then
		SCREENS.BlockingMessageMenu:MoveToFront()
	end

	LOG("InventoryFrame OnOpen()")	
	
	--add_text_file("ItemText.xml")
	add_text_file("CrewText.xml")
	add_text_file("FactionText.xml")
	add_text_file("QuestText.xml")
	
	if _G.is_open("SolarSystemMenu") then	
		SCREENS.SolarSystemMenu.state = _G.STATE_MENU		
		SCREENS.SolarSystemMenu:HideWidgets()
	end
	
	self:GetOverlayScreen():Open()
	
	self:activate_widget("butt_cargo")
	self:activate_widget("butt_crew")
	self:activate_widget("butt_factions")
	self:activate_widget("butt_missions")
	
	if self.mp then--IF IN MultiPlayer Mode
		if self.opponent then--If Viewing Opponents inventory
			self:deactivate_widget("butt_cargo")
			self:deactivate_widget("butt_factions")
			self:deactivate_widget("butt_missions")
		end
		self:deactivate_widget("butt_crew")--Should be disabled for opponent only as crew members aren't sent over network
		--CREW SHOULD BE CHANGED FROM OBJECTS TO AUTOLOAD TABLE DATA
	end	
	
	if not IsGamepadActive() then
		self:hide_widget("icon_gp_left")
		self:hide_widget("icon_gp_right")
	end
	
	--[[
	if self.hero:GetAttribute("male") == 1 then
		self:set_image("icon_inv1", "img_invicon_1_male")
	else
		self:set_image("icon_inv1", "img_invicon_1_female")
	end
	--]]
	self:deactivate_widget(self:GetWidgetName(self.menuOpen))
	LOG("Menuopen = "..tostring(self.menuOpen))

	Graphics.FadeFromBlack()
	
	return Menu.MESSAGE_HANDLED
end

function InventoryFrame:OnGainFocus()
	return Menu.MESSAGE_HANDLED -- intercept engine call of OnGainFocus to prevent it stealing InvHero's gp_entry
end

function InventoryFrame:SetSource(sourceMenu)
	
	self.sourceMenu = sourceMenu
end

function InventoryFrame:SetMenuToOpen(id)
	self.menuOpen = id
end

function InventoryFrame:UpdateHeroView()	
	if _G.is_open("SolarSystemMenu") then
		local dir = _G.Hero:GetView():GetDir()
		_G.Hero:SetSystemView()
		local view = _G.Hero:GetView()
		view:SetDir(dir)
		SCREENS.SolarSystemMenu:ShowWidgets()
	elseif _G.is_open("MapMenu") then
		local dir = _G.Hero:GetView():GetDir()
		_G.Hero:SetStarMapView()
		local view = _G.Hero:GetView()
		view:SetDir(dir)
	end
		
end	

function InventoryFrame:OnClose()
	LOG("InventoryFrame:OnClose()")
	
	
	if not self.opponent then
		if _G.is_open("MultiplayerGameSetup") then
			SCREENS.MultiplayerGameSetup:InventoryUpdated()
		end
	end
	
	self.menuOpen = nil
	self.mp = nil
	self.opponent = nil
	self.sourceMenu = nil
	self.hero = nil
	self.closing = false
	
	--[[ WARNING: removing files is platform specific - no need to do it on pc or xbox ]]

	
	close_custompopup_menu()
	if not _G.is_open("MultiplayerGameSetup")  then
		--remove_text_file("ItemText.xml")
	end

	Graphics.FadeFromBlack()
		
	if _G.is_open("SolarSystemMenu") then
		SCREENS.SolarSystemMenu:ShowWidgets()
		
	elseif not _G.is_open("MapMenu") then--neither open
		remove_text_file("CrewText.xml")
		remove_text_file("FactionText.xml")	
		remove_text_file("QuestText.xml")	
	end
	
	
	--purge_garbage()
	
	return Menu.MESSAGE_HANDLED
end




function InventoryFrame:OnButton(id, x, y)
	LOG(string.format("InventoryFrame:OnButton %d %d %d", id, x, y))
	purge_garbage()
	

	if self.closing then
		return Menu.MESSAGE_HANDLED
		
   elseif id == 99 then
		-- Done clicked. Close this menu and it's overlaid menu
		--Graphics.FadeToBlack()
		--_G.SetFadeToBlack(true)
		local function transition()
			self:GetOverlayScreen():Close()
			self:activate_widget(self:GetWidgetName(self.menuOpen))
			self.closing = true
			--self:Close()
			
			if self.sourceMenu then
				--self.sourceMenu:Open()
				local sourceMenu = self.sourceMenu
				
				if sourceMenu == "SolarSystemMenu" and self.encounter_timer then
					_G.CallScreenSequencer("InventoryFrame", sourceMenu, nil,nil,nil,nil,nil, self.encounter_timer)
				else
					_G.CallScreenSequencer("InventoryFrame", sourceMenu)
				end		
			
			end
			if not self.opponent then
				_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero)
			end			
		end

		local source = self.sourceMenu		
		
		--SCREENS.CustomLoadingMenu:SetTarg(nil, transition, nil, source, "InventoryFrame")
		--SCREENS.CustomLoadingMenu:Open(nil, transition, nil, source, "InventoryFrame")
		transition()
		
	elseif GetGameTime() - self.last_click_time > 500 then
		close_custompopup_menu()
		PlaySound("snd_mapmenuclick")
		local oldMenu = self:GetOverlayScreenName(self.menuOpen)
		local newMenu = self:GetOverlayScreenName(id - 39)
		-- tab clicked. Use the button ID to calculate which screen
		-- to use, close current and open the new one
		self:activate_widget(self:GetWidgetName(self.menuOpen))
		self.menuOpen = id - 39
		
		SetFadeToBlack(true, 300)
		if(newMenu == "InvCrew")then
			SetFadeToBlack(true, 1500)
		end
		_G.CallScreenSequencer(oldMenu, newMenu)
		self:deactivate_widget(self:GetWidgetName(self.menuOpen))
		self.last_click_time = GetGameTime()		
	end
	
	return Menu.MESSAGE_HANDLED
end

function InventoryFrame:OnGamepadButton(user, button, value)
	LOG(string.format("InventoryFrame:OnGamepadButton %d %d %d", user, button, value))
	purge_garbage()

	if value == 0 then
		return Menu.MESSAGE_NOT_HANDLED
	end
	
	if button == _G.BUTTON_B then
		return Menu.MESSAGE_NOT_HANDLED
	end
	
	local oldMenu = self:GetOverlayScreenName(self.menuOpen)
	local newMenu
	if self.closing then
		return Menu.MESSAGE_HANDLED
	elseif GetGameTime() - self.last_click_time > 500 then
		if button == _G.BUTTON_L then
			self:activate_widget(self:GetWidgetName(self.menuOpen))
			if self.menuOpen == 1 then
				self.menuOpen = 7
			else
				self.menuOpen = self.menuOpen - 1
			end
			newMenu = self:GetOverlayScreenName(self.menuOpen)
			PlaySound("snd_mapmenuclick")
		elseif button == _G.BUTTON_R then
			self:activate_widget(self:GetWidgetName(self.menuOpen))
			if self.menuOpen == 7 then
				self.menuOpen = 1
			else
				self.menuOpen = self.menuOpen + 1
			end
			newMenu = self:GetOverlayScreenName(self.menuOpen)
			PlaySound("snd_mapmenuclick")
		else
			return Menu.MESSAGE_HANDLED
		end
	else
		return Menu.MESSAGE_HANDLED
	end
	close_custompopup_menu()
	_G.CallScreenSequencer(oldMenu, newMenu)
	self:deactivate_widget(self:GetWidgetName(self.menuOpen))
	self.last_click_time = GetGameTime()
	return Menu.MESSAGE_NOT_HANDLED
end

-- Closes the currently opened overlay screen
function InventoryFrame:GetOverlayScreen()
   	local returnVal
	if self.menuOpen == 2 then
		returnVal = SCREENS.InvShips
	elseif self.menuOpen == 3 then
		returnVal = SCREENS.InvFitout
	elseif self.menuOpen == 4 then
		returnVal = SCREENS.InvCargo
	elseif self.menuOpen == 5 then
	   returnVal = SCREENS.InvCrew
	elseif self.menuOpen == 6 then
	   returnVal = SCREENS.InvFactions
	elseif self.menuOpen == 7 then
		returnVal = SCREENS.InvQuests
	else-- DEFAULT
		self.menuOpen = 1
		returnVal = SCREENS.InvHero
	end

	return returnVal
end

function InventoryFrame:GetOverlayScreenName(tabID)
	if tabID == 1 then		
		return "InvHero"
	elseif tabID == 2 then
		return "InvShips"
	elseif tabID == 3 then
		return "InvFitout"
	elseif tabID == 4 then
		return "InvCargo"
	elseif tabID == 5 then
		return "InvCrew"
	elseif tabID == 6 then
		return "InvFactions"
	elseif tabID == 7 then
		return "InvQuests"
	end
end

-- returns the name of the button widget corresponding to the tab for the currently open menu
function InventoryFrame:GetWidgetName(tabID)
	local returnVal
	if tabID == 1 then
	   returnVal = "butt_pilot"
	elseif tabID == 2 then
		returnVal = "butt_ship"
	elseif tabID == 3 then
		returnVal = "butt_items"
	elseif tabID == 4 then
		returnVal = "butt_cargo"
	elseif tabID == 5 then
		returnVal = "butt_crew"
	elseif tabID == 6 then
		returnVal = "butt_factions"
	elseif tabID == 7 then
		returnVal = "butt_missions"
	end
	
	return returnVal
end


return ExportSingleInstance("InventoryFrame")
