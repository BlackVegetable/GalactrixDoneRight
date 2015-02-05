
local function OpenHeroPopup(hero, x, y, menuName, popupId)
	--LOG("Open hero popup")
	--[[
	local level    = hero:GetLevel()
	local intel    = hero:GetAttribute("intel")
	local psi      = hero:GetAttribute("psi")
	local gunnery  = hero:GetAttribute("gunnery")
	local pilot    = hero:GetAttribute("pilot")
	local engineer = hero:GetAttribute("engineer")
	local science  = hero:GetAttribute("science")
	]]--
	
	local strings  = { level = hero:GetLevel(), 
	                   intel = hero:GetAttribute("intel"), 
	                   psi = hero:GetAttribute("psi"),
					 }
--	local level    = hero:GetLevel()
--	local intel    = hero:GetAttribute("intel")
--	local psi      = hero:GetAttribute("psi")
	strings.gunnery = { title = translate_text("[GUNNERY]"), val = hero:GetCombatStat("gunnery"), font = "font_numbers_white" }
	if strings.gunnery.val < hero:GetAttribute("gunnery") then
		strings.gunnery.font = "font_numbers_red"
	elseif strings.gunnery.val > hero:GetAttribute("gunnery") then
		strings.gunnery.font = "font_numbers_green"
	end
	
	strings.pilot = { title = translate_text("[PILOT]"), val = hero:GetCombatStat("pilot"), font = "font_numbers_white" }
	if strings.pilot.val < hero:GetAttribute("pilot") then
		strings.pilot.font = "font_numbers_red"
	elseif strings.pilot.val > hero:GetAttribute("pilot") then
		strings.pilot.font = "font_numbers_green" 
	end
	
	strings.engineer = { title = translate_text("[ENGINEERING]"), val = hero:GetCombatStat("engineer"), font = "font_numbers_white" }
	if strings.engineer.val < hero:GetAttribute("engineer") then
		strings.engineer.font = "font_numbers_red"
	elseif strings.engineer.val > hero:GetAttribute("engineer") then
		strings.engineer.font = "font_numbers_green"
	end
	
	strings.science = { title = translate_text("[SCIENCE]"), val = hero:GetCombatStat("science"), font = "font_numbers_white" }
	if strings.science.val < hero:GetAttribute("science") then
		strings.science.font = "font_numbers_red"
	elseif strings.science.val > hero:GetAttribute("science") then
		strings.science.font = "font_numbers_green"
	end
	
	-- Bad programmer! No cake for you! (but Steve said to do it anyway)
	-- Special hack to trim german strings coz they're way too long
	if get_language() == 2 then -- german
		strings.gunnery.title = fit_text_to("font_info_red", strings.gunnery.title , 130)
		strings.pilot.title = fit_text_to("font_info_blue", strings.pilot.title , 130)
		strings.engineer.title = fit_text_to("font_info_yellow", strings.engineer.title , 130)
		strings.science.title = fit_text_to("font_info_green", strings.science.title , 130)
	end

	if menuName and popupId then
	
--		open_custompopup_menu("//TEXT/24/12/font_system//ICON/90/40/22/20//TEXT/117/40/font_info_white//ICON/90/67/22/20//TEXT/117/67/font_info_purple//TEXT/30/95/font_info_blue//ICON/35/120/27/24//TEXT/67/115/"..strings.pilot.font.."//TEXT/30/150/font_info_yellow//ICON/35/175/27/24//TEXT/67/175/"..strings.engineer.font.."//TEXT/160/95/font_info_red//ICON/165/120/27/24//TEXT/195/120/"..strings.gunnery.font.."//TEXT/160/150/font_info_green//ICON/165/175/27/24//TEXT/195/175/"..strings.science.font.."//BORDER/74/113/170/255//",
--		                      string.format("//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//", string.format("%s %d", translate_text("[LEVEL_]"), strings.level), "img_white_gem", substitute(translate_text("[INTEL_]"), strings.intel), "img_purple_gem", substitute(translate_text("[PSI_]"), strings.psi), translate_text("[PILOT]"), "img_blue_gem", tostring(strings.pilot.val), translate_text("[ENGINEERING]"), "img_yellow_gem", tostring(strings.engineer.val), translate_text("[GUNNERY]"), "img_red_gem", tostring(strings.gunnery.val), translate_text("[SCIENCE]"), "img_green_gem", tostring(strings.science.val)),
--							  x, y, 1, 260, menuName, popupId)

--							"//TEXT/29/12/font_info_white//ICON/72/49/22/20//TEXT/100/49/font_info_white//ICON/72/76/24/21//TEXT/102/79/font_info_purple//",
--		                    string.format("//%s//%s//%s//%s//%s//", string.format("%s %d", translate_text("[LEVEL_]"), level), "img_white_gem", substitute(translate_text("[INTEL_]"), intel), "img_purple_gem", substitute(translate_text("[PSI_]"), psi)),
--							  x, y, 1, 260)
	else
		open_custompopup_menu(string.format("%s%s%s%s%s%s%s%s%s", "//TEXT/24/12/font_system//ICON/90/46/22/20//TEXT/117/40/font_info_white//ICON/90/73/22/20//TEXT/117/67/font_info_purple//TEXT/30/95/font_info_blue//ICON/27/120/38/34//TEXT/67/112/", strings.pilot.font, "//TEXT/30/160/font_info_yellow//ICON/27/185/38/34//TEXT/67/177/", strings.engineer.font, "//TEXT/160/95/font_info_red//ICON/157/120/38/34//TEXT/195/112/", strings.gunnery.font, "//TEXT/160/160/font_info_green//ICON/157/185/38/34//TEXT/195/177/", strings.science.font, "//BORDER/74/113/170/255//"),
		                      string.format("//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//%s//", string.format("%s %d", translate_text("[LEVEL_]"), strings.level), "img_white_gem", substitute(translate_text("[INTEL_]"), strings.intel), "img_purple_gem", substitute(translate_text("[PSI_]"), strings.psi), strings.pilot.title, "img_blue_gem", tostring(strings.pilot.val), strings.engineer.title, "img_yellow_gem", tostring(strings.engineer.val), strings.gunnery.title, "img_red_gem", tostring(strings.gunnery.val), strings.science.title, "img_green_gem", tostring(strings.science.val)),
							  x, y, 1, 260)
	end
end

return OpenHeroPopup
