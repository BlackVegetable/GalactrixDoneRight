use_safeglobals()


-- declare our menu
class "CombatResultsMenu" (Menu);

function CombatResultsMenu:__init()
	super()

	--BEGIN_STRIP_DS
	local function WiiGamepadOff()
		SetIsGamepadActive(false)
	end
	WiiOnly(WiiGamepadOff)
	--END_STRIP_DS

	self:LoadGraphics()

	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\CombatResultsMenu.xml")

end


function CombatResultsMenu:Open(victory,callback, statHero, factionChange, planList, cargoList, shipPortrait)
LOG("CombatResultsMenu Open")
	self.victory = victory
	self.callback = callback
	self.faction = factionChange
	self.plans = planList
	self.cargo = cargoList
	self.statHero = statHero
	self.shipPortrait = shipPortrait

	return Menu.Open(self)
end

function CombatResultsMenu:OnOpen()
	LOG("CombatResultsMenu opened")

	if _G.is_open("LevelUpMenu") then
	 	self:HideWidgets()
	end

	add_text_file("FactionText.xml")

	self.clicked = false

	if self.victory then
		LOG("victory yes")
		self:Victory()
	else
		LOG("victory no")
		self:Defeat()
	end

	return Menu.OnOpen(self)
end

function CombatResultsMenu:OnClose()
	remove_text_file("FactionText.xml")

	self.victory  = nil
	self.callback = nil
	self.faction  = nil
	self.plans    = nil
	self.cargo    = nil
	self.statHero = nil
	self.levelUp  = nil

	LOG("CombatResultsMenu Close")
	return Menu.OnClose(self)
end



function CombatResultsMenu:Defeat()

	self:set_text_raw("str_heading",translate_text("[DEFEAT]"))
	self:set_text_raw("str_message",translate_text("[BATTLE_DEFEAT]"))

	_G.WAS_VICTORY = false

	self:activate_widget("str_retry")
	self:activate_widget("butt_yes")
	self:activate_widget("butt_no")
	self:hide_widget("str_plans_heading")
	self:hide_widget("str_cargo_heading")
	self:hide_widget("img_cargo_1")
	self:hide_widget("img_cargo_2")
	self:hide_widget("img_cargo_3")
	self:hide_widget("img_cargo_4")
	self:hide_widget("str_plans_val_1")
	self:hide_widget("str_plans_val_2")
	self:hide_widget("butt_continue")
	self:hide_widget("icon_dark_faction_gain")
	self:hide_widget("icon_dark_faction_loss")
	self:hide_widget("icon_dark_cargo")
	self:hide_widget("icon_dark_plans")


	self:SetStats(self.statHero)
end

function CombatResultsMenu:Victory()


	self:set_text_raw("str_heading",translate_text("[VICTORY]"))
	self:set_text_raw("str_message",translate_text("[BATTLE_VICTORY]"))

	_G.WAS_VICTORY = true

	self:activate_widget("butt_continue")
	self:hide_widget("butt_yes")
	self:hide_widget("butt_no")
	self:hide_widget("str_retry")
	self:activate_widget("str_plans_heading")
	self:activate_widget("str_cargo_heading")
	self:activate_widget("str_plans_val_1")
	self:activate_widget("str_plans_val_2")
	self:set_text("str_plans_val_1", "")
	self:set_text("str_plans_val_2", "")
	self:activate_widget("icon_dark_faction_gain")
	self:activate_widget("icon_dark_faction_loss")
	self:activate_widget("icon_dark_cargo")
	self:activate_widget("icon_dark_plans")

	self:SetStats(self.statHero)
end

function CombatResultsMenu:SetStats(statHero)

	if not statHero then
		LOG("No StatHero")
		return
	end
	local bonusExp = 0

	if _G.WAS_VICTORY == true then
		if _G.ENEMY_LEVEL <= 10 then
			bonusExp = 8
		elseif _G.ENEMY_LEVEL <= 20 then
			bonusExp = 16
		elseif _G.ENEMY_LEVEL <= 30 then
			bonusExp = 24
		elseif _G.ENEMY_LEVEL <= 40 then
			bonusExp = 32
		elseif _G.ENEMY_LEVEL < 50 then
			bonusExp = 40
		elseif _G.ENEMY_LEVEL == 50 then
			bonusExp = 45
		else
			bonusExp = 0
		end
	end

	local preIntel = statHero:GetAttribute("intel")
	statHero:SetAttribute("intel", preIntel + bonusExp)

	--self:set_text_raw("str_psi",tostring(statHero:GetAttribute('psi')))
	self:set_text_raw("str_psi",tostring(statHero.matchCount.psi))
	--self:set_text_raw("str_intel",tostring(statHero:GetAttribute('intel')))
	self:set_text_raw("str_intel",tostring(statHero.matchCount.intel + bonusExp))
	self:set_text_raw("str_life",tostring(statHero:GetAttribute("life")))
	self:set_text_raw("str_chain",tostring(statHero.longest_chain))
	--self:set_text_raw("str_damage_done",tostring(statHero.damage_done))
	--self:set_text_raw("str_damage_received",tostring(statHero.damage_received))
	self:set_text_raw("str_fourofakinds",tostring(statHero.matchCount[4]))
	self:set_text_raw("str_fiveofakinds",tostring(statHero.matchCount[5] + statHero.matchCount[6] + statHero.matchCount[7] + statHero.matchCount[8]))
	self:set_text_raw("str_duration",tostring(_G.TOTAL_TURNS))
	--self:set_text_raw("str_sixofakinds",tostring(statHero.matchCount[6]))
	--self:set_text_raw("str_sevenofakinds",tostring(statHero.matchCount[7]))
	--self:set_text_raw("str_novas",tostring(statHero.novas))
	--self:set_text_raw("str_supanovas",tostring(statHero.supanovas))

	if self.shipPortrait then
		self:set_image("icon_ship", string.format("%s_L", self.shipPortrait))
	end

	local oldLevel = statHero:GetLevel(statHero:GetAttribute("intel") - statHero.matchCount.intel - bonusExp)
	local newLevel = statHero:GetLevel()

	if _G.GLOBAL_FUNCTIONS.DemoMode() and newLevel > 5 then
		newLevel = oldLevel
	end

	if statHero:GetAttribute("ai") ~= 1 and oldLevel < newLevel then
		Graphics.FadeToBlack()
		statHero:SetAttribute("stat_points", statHero:GetAttribute("stat_points") + (5*(newLevel-oldLevel)))
		SCREENS.LevelUpMenu:Open()
		self.levelUp = true
	else
		if statHero:GetAttribute("intel") > 13300 then
			statHero:SetAttribute("intel", 13300)
		end
	end

	local cargoText = ""
	local iterator = 1
	if self.cargo then

		LOG("CargoList")
		for i,v in pairs(self.cargo) do
			if v ~= 0 then
				cargoText = string.format("%s%s: %d \n", cargoText, translate_text(string.format("[%s_NAME]", string.upper(_G.DATA.Cargo[i].effect))), math.floor(v))
			end
			self:set_image(string.format("img_cargo_%d", iterator),string.format("img_cargo%d", i))

			if(v == 0)then--this ensures images from previous viewings of the screen are blanked if they have no corresponding cargo amount this time
				self:set_image(string.format("img_cargo_%d", iterator), "")
			end

			iterator = iterator + 1

		end
	end

	self:set_text_raw("str_cargo_val", cargoText)

	--local plansList = ""
	if self.plans and #self.plans > 0 then
		for i,v in pairs(self.plans) do
			LOG(string.format("Added plan %s to plansList", tostring(v)))
			local widget_name = string.format("str_plans_val_%d",i)
			local planString = translate_text(string.format("[%s_NAME]", tostring(v)))

			local max_width = self:get_widget_w(widget_name)
			planString = fit_text_to("font_info_white", planString, max_width)

			self:set_font(widget_name, "font_info_white")
			self:set_text_raw(widget_name,planString)
		end
		--self:set_font("str_plans_val", "font_info_white")
	else
		self:set_font("str_plans_val_1", "font_info_gray")

		--BEGIN_STRIP_DS
		WiiOnly(self.set_font, self, "str_plans_val_1", "font_info_white")
		--END_STRIP_DS

		self:set_text("str_plans_val_1", "[NONE]")
	end


	if self.faction then
		local enemyFaction = _G.DATA.Factions[self.faction.id].enemy
		self:set_image("icon_faction_loss", _G.DATA.Factions[statHero:GetFactionData(self.faction.id)].icon)
		self:set_text("str_faction_loss_name", string.format(_G.DATA.Factions[statHero:GetFactionData(self.faction.id)].name,"NAME"))
		self:set_text_raw("str_faction_loss_amt", "-"..tostring(self.faction.amount))

		self:activate_widget("icon_faction_loss")
		self:activate_widget("str_faction_loss_name")
		self:activate_widget("str_faction_loss_amt")
		if self.faction.enemy then
			self:set_image("icon_faction_gain", _G.DATA.Factions[enemyFaction].icon)
			self:set_text("str_faction_gain_name", string.format(_G.DATA.Factions[enemyFaction].name,"NAME"))
			self:set_text_raw("str_faction_gain_amt", "+"..tostring(self.faction.amount))

			self:activate_widget("icon_faction_gain")
			self:activate_widget("str_faction_gain_name")
			self:activate_widget("str_faction_gain_amt")
		else
			self:hide_widget("icon_faction_gain")
			self:hide_widget("str_faction_gain_name")
			self:hide_widget("str_faction_gain_amt")
		end
	else
		self:hide_widget("icon_faction_loss")
		self:hide_widget("str_faction_loss_name")
		self:hide_widget("str_faction_loss_amt")
		self:hide_widget("icon_faction_gain")
		self:hide_widget("str_faction_gain_name")
		self:hide_widget("str_faction_gain_amt")
	end

end

function CombatResultsMenu:OnButton(buttonId, clickX, clickY)


	local function UnloadGraphics()
		UnloadAssetGroup("AssetsInsignias")
	end

	if not self.clicked then
		if buttonId == 1 then
			self.clicked = true
			self.callback(false, UnloadGraphics)
			local function transition()
			end
			CallScreenSequencer("CombatResultsMenu", UnloadGraphics)
			local sourceMenu = SCREENS.GameMenu.sourceMenu
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, sourceMenu)
		elseif buttonId == 0 then
			self.clicked = true
			self.callback(false)
			local function transition()
			end
			CallScreenSequencer("CombatResultsMenu", UnloadGraphics)
			local sourceMenu = SCREENS.GameMenu.sourceMenu
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, sourceMenu)
		elseif buttonId == 2 then
			self.clicked = true
			self.callback(true)
			local function transition()
			end
			CallScreenSequencer("CombatResultsMenu", UnloadGraphics)
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "GameMenu")
		end

	end


	return Menu.MESSAGE_HANDLED
end

dofile("Assets/Scripts/Screens/CombatResultsMenuPlatform.lua")

-- return an instance of CombatResultsMenu
return ExportSingleInstance("CombatResultsMenu")
