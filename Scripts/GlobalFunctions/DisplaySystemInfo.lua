

local function DisplaySystemInfo(star,menu)
	local faction = _G.Hero:GetFactionData(star:GetFaction())
	menu:set_text_raw("str_systemname",translate_text(string.format("[%s_NAME]", star.classIDStr)))
	menu:set_text_raw("str_systemtech",string.format("%s %s", translate_text("[TECH_]"), translate_text(tostring(star:GetTechLevel()))))
	menu:set_text_raw("str_systemgov",translate_text(_G.DATA.Governments[star:GetGovernment()].name))
	menu:set_text_raw("str_systempurpose",translate_text(_G.DATA.Industries[star:GetIndustry()].name))
	menu:set_text("str_systemfaction",string.format(_G.DATA.Factions[faction].name,"NAME"))

	menu:set_image("icon_insignia",_G.DATA.Factions[faction].icon)
		LOG("DisplaySystemInfo SOLARSYSTEM SET " .. string.format("%s%s", _G.DATA.Factions[faction].system_bg, "_1"))
 	-- DS Platform only -- Map/SolarSystem Backdrop
   menu:set_image("icon_system_back_1", string.format("%s%s", _G.DATA.Factions[faction].system_bg, "_1"))
end

return DisplaySystemInfo