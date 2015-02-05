
use_safeglobals()

class "InvStats" (Menu)

dofile("Assets/Scripts/Screens/InvStatsPlatform.lua")

function InvStats:__init()
	super()
   --self:LoadGraphics()
	self:Initialize("Assets\\Screens\\InvStats.xml")
end

function InvStats:OnOpen()
	-- warning: does this load the whole InventoryFrame into memory?
	--self.hero = SCREENS.InventoryFrame.hero or _G.Hero		
	
	self.lastTime = GetGameTime()
	self.hero = _G.Hero
	assert(self.hero, "No hero")
	
	self:UpdateStats()

	if IsGamepadActive() then
		self.selectedWidget = 1
		self:set_widget_position("icon_gp_cursor", 92 + ((self.selectedWidget - 1)*216), 254)
		self:hide_widget("str_action_desc")
	else
		self:hide_widget("icon_gp_cursor")
		self:hide_widget("grp_gp")
	end
	
	_G.ShowTutorialFirstTime(21, _G.Hero)
	return Menu.OnOpen(self)
end

function InvStats:OnClose()

	self.hero           = nil
	self.selectedWidget = nil
	self.showInfo       = nil
	self.callback       = nil	
	
	if _G.is_open("SolarSystemMenu") then
		SCREENS.SolarSystemMenu:ShowWidgets()
	end		
	
	--[[
	if _G.is_open("MPResultsMenu") then
			SCREENS.MPResultsMenu:LevelUpStatHero()
	end
	--]]
	
	self.invTab = nil
	
	return Menu.OnClose(self)
end

function InvStats:OnAnimOpen()
	if _G.is_open("LevelUpMenu") then
		 	self:HideWidgets()
	end		
	
	if _G.is_open("SolarSystemMenu") then
		 	SCREENS.SolarSystemMenu:HideWidgets()
	end			
	
	if _G.is_open("InvHero") then
		 	SCREENS.InvHero:HideWidgets()
	end			
	
	return Menu.MESSAGE_HANDLED
end

function InvStats:Open(callback,stat_hero,invTab)
	
	self.invTab = invTab
	
--[[
	if loadSystem then
		LoadAssetGroup("AssetsSolarSystem")
	end
]]--
	self.callback = callback

	return Menu.Open(self)
end

function InvStats:OnMouseEnter(id, x, y)
	LOG("OnMouseEnter")
	PlaySound("snd_butthover")
	self:OpenInfoPopup(x,y,id,string.upper(self:GetStatName(id)))
	if self.hero:GetAttribute("stat_points") > 0 and self.hero:GetAttribute(self:GetStatName(id)) < 250 then
		self:activate_widget("img_frame"..id.."_light")
	end

	return Menu.OnMouseEnter(self, id, x, y)
end

function InvStats:OnMouseLeftButton(id, x, y, up)
	
	if (id > 0 and id < 5 and up) then
		self:IncrementStat(id,true)
		return Menu.MESSAGE_HANDLED
	end
	return Menu.OnMouseLeftButton(self, id, x, y, up)
end

function InvStats:OnGamepadDPad(user, dpad, x, y)
	if x ~= 0 then
		LOG("Dpad = " .. tostring(x))
		PlaySound("snd_mapmenuclick")
		--[[
		if x > 0 then
			self.selectedWidget = math.min(self.selectedWidget+1, 4)
		else
			self.selectedWidget = math.max(self.selectedWidget-1, 1)
		end
		]]
		self.selectedWidget = self.selectedWidget + x
		if self.selectedWidget < 1 then
			self.selectedWidget = 4
		elseif self.selectedWidget > 4 then
			self.selectedWidget = 1
		end
		self:set_widget_position("icon_gp_cursor", 92 + ((self.selectedWidget - 1)*216), 254)
		
		if self.showInfo then
		close_custompopup_menu()
		self:OpenInfoPopup(0, 0, self.selectedWidget, string.upper(self:GetStatName(self.selectedWidget)))
		end
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvStats:OnGamepadJoystick(user, joystick, x_dir, y_dir)
	if self.lastTime < GetGameTime() - 250 then
		if x_dir >= 100 then
			self:OnGamepadDPad(user, 0, 1, 0)
			self.lastTime = GetGameTime()
			return Menu.MESSAGE_HANDLED

		elseif x_dir <= -100 then
			self:OnGamepadDPad(user, 0, -1, 0)
			self.lastTime = GetGameTime()
			return Menu.MESSAGE_HANDLED

		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvStats:OnGamepadButton(user, button, value)
	if value == 1 then
		if button == _G.BUTTON_A then	
			PlaySound("snd_buttclick")
			self:OnMouseLeftButton(self.selectedWidget, 0, 0, true)
			return Menu.MESSAGE_HANDLED
		elseif button == _G.BUTTON_Y then
			PlaySound("snd_buttclick")
			self.showInfo = not self.showInfo
			if self.showInfo then
				self:OpenInfoPopup(0, 0, self.selectedWidget, string.upper(self:GetStatName(self.selectedWidget)))
			else
				close_custompopup_menu()
			end
			return Menu.MESSAGE_HANDLED
		end
	end
	return Menu.MESSAGE_NOT_HANDLED
end



function InvStats:OnButton(id, up)
	LOG("OnButton")
	if id == 99 then
		--self:Close()
	
		close_custompopup_menu()		
		local function continue()			
			local function UnloadInvStatsAssets()
				 UnloadAssetGroup("AssetsTraining")
			end
			--self:UnloadGraphics()
			
			
			local inv_hero_open = _G.is_open("InvHero")
			local system_open = _G.is_open("SolarSystemMenu")
			
			if inv_hero_open then
					SCREENS.InvHero:ShowWidgets()
			elseif system_open then
				SCREENS.SolarSystemMenu:ShowWidgets()
				if self.invTab then
					SCREENS.InventoryFrame:Open("SolarSystemMenu",self.invTab)
				end
			end									
			
			if not _G.is_open("GameMenu") and not inv_hero_open and not system_open then
				SetFadeToBlack(true, 500)
				if self.invTab then
					CallScreenSequencer("InvStats", "InventoryFrame","SolarSystemMenu",self.invTab)
				else
					CallScreenSequencer("InvStats", "SolarSystemMenu")
				end
			else
				Graphics.FadeToBlack()	
				local event = GameEventManager:Construct("FadeFromBlack")
				local nextTime = GetGameTime() + 1000
				GameEventManager:SendDelayed( event, _G.Hero, nextTime )						
				CallScreenSequencer("InvStats", UnloadInvStatsAssets)
			end			
			
			if self.callback then
				self.callback()
			end						
		end

		--_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero, continue)
		continue()
					
		return Menu.MESSAGE_HANDLED
	elseif id > 0 and id < 5 then
		self:IncrementStat(id, up)
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvStats:IncrementStat(id, up)
	if up then
		if self.hero:GetAttribute("stat_points") >= 1 and self.hero:GetAttribute(self:GetStatName(id)) < 250 then
			self.hero:SetAttribute("stat_points", self.hero:GetAttribute("stat_points") - 1)
			self.hero:SetAttribute(self:GetStatName(id), self.hero:GetAttribute(self:GetStatName(id)) + 1)
			PlaySound("snd_gemwhite")
			self:UpdateStats()
			if is_custompopup_menu_open() then
				close_custompopup_menu()
				self:OpenInfoPopup(0, 0, id, string.upper(self:GetStatName(id)))
			end
			self.hero:SetToSave()
		else
			PlaySound("snd_illegal")
		end
	end
end

return ExportSingleInstance("InvStats")