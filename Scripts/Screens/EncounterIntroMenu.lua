use_safeglobals()


-- declare our menu
class "EncounterIntroMenu" (Menu);

function EncounterIntroMenu:__init()
	super()
	self:LoadGraphics()
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\EncounterIntroMenu.xml")

end


function EncounterIntroMenu:OnOpen()
	LOG("EncounterIntroMenu opened")

	if _G.is_open("SolarSystemMenu") then
		 	SCREENS.SolarSystemMenu:HideWidgets()
	end

	self:InitUI()

	if _G.is_open("LocationHighlightMenu") then
		_G.SCREENS.LocationHighlight:CloseMe()
	end
	SCREENS.SolarSystemMenu.state = _G.STATE_MENU

	if not IsGamepadActive() then
		self:hide_widget("icon_gp_y")
		self:hide_widget("str_gp_y")
	end

	_G.ShowTutorialFirstTime(28, _G.Hero)
	return Menu.OnOpen(self)
end

function EncounterIntroMenu:Open(enemy,callback, hostile,contraband)
	LOG("Hostile = " .. tostring(hostile))
	LOG("EncounterIntroMenu Open ")-- .. enemy.classIDStr);
	self.enemy = enemy
	self.callback = callback
	self.hostile = hostile
	self.contraband = contraband
	return Menu.Open(self)
end


function EncounterIntroMenu:InitUI()
	LOG("init UI combatintro " .. self.enemy.classIDStr)
	--assert(self.enemy:GetAttribute("curr_ship"),"Enemy Curr Ship empty")
	--LOG("ship type: " .. self.enemy:GetAttribute("curr_ship"):GetAttribute("model"))
	--LOG("ship type: " .. self.enemy:GetAttribute("curr_ship").classIDStr)
	local ship = self.enemy:GetAttribute("curr_ship")

	self:set_image("icon_ship", ship:GetAttribute("portrait") .. "_L")
	self:set_image("icon_insignia", _G.DATA.Factions[_G.Hero:GetFactionData(self.enemy:GetAttribute("faction"))].icon)

	--self:deactivate_widget("butt_info")

	self:InitUI_Name(self.enemy:GetAttribute('name'))

	local enemyLevel = self.enemy:GetLevel()
	self:set_text("str_level", string.format("%s %i", translate_text("[LEVEL_]"), enemyLevel))


	if self.contraband then
		self:set_text("str_contraband","[CONTRA_DETECT]")
	else
		self:set_text("str_contraband","")
	end

	local factionStanding = _G.Hero:GetFactionStanding(self.enemy:GetAttribute("faction"))

	if factionStanding < _G.STANDING_NEUTRAL then
		self:set_text("str_standing", translate_text("[ENEMYSHIP]"))
	elseif factionStanding > _G.STANDING_NEUTRAL then
		self:set_text("str_standing", translate_text("[FRIENDLY]"))
	else
		self:set_text("str_standing", translate_text("[NEUTRAL]"))
	end


	self:set_text_raw("str_weapons",tostring(ship:GetAttribute('weapons_rating')))
	self:set_text_raw("str_cpu",tostring(ship:GetAttribute('cpu_rating')))
	self:set_text_raw("str_engine",tostring(ship:GetAttribute('engine_rating')))
	self:set_text_raw("str_capacity",tostring(ship:GetAttribute('cargo_capacity')))
	self:set_text_raw("str_hull",tostring(ship:GetAttribute('hull')))
	self:set_text_raw("str_shield",tostring(ship:GetAttribute('shield')))

	if ship:GetAttribute("max_items") > _G.Hero:GetAttribute("psi_powers") + 2 or _G.Hero:GetAttribute("psi_powers") == 0 then
		self:deactivate_widget("butt_psi")
		self:hide_widget("icon_psi")
		self:hide_widget("str_psi")
	else
		_G.ShowTutorialFirstTime(29, _G.Hero)
		if _G.Hero:GetAttribute("psi") >= (10 + ((ship:GetAttribute("max_items")-3) * 8)) then
			self:activate_widget("butt_psi")
		else
			self:deactivate_widget("butt_psi")
		end
		self:activate_widget("icon_psi")
		self:activate_widget("str_psi")
		self:set_text("str_psi", string.format("%d, %s: %d", _G.Hero:GetAttribute("psi"), translate_text("[COST]"), 10 + ((ship:GetAttribute("max_items")-3) * 8) ))
	end

	if not self.hostile then
		self:hide_widget("butt_psi")
		self:hide_widget("icon_psi")
		self:hide_widget("str_psi")
	end
end

function EncounterIntroMenu:OnButton(buttonId, clickX, clickY)

	if buttonId == 1 then
		--self:Close()
		local function transition()
			self.callback(true)
			self.callback = nil
		end

		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "GameMenu", nil, 1000)
	elseif buttonId == 0 then
		if _G.is_open("SolarSystemMenu") then
				SCREENS.SolarSystemMenu:ShowWidgets()
		end
		self.callback(false)
		self.callback = nil
	elseif buttonId == 2 then
		_G.Hero:SetAttribute("psi", _G.Hero:GetAttribute("psi") - (10 + ((self.enemy:GetAttribute("curr_ship"):GetAttribute("max_items")) - 3) * 8))
		SCREENS.SolarSystemMenu:GetWorld():DisappearEncounter(self.enemy.encounter)
		--self:Close()

		local function transition()
			if _G.is_open("SolarSystemMenu") then
					SCREENS.SolarSystemMenu:ShowWidgets()
			end
			self.callback = nil
			self:Close()
		end
		--SCREENS.CustomLoadingMenu:SetTarg(nil, transition, nil, nil)
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, nil, "EncounterIntroMenu")
	end

	return Menu.MESSAGE_HANDLED
end


function EncounterIntroMenu:OnMouseEnter(id, x, y)
	if id ==131 then
		--_G.GLOBAL_FUNCTIONS.ShipPopup(self.enemy:GetAttribute("curr_ship").classIDStr, 330, y, self.enemy)
		_G.GLOBAL_FUNCTIONS.EnemyPopup(self.enemy, 330, y, _G.Hero)
		--_G.GLOBAL_FUNCTIONS.HeroPopup(self.enemy, 330, y)
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function EncounterIntroMenu:OnMouseLeave(id, x, y)
	close_custompopup_menu()
	return Menu.MESSAGE_HANDLED
end

function EncounterIntroMenu:OnGamepadButton(user, button, value)
	if button == _G.BUTTON_Y  and value == 1 then
		if is_custompopup_menu_open() then
			close_custompopup_menu()
		else
			_G.GLOBAL_FUNCTIONS.EnemyPopup(self.enemy, 330, 0, _G.Hero)
		end
		return Menu.MESSAGE_HANDLED
	end

	return Menu.MESSAGE_NOT_HANDLED
end

function EncounterIntroMenu:OnClose()
	--self.callback = nil

	close_custompopup_menu()

	_G.UnloadAssetGroup("AssetsBattleGround")

	SCREENS.EncounterIntroMenu = nil

	return Menu.OnClose(self)
end

dofile("Assets/Scripts/Screens/EncounterIntroMenuPlatform.lua")

-- return an instance of EncounterIntroMenu
return ExportSingleInstance("EncounterIntroMenu")
