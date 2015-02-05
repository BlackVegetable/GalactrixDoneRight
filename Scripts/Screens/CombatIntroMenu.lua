use_safeglobals()

--local SP = import("Steve_Profile")

-- declare our menu
class "CombatIntroMenu" (Menu);

function CombatIntroMenu:__init()
	super()
	LOG("__Init() XML")
	self:LoadGraphics()
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\CombatIntroMenu.xml")
	self.counter = 1
	self.time = 1
end


function CombatIntroMenu:OnOpen()
	LOG("CombatIntroMenu opened")
	
	if _G.is_open("SolarSystemMenu") then
	 	SCREENS.SolarSystemMenu:HideWidgets()
	end				
	

	self:InitUI()
	
	--_G.SCREENS = nil
	
	if not IsGamepadActive() then
		self:hide_widget("icon_gp_y")
		self:hide_widget("str_gp_y")
	end

	ShowMemUsage("CombateIntroMenu 02")
		
	return Menu.OnOpen(self)
end

function CombatIntroMenu:Open(enemy,callback)

	SCREENS.SolarSystemMenu.state = _G.STATE_MENU
		
	LOG("CombatIntroMenu Open ")-- .. enemy.classIDStr);
	self.enemy = enemy
	self.callback = callback
	return Menu.Open(self)
end


function CombatIntroMenu:InitUI()
	LOG("init UI combatintro" .. self.enemy.classIDStr)
	--assert(self.enemy:GetAttribute("curr_ship"),"Enemy Curr Ship empty")
	--LOG("ship type: " .. self.enemy:GetAttribute("curr_ship"):GetAttribute("model"))
	--LOG("ship type: " .. self.enemy:GetAttribute("curr_ship").classIDStr)
	local ship = self.enemy:GetAttribute("curr_ship")
	
	self:set_image("icon_ship", ship:GetAttribute("portrait") .. "_L")
	self:set_image("icon_insignia", _G.DATA.Factions[_G.Hero:GetFactionData(self.enemy:GetAttribute("faction"))].icon)
	
	self:InitUI_Name(self.enemy:GetAttribute('name'))
	
	local enemyLevel = self.enemy:GetLevel()
	self:set_text("str_level", string.format("%s %i",translate_text("[LEVEL_]"), enemyLevel))
	--self:set_image("str_portrait",   self.enemy:GetAttribute('portrait'))	
	
	local factionStanding = _G.Hero:GetFactionStanding(self.enemy:GetAttribute("faction"))
	

 	self:set_text("str_weapons",   tostring(ship:GetAttribute('weapons_rating')))
	self:set_text("str_cpu",   tostring(ship:GetAttribute('cpu_rating')))
	self:set_text("str_engine",   tostring(ship:GetAttribute('engine_rating')))
	self:set_text("str_hull",   tostring(ship:GetAttribute('hull')))
	self:set_text("str_shield",  tostring( ship:GetAttribute('shield'))	)

	self:set_text("str_ship_class",substitute(translate_text("[_CLASS]"), translate_text(_G.GLOBAL_FUNCTIONS.GetShipClass(ship:GetAttribute("max_items")))))
		
	self:set_text_raw("str_slots", string.format("(%s)", substitute(translate_text("[_SLOTS]"),ship:GetAttribute("max_items"))))
	
	
	
	if ship:GetAttribute("max_items") > _G.Hero:GetAttribute("psi_powers") + 2 or _G.Hero:GetAttribute("psi_powers") == 0 then
		self:deactivate_widget("butt_psi")
	else
		self:activate_widget("butt_psi")
	end
end

function CombatIntroMenu:OnButton(buttonId, clickX, clickY)

	if buttonId == 1 then--OK
		local function transition()
			self.callback(true)	
			self.callback = nil
		end
		SetFadeToBlack(false)
		SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "GameMenu", nil, 1000)		

		
	elseif buttonId == 0 then--CANCEL		
		local function transition()
			if _G.is_open("SolarSystemMenu") then
				SCREENS.SolarSystemMenu:ShowWidgets()
			end			
			self.callback(false)
			self.callback = nil
		end
		local enemy = self.enemy
		self.enemy = nil
		_G.GLOBAL_FUNCTIONS.ClearChar.ClearEnemy(enemy)
		enemy = nil			
		--SetFadeToBlack(true, 500)
		--_G.CallScreenSequencer("CombatIntroMenu", transition)
		SetFadeToBlack(false)
		--SCREENS.CustomLoadingMenu:Open(nil, transition, nil, nil, "CombatIntroMenu")		
		transition()
	end
	--self.callback = nil
	
	return Menu.MESSAGE_HANDLED
end


function CombatIntroMenu:OnMouseEnter(id, x, y)
	if id ==131 then
		--_G.GLOBAL_FUNCTIONS.ShipPopup(self.enemy:GetAttribute("curr_ship").classIDStr, 330, y, self.enemy)
		_G.GLOBAL_FUNCTIONS.EnemyPopup(self.enemy, 330, y, _G.Hero)
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function CombatIntroMenu:OnMouseLeave(id, x, y)
	close_custompopup_menu()
	return Menu.MESSAGE_HANDLED
end

--[[
-----CYLCE ENEMIES
function CombatIntroMenu:OnTimer(time)
	local dif = time - self.time
	if dif > 1000 then
		self.time = time
		self.counter = self.counter + 1
		if self.counter > #_G.DATA.MP_Enemies then
			self.counter = 1
		end
		self:set_image("icon_ship",string.format("img_%s_L", _G.HEROES[_G.DATA.MP_Enemies[self.counter].init_ship]))	
		self:set_text("str_name",   _G.HEROES[_G.DATA.MP_Enemies[self.counter]--].name)		
		self:set_image("icon_insignia",_G.DATA.Factions[_G.HEROES[_G.DATA.MP_Enemies[self.counter]--].faction].icon)	
		
	end
	
	return Menu.MESSAGE_HANDLED
end
--]]

function CombatIntroMenu:OnGamepadButton(user, button, value)
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

function CombatIntroMenu:OnClose()
	LOG("CombatIntroMenu:OnClose")

	--self.callback = nil
	close_custompopup_menu()
	SCREENS.CombatIntroMenu = nil
	
	return Menu.OnClose(self)
end

function CombatIntroMenu:OnAnimOpen(data)

	Graphics.FadeFromBlack()

	return Menu.MESSAGE_HANDLED	
end

dofile("Assets/Scripts/Screens/CombatIntroMenuPlatform.lua")

-- return an instance of CombatIntroMenu
return ExportSingleInstance("CombatIntroMenu")
