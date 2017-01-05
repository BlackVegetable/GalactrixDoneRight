function InvStats:LoadGraphics()

end

function InvStats:UnloadGraphics()

end

function InvStats:HideWidgets()

end

function InvStats:ShowWidgets()

end

function InvStats:UpdateStats()
	self:set_text_raw("str_intel_left", substitute(translate_text("[SKILL_POINTS_LEFT_]"), self.hero:GetAttribute("stat_points")))

	for i=1,4 do
		local stat = self:GetStatName(i)
		self:hide_widget(string.format("img_frame%d_light", i))
		self:set_text_raw(string.format("str_%s",stat), string.format("%s %d", translate_text(string.format("[%s_]", string.upper(stat))), self.hero:GetAttribute(stat)))
		if self.hero:GetAttribute("stat_points") <= 0 or self.hero:GetAttribute(stat) >= 250 then
			self:activate_widget(string.format("img_frame%d_dark", i))
			self:deactivate_widget(string.format("pad_frame%d", i))
		else
			self:hide_widget(string.format("img_frame%d_dark", i))
			self:activate_widget(string.format("pad_frame%d", i))
		end
	end
end

function InvStats:GetStatName(id)
	if id == 1 then
		return "gunnery"
	elseif id == 2 then
		return "engineer"
	elseif id == 3 then
		return "science"
	elseif id == 4 then
		return "pilot"
	end
	return ""
end

function InvStats:OpenInfoPopup(x,y,id,stat)
	LOG("Opening popup")
	local lowStat = string.lower(stat)

	--local special
	--local specialNext
	local GunBonusDamage = math.floor(self.hero:GetAttribute('gunnery') / 50)
	local ScienceBonusCooldown = math.floor(self.hero:GetAttribute('science') / 75)
	local ScienceHackingBonus = _G.GLOBAL_FUNCTIONS.ScienceHackingBonus(self.hero:GetAttribute('science'))
	local EngineeringMiningBonus = _G.GLOBAL_FUNCTIONS.EngineeringMiningBonus(self.hero:GetAttribute('engineer'))
	local EngineeringRepairBonus = math.floor(self.hero:GetAttribute('engineer') / 25)
	if self.hero:GetAttribute('engineer') >= 245 then
		EngineeringRepairBonus = 10
	end


	local nextGunBonusDamage = math.floor((self.hero:GetAttribute('gunnery') + 1) / 50)
	local nextScienceBonusCooldown = math.floor((self.hero:GetAttribute('science') + 1) / 75)
	local nextScienceHackingBonus = _G.GLOBAL_FUNCTIONS.ScienceHackingBonus(self.hero:GetAttribute('science') + 1)
	local nextEngineeringRepairBonus = math.floor((self.hero:GetAttribute('engineer') + 1) / 25)
	local nextEngineeringMiningBonus = _G.GLOBAL_FUNCTIONS.EngineeringMiningBonus(self.hero:GetAttribute('engineer') + 1)
	if self.hero:GetAttribute('engineer') >= 244 then
		nextEngineeringRepairBonus = 10
	end


	local value = self.hero:GetAttribute(lowStat)
	local scales = { }
	local stringTable = { }

	if id == 4 then
		scales.max = 4
		scales.start = 3
		scales.gain = 0.6
	else
		scales.max = 2
		scales.start = 1
		scales.gain = 0.2
	end

	if id == 4 then
		stringTable = {
							statName = translate_text(string.format( "[%s]",stat)) ,
							stat  = string.format("%s %d", translate_text("[CURRENT_RANK_]"), value),
							stat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							stat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							stat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),

							nextStat  = string.format("%s %d", translate_text("[NEXT_RANK_]"), value+1),
							nextStat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							nextStat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							nextStat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat)))
						}

		if value == 250 then
			stringTable.nextStat = translate_text("[NEXT_RANK_]")
			stringTable.nextStat1 = translate_text("[MAX_LEVEL_REACHED]")
			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TITLE/141/font_info_blue//TITLE/179/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.nextStat, stringTable.nextStat1),
				x+92+(216*(id-1)), y+234, 1, 300)
		else
			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TITLE/141/font_info_blue//TEXT/3/179/font_info_white//TEXT/3/203/font_info_white//TEXT/3/227/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.nextStat, stringTable.nextStat1, stringTable.nextStat2, stringTable.nextStat3),
				x+92+(216*(id-1)), y+234, 1, 300)
		end
	end

	if id == 3 then
		stringTable = {
							statName = translate_text(string.format( "[%s]",stat)) ,
							stat  = string.format("%s %d", translate_text("[CURRENT_RANK_]"), value),
							stat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							stat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							stat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
							stat4 = string.format("+%d %s", ScienceBonusCooldown, translate_text(string.format("[%s_BONUS_3]", stat))),
							stat5 = string.format("+%d %s", ScienceHackingBonus, translate_text(string.format("[%s_BONUS_4]", stat))),

							nextStat  = string.format("%s %d", translate_text("[NEXT_RANK_]"), value+1),
							nextStat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							nextStat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							nextStat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
							nextStat4 = string.format("+%d %s", nextScienceBonusCooldown, translate_text(string.format("[%s_BONUS_3]", stat))),
							nextStat5 = string.format("+%d %s", nextScienceHackingBonus, translate_text(string.format("[%s_BONUS_4]", stat)))
						}

		if value == 250 then
			stringTable.nextStat = translate_text("[NEXT_RANK_]")
			stringTable.nextStat1 = translate_text("[MAX_LEVEL_REACHED]")
			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TEXT/3/141/font_info_white//TEXT/3/165/font_info_white//TITLE/203/font_info_blue//TITLE/227/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.stat4, stringTable.stat5, stringTable.nextStat, stringTable.nextStat1),
				x+92+(216*(id-1)), y+234, 1, 300)
		else
			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TEXT/3/141/font_info_white//TEXT/3/165/font_info_white//TITLE/203/font_info_blue//TEXT/3/227/font_info_white//TEXT/3/251/font_info_white//TEXT/3/275/font_info_white//TEXT/3/299/font_info_white//TEXT/3/323/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.stat4, stringTable.stat5, stringTable.nextStat, stringTable.nextStat1, stringTable.nextStat2, stringTable.nextStat3, stringTable.nextStat4, stringTable.nextStat5),
				x+92+(216*(id-1)), y+234, 1, 300)
		end
	end

	if id == 2 then
		stringTable = {
							statName = translate_text(string.format( "[%s]",stat)) ,
							stat  = string.format("%s %d", translate_text("[CURRENT_RANK_]"), value),
							stat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							stat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							stat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
							stat4 = string.format("+%d %s", EngineeringRepairBonus, translate_text(string.format("[%s_BONUS_3]", stat))),
							stat5 = string.format("+%d %s", EngineeringMiningBonus, translate_text(string.format("[%s_BONUS_4]", stat))),

							nextStat  = string.format("%s %d", translate_text("[NEXT_RANK_]"), value+1),
							nextStat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							nextStat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							nextStat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
							nextStat4 = string.format("+%d %s", nextEngineeringRepairBonus, translate_text(string.format("[%s_BONUS_3]", stat))),
							nextStat5 = string.format("+%d %s", nextEngineeringMiningBonus, translate_text(string.format("[%s_BONUS_4]", stat)))
						}

		if value == 250 then
			stringTable.nextStat = translate_text("[NEXT_RANK_]")
			stringTable.nextStat1 = translate_text("[MAX_LEVEL_REACHED]")
			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TEXT/3/141/font_info_white//TEXT/3/165/font_info_white//TITLE/203/font_info_blue//TITLE/227/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.stat4, stringTable.stat5, stringTable.nextStat, stringTable.nextStat1),
				x+92+(216*(id-1)), y+234, 1, 300)
		else
			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TEXT/3/141/font_info_white//TEXT/3/165/font_info_white//TITLE/203/font_info_blue//TEXT/3/227/font_info_white//TEXT/3/251/font_info_white//TEXT/3/275/font_info_white//TEXT/3/299/font_info_white//TEXT/3/323/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.stat4, stringTable.stat5, stringTable.nextStat, stringTable.nextStat1, stringTable.nextStat2, stringTable.nextStat3, stringTable.nextStat4, stringTable.nextStat5),
				x+92+(216*(id-1)), y+234, 1, 300)
		end
	end

	if id == 1 then
		stringTable = {
							statName = translate_text(string.format( "[%s]",stat)) ,
							stat  = string.format("%s %d", translate_text("[CURRENT_RANK_]"), value),
							stat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							stat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							stat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
							stat4 = string.format("+%d %s", GunBonusDamage, translate_text(string.format("[%s_BONUS_3]", stat))),

							nextStat  = string.format("%s %d", translate_text("[NEXT_RANK_]"), value+1),
							nextStat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
							nextStat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
							nextStat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
							nextStat4 = string.format("+%d %s", GunBonusDamage, translate_text(string.format("[%s_BONUS_3]", stat))),
						}

		if value == 250 then
			stringTable.nextStat = translate_text("[NEXT_RANK_]")
			stringTable.nextStat1 = translate_text("[MAX_LEVEL_REACHED]")
			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TEXT/3/141/font_info_white//TITLE/179/font_info_blue//TITLE/203/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.stat4, stringTable.nextStat, stringTable.nextStat1),
				x+92+(216*(id-1)), y+234, 1, 300)
		else
			open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TEXT/3/141/font_info_white//TITLE/179/font_info_blue//TEXT/3/203/font_info_white//TEXT/3/227/font_info_white//TEXT/3/251/font_info_white//TEXT/3/275/font_info_white//BORDER/50/150/255/255//",
				string.format("//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.stat4, stringTable.nextStat, stringTable.nextStat1, stringTable.nextStat2, stringTable.nextStat3, stringTable.nextStat4),
				x+92+(216*(id-1)), y+234, 1, 300)
		end
	end


end



--	stringTable = { --stat  = string.format("%s %d", translate_text(string.format("[%s]", stat)), value),
--	                      statName = translate_text(string.format("[%s]",stat)) ,
--	                      stat  = string.format("%s %d", translate_text("[CURRENT_RANK_]"), value),
--	                      stat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
--	                      stat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
--	                      stat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(value,scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat))),
--
--	                      --nextStat = string.format("%s %d (next)", translate_text(string.format("[%s]", stat)), value+1),
--	                      nextStat  = string.format("%s %d", translate_text("[NEXT_RANK_]"), value+1),
--	                      nextStat1 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.start)), translate_text(string.format("[%s_BONUS_0]", stat))),
--	                      nextStat2 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.max)),   translate_text(string.format("[%s_BONUS_1]", stat))),
--	                      nextStat3 = string.format("+%d %s", math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns((value+1),scales.gain)),  translate_text(string.format("[%s_BONUS_2]", stat)))
--	                    }
--
--	if value == 250 then
--		stringTable.nextStat = translate_text("[NEXT_RANK_]")
--		stringTable.nextStat1 = translate_text("[MAX_LEVEL_REACHED]")
--		open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TEXT/3/141/font_info_white//TITLE/179/font_info_blue//TITLE/203/font_info_white//BORDER/50/150/255/255//",
--			string.format("//%s//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3. stringTable.stat4, stringTable.nextStat, stringTable.nextStat1),
--			x+92+(216*(id-1)), y+234, 1, 300)
--	else
--		open_custompopup_menu("//TITLE/3/font_heading//TITLE/44/font_info_blue//TEXT/3/69/font_info_white//TEXT/3/93/font_info_white//TEXT/3/117/font_info_white//TEXT/3/141/font_info_white//TITLE/179/font_info_blue//TEXT/3/203/font_info_white//TEXT/3/227/font_info_white//TEXT/3/251/font_info_white//TEXT/3/275/font_info_white//BORDER/50/150/255/255//",
--			string.format("//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//", stringTable.statName, stringTable.stat, stringTable.stat1, stringTable.stat2, stringTable.stat3, stringTable.stat4, stringTable.nextStat, stringTable.nextStat1, stringTable.nextStat2, stringTable.nextStat3, stringTable.nextStat4),
--			x+92+(216*(id-1)), y+234, 1, 300)
--	end
--end

function InvStats:OnMouseLeave(id, x, y)
	LOG("OnMouseLeave")
	self:hide_widget(string.format("img_frame%d_light", id))
	close_custompopup_menu()
	return Menu.MESSAGE_HANDLED
end
