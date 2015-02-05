
use_safeglobals()

class "InvHero" (Menu)

dofile("Assets/Scripts/Screens/InvHeroPlatform.lua")

function InvHero:__init()
	super()
	self:Initialize("Assets\\Screens\\InvHero.xml")
end

function InvHero:OnOpen()
	LOG("InvHero OnOpen()")

	--[[
	if IsGamepadActive() then
		-- for some reason, gp_entry isn't working properly in the XML, so set the starting button manually here
		 MenuSystem.SetGamepadWidget(self, "butt_stats")
	end
	]]--



	self:activate_widget("butt_stats")
	self:activate_widget("butt_intel")
	self:activate_widget("butt_plans")


	if SCREENS.InventoryFrame.mp then
		self:deactivate_widget("butt_intel")
		self:deactivate_widget("butt_plans")
		if SCREENS.InventoryFrame.opponent then
			self:deactivate_widget("butt_stats")
		end
	end

	-- hide names of skill gems that don't fit on the screen in particular languages
	if get_language() == 2 then -- German
		self:hide_widget("str_pilot")
		self:hide_widget("str_gunnery")
		self:hide_widget("str_engineer")
		self:hide_widget("str_science")
	end

	self:set_text_raw("str_heroname",     translate_text(SCREENS.InventoryFrame.hero:GetAttribute("name")))
	self:set_text_raw("str_pilot_val",    tostring(SCREENS.InventoryFrame.hero:GetCombatStat("pilot")))
	self:set_text_raw("str_gunnery_val",  tostring(SCREENS.InventoryFrame.hero:GetCombatStat("gunnery")))
	self:set_text_raw("str_engineer_val", tostring(SCREENS.InventoryFrame.hero:GetCombatStat("engineer")))
	self:set_text_raw("str_science_val",  tostring(SCREENS.InventoryFrame.hero:GetCombatStat("science")))

	--self:set_text_raw("str_level_val",    tostring(SCREENS.InventoryFrame.hero:GetAttribute("pilot")))
	self:set_text_raw("str_level_val",    tostring(SCREENS.InventoryFrame.hero:GetLevel()))
	self:set_text_raw("str_info_credits", substitute(translate_text("[N_CREDITS]"), _G.Hero:GetAttribute("credits")))
	self:set_text_raw("str_credits_val",  tostring(SCREENS.InventoryFrame.hero:GetAttribute("credits")))
	self:set_text_raw("str_intel",        substitute(translate_text("[INTEL_]"), SCREENS.InventoryFrame.hero:GetAttribute("intel")))
	self:set_text_raw("str_psi_points",   substitute(translate_text("[PSI_]"),   SCREENS.InventoryFrame.hero:GetAttribute("psi")))
--	self:set_text_raw("str_plans",        "Plans: X of Y")

	self:set_image("icon_avatar", SCREENS.InventoryFrame.hero:GetAttribute("portrait"))


--	self:deactivate_widget("butt_plans")

	-- display unlocked psi powers
	for i=1,SCREENS.InventoryFrame.hero:GetAttribute("psi_powers") do
		if i > 7 then
			break
		end

		self:activate_widget(string.format("icon_psi%d_logo", i))
		self:set_image(string.format("icon_psi%d_logo", i), string.format("img_psi_power%d", i))
		self:set_image(string.format("icon_psi%d_frame", i), "img_psiframe_lit")
	end

	for i = SCREENS.InventoryFrame.hero:GetAttribute("psi_powers")+1, 7 do
		self:deactivate_widget(string.format("pad_psi%d", i))
		self:hide_widget(string.format("icon_psi%d_logo", i))
		self:set_image(string.format("icon_psi%d_frame", i), "img_psiframe_unlit")
	end

	self.xbox_popup_active = false

	LOG("InvHero OnOpen() finished")

	_G.ShowTutorialFirstTime(12,_G.Hero)
	return Menu.MESSAGE_HANDLED
end


function InvHero:OnGainFocus()
   LOG("InvHero OnGainFocus()")
	self:set_text_raw("str_pilot_val",    tostring(SCREENS.InventoryFrame.hero:GetCombatStat("pilot")))
	self:set_text_raw("str_gunnery_val",  tostring(SCREENS.InventoryFrame.hero:GetCombatStat("gunnery")))
	self:set_text_raw("str_engineer_val", tostring(SCREENS.InventoryFrame.hero:GetCombatStat("engineer")))
	self:set_text_raw("str_science_val",  tostring(SCREENS.InventoryFrame.hero:GetCombatStat("science")))
	self:set_text_raw("str_intel",        substitute(translate_text("[INTEL_]"), SCREENS.InventoryFrame.hero:GetAttribute("intel")))
	self:set_text_raw("str_level",        substitute(translate_text("[LEVEL_]"), SCREENS.InventoryFrame.hero:GetLevel()))

	--return Menu.MESSAGE_NOT_HANDLED
	return Menu.OnGainFocus(self)
end

function InvHero:OnButton(id, x, y)
	LOG("InvHero OnButton()")
	--close_custompopup_menu()
	if self.xbox_popup_active then
		if id ~= 99 then
			-- don't do anything if the XBox's info popup is open
			LOG("Xbox popup open, OnButton call blocked, id="..id)
			return Menu.MESSAGE_HANDLED
		else
			-- id 99 is the InventoryFrame's Done button, we want that to still work.
			LOG(string.format("InvHero:OnButton(%d, %d, %d): XBox Popup Active", id, x, y))
			close_custompopup_menu()
			self.xbox_popup_active = false
			--self:PlatformButtons(id, x, y)
			--return Menu.MESSAGE_NOT_HANDLED
			--return Menu.OnButton(self, id, x, y)
			--return self:PlatformButtons(id, x, y)
			SCREENS.InventoryFrame:OnButton(id, x, y)
		end
	end

	gcinfo()
	if id == 10 then
		if(self:ButtonClickCheck() == true)then

			close_custompopup_menu()
      		SCREENS.RumorViewMenu:Open()
      		SCREENS.RumorViewMenu:CreateList()
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 11 then
		if(self:ButtonClickCheck() == true)then
			Graphics.FadeToBlack()
			local event = GameEventManager:Construct("FadeFromBlack")
			local nextTime = GetGameTime() + 1500
			GameEventManager:SendDelayed( event, _G.Hero, nextTime )
			close_custompopup_menu()
			SCREENS.InvStats:Open()
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 12 then
		if(self:ButtonClickCheck() == true)then

			close_custompopup_menu()
     		SCREENS.InvPlans:Open()
		end
		return Menu.MESSAGE_HANDLED
	elseif id > 110 and id < 120 then
		if ((id - 110) <= SCREENS.InventoryFrame.hero:GetAttribute("psi_powers")) then
			if(self:ButtonClickCheck() == true)then
				self:PsiPowerPopup(id,x,y)
				return Menu.MESSAGE_HANDLED
			else
				return Menu.MESSAGE_HANDLED
			end
		end
	end

	return self:PlatformButtons(id, x, y)
end

function InvHero:OnMouseLeave(id, x, y)
	LOG("InvHero:OnMouseLeave()")
	close_custompopup_menu()
	return Menu.MESSAGE_NOT_HANDLED
end


function InvHero:OnMouseEnter(id,x,y)
	close_custompopup_menu()

	if id < 10 then
		   	local stat = "PILOT"
			if id == 2 then
				stat = "GUNNERY"
			elseif id == 3 then
				stat = "ENGINEER"
			elseif id == 4 then
				stat = "SCIENCE"
			end
			local lowStat = string.lower(stat)
			local value = SCREENS.InventoryFrame.hero:GetAttribute(lowStat)
			local special
			local scales = { }
			if id == 1 then
				scales.max = 4
				scales.start = 3
				scales.gain = 0.6
			else
				scales.max = 2
				scales.start = 1
				scales.gain = 0.2
			end

			local xPos, yPos
			if math.mod(id, 2) == 1 then
				xPos = 410
			else
				xPos = 542
			end

			if id <= 2 then
				yPos = 277
			else
				yPos = 356
			end

--			local stringTable = { stat  = string.format("%s: %d", translate_text(string.format("[%s]",stat)), value),
--			                      stat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
--			                      stat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
--			                      stat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
--								  stat4 = string.format("+%d %s", special, translate_text(string.format("[%s_BONUS_3]", stat)))
--			                    }

	local stringTable = { }
	local GunBonusDamage = math.floor(_G.Hero:GetAttribute('gunnery') / 50)
	local ScienceBonusCooldown = math.floor(_G.Hero:GetAttribute('science') / 75)
	local ScienceHackingBonus = _G.GLOBAL_FUNCTIONS.ScienceHackingBonus(_G.Hero:GetAttribute('science'))
	local EngineeringMiningBonus = _G.GLOBAL_FUNCTIONS.EngineeringMiningBonus(_G.Hero:GetAttribute('engineer'))
	local EngineeringRepairBonus = math.floor(_G.Hero:GetAttribute('engineer') / 25)
	if _G.Hero:GetAttribute('engineer') >= 245 then
		EngineeringRepairBonus = 10
	end

	if id == 2 then
		stringTable = {
							statName = translate_text(string.format( "[%s]",stat)) ,
							stat  = string.format("%s %d", translate_text("[CURRENT_RANK_]"), value),
							stat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							stat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							stat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
							stat4 = string.format("+%d %s", GunBonusDamage, translate_text(string.format("[%s_BONUS_3]", stat))),
						}

			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TEXT/3/141/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.stat4),
				x+92+(216*(id-1)), y+234, 1, 300)
	end

	if id == 3 then
		stringTable = {
							statName = translate_text(string.format( "[%s]",stat)) ,
							stat  = string.format("%s %d", translate_text("[CURRENT_RANK_]"), value),
							stat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							stat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							stat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
							stat4 = string.format("+%d %s", EngineeringRepairBonus, translate_text(string.format("[%s_BONUS_3]", stat))),
							stat5 = string.format("+%d %s", EngineeringMiningBonus, translate_text(string.format("[%s_BONUS_4]", stat))),
						}

			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TEXT/3/141/font_info_white//TEXT/3/165/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.stat4, stringTable.stat5),
				x+92+(216*(id-1)), y+234, 1, 300)
	end

	if id == 4 then
		stringTable = {
							statName = translate_text(string.format( "[%s]",stat)) ,
							stat  = string.format("%s %d", translate_text("[CURRENT_RANK_]"), value),
							stat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							stat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							stat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
							stat4 = string.format("+%d %s", ScienceBonusCooldown, translate_text(string.format("[%s_BONUS_3]", stat))),
							stat5 = string.format("+%d %s", ScienceHackingBonus, translate_text(string.format("[%s_BONUS_4]", stat))),
						}

			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TEXT/3/141/font_info_white//TEXT/3/165/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.stat4, stringTable.stat5),
				x+92+(216*(id-1)), y+234, 1, 300)
	end

	if id == 1 then
		stringTable = {
							statName = translate_text(string.format( "[%s]",stat)) ,
							stat  = string.format("%s %d", translate_text("[CURRENT_RANK_]"), value),
							stat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							stat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							stat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
						}

			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3),
				x+92+(216*(id-1)), y+234, 1, 300)
	end

--			open_custompopup_menu("//TITLE/6/font_info_blue//TEXT/3/28/font_info_white//TEXT/3/47/font_info_white//TEXT/3/66/font_info_white//TEXT/3/85/font_info_white//BORDER/50/150/255/255//",
--			                      string.format("%s%s%s%s%s%s%s%s%s%s%s", "//", stringTable.stat, "//", stringTable.stat1, "//", stringTable.stat2, "//", stringTable.stat3, "//", stringTable.stat4, "//"),
--										 xPos + x, yPos + y, 1, 300)
		return Menu.MESSAGE_HANDLED
	elseif id == 20 then
			open_custompopup_menu("//HELP/5/3/font_info_gray//BORDER/50/150/255/255//", "//[CREDITS_INSTRUCTION]//", 240+x, 355+x, 1, 250)
		return Menu.MESSAGE_HANDLED
	elseif id == 21 then
			open_custompopup_menu("//HELP/5/3/font_info_gray//BORDER/50/150/255/255//", "//[INTEL_INSTRUCTION]//", 458+x, 219+y, 1, 250)
		return Menu.MESSAGE_HANDLED
	elseif id == 22 then
			open_custompopup_menu("//HELP/5/3/font_info_gray//BORDER/50/150/255/255//", "//[PSI_INSTRUCTION]//", 458+x, 247+y, 1, 250)
		return Menu.MESSAGE_HANDLED
	end
	return Menu.MESSAGE_NOT_HANDLED
end

return ExportSingleInstance("InvHero")
