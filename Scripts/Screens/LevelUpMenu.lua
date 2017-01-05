
use_safeglobals()

class "LevelUpMenu" (Menu)

dofile("Assets/Scripts/Screens/LevelUpMenuPlatform.lua")

function LevelUpMenu:__init()
	super()
   --self:LoadGraphics()
	self:Initialize("Assets\\Screens\\LevelUpMenu.xml")
end

function LevelUpMenu:OnOpen()
	assert(self.levelHero, "No Hero")

	if _G.is_open("SolarSystemMenu") then
		SCREENS.SolarSystemMenu:HideWidgets()
	end

	local intel = self.levelHero:GetAttribute("intel")
	local lvl = 1
	while intel >= (20 + (lvl * 10)) and lvl < 50 do
		intel = intel - (20 + (lvl*10))
		lvl = lvl + 1
	end

	self:set_text_raw("str_heading", substitute(translate_text("[PLAYER_LEVELLED_]"), lvl))

	local levelText = string.format("%s %d", translate_text("[CURRENT_LEVEL_]"), lvl)
	local font = self:get_font("str_curr_level")
	if get_text_length(font, levelText) > self:get_widget_w("str_curr_level") then
		self:set_font("str_curr_level", "font_info_white")
	end

	self:set_text_raw("str_curr_level", levelText)
	self:set_text_raw("str_curr_intel", tostring(self.levelHero:GetAttribute("intel")-intel))
	--local bonusString = string.format("%s .\n.%s", substitute(translate_text("[LEVEL_BONUS_HULL_]"), lvl-1), substitute(translate_text("[LEVEL_BONUS_DMG_]"), math.floor(lvl/5)))
    local bonusString = substitute(translate_text("[LEVEL_BONUS_HULL_]"), lvl-1) .. "\n" .. substitute(translate_text("[LEVEL_BONUS_DMG_]"), math.floor(lvl/10))
	self:set_text_raw("str_curr_bonus", bonusString)

	if lvl < 50 then
		levelText = string.format("%s %d", translate_text("[NEXT_LEVEL_]"), lvl+1)
		font = self:get_font("str_next_level")
		if get_text_length(font, levelText) > self:get_widget_w("str_next_level") then
			self:set_font("str_next_level", "font_info_white")
		end

		self:set_text_raw("str_next_level", string.format("%s %d", translate_text("[NEXT_LEVEL_]"), lvl+1))
		self:set_text_raw("str_next_intel", tostring(self.levelHero:GetAttribute("intel")-intel+(20+(lvl*10))))
		bonusString = substitute(translate_text("[LEVEL_BONUS_HULL_]"), lvl) .. "\n" .. substitute(translate_text("[LEVEL_BONUS_DMG_]"), math.floor((lvl+1)/10))
		self:set_text_raw("str_next_bonus", bonusString)
	else
		-- once you're at level 50 you can't go further
		self:hide_widget("str_next_level")
		self:hide_widget("icon_next_level")
		self:hide_widget("str_next_intel")
		self:hide_widget("str_next_bonus")
		self:hide_widget("black_frame1")
	end
	local shipID = self.levelHero:GetAttributeAt("ship_list",self.levelHero:GetAttribute("ship_loadout")):GetAttribute("ship")
	--self:set_image("icon_ship", _G.SHIPS[shipID].portrait)
	self:set_image("icon_ship", string.format("img_%s_L", shipID))

   self:set_image("icon_backdrop_top1", string.format("%s_M", self.levelHero:GetAttribute("portrait")))
	--self.levelHero:SetAttribute("stat_points", self.levelHero:GetAttribute("stat_points") + 5)


	local function XBoxAchievement()
		if self.levelHero:GetLevel() == 50 then
			AwardXAchievement(1,_G.XLAST.ACHIEVEMENT_ACHIEVE_LEVELLING)
		end
	end
	_G.XBoxOnly(XBoxAchievement)

	PlaySound("snd_levelup")

	return Menu.MESSAGE_HANDLED
end


function LevelUpMenu:Open(callback,levelHero,invTab)
	self.callback = callback


	if invTab then
		self.invTab = invTab
	end
	self.levelHero = levelHero
	if not levelHero then
		self.levelHero = _G.Hero
	end
	self.levelHero:SetToSave()

	return Menu.Open(self)
end

function LevelUpMenu:OnButton(id, up)
	if id == 99 and up then
--		SCREENS.LevelUpMenu:Close()
--		SCREENS.LevelUpMenu = nil
--		SCREENS.InvStats:Open()

		local function continue()
			local function DoNothing()
			end
			Graphics.FadeToBlack()
			_G.CallScreenSequencer("LevelUpMenu", DoNothing)
			local event = GameEventManager:Construct("FadeFromBlack")
			local nextTime = GetGameTime() + 2000
			GameEventManager:SendDelayed( event, _G.Hero, nextTime )
		end
		--_G.GLOBAL_FUNCTIONS.AutoSaveHero(self.levelHero, continue)
		continue()
	end
	return Menu.MESSAGE_HANDLED
end

function LevelUpMenu:OnClose()
	--if _G.is_open("SolarSystemMenu") then
			--SCREENS.SolarSystemMenu:ShowWidgets()
	--end
	SCREENS.InvStats:Open(self.callback,self.levelHero,self.invTab)
   --self:UnloadGraphics()

   self.invTab = nil


	return Menu.MESSAGE_HANDLED
end

return ExportSingleInstance("LevelUpMenu")
