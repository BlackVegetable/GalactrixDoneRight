
-------------------------------------------------------------------------------
--    InitHackingUI  -- inits the UI for the hacking game
--    gamemenu - the name of the gamemenu in use
-------------------------------------------------------------------------------

function InitHackingUI()
	LOG("init hacking gameUI()")
	local menu = SCREENS.GameMenu
	
	for i=1,5 do
		local gemStr = string.format("icon_gem_%d",i)
		LOG("NumGems = " .. #menu.world.sequence)
		if menu.world.sequence[_G.Hero:GetAttribute("seq_pos")+(i-1)] then
			menu:activate_widget("icon_gem_"..i)
			LOG("Setting gem " .. i .. " to " .. string.format("%s%s", "img_hack_", GEMS[menu.world.sequence[_G.Hero:GetAttribute("seq_pos")+(i-1)]].color))
			menu:set_image("icon_gem_"..i, string.format("%s%s", "img_hack_", GEMS[menu.world.sequence[_G.Hero:GetAttribute("seq_pos")+(i-1)]].color))
		else
			menu:hide_widget(gemStr)
		end
	end
	menu:set_text_raw("str_gem_count",string.format("%d/%d", _G.Hero:GetAttribute("seq_pos")-1, #menu.world.sequence))
	
	menu:set_image("icon_player_1", string.format("%s_B",CREW["C002"].portrait))
	menu:set_text("str_player_name_1", translate_text(CREW["C002"].name))
	menu.update_sequence = true
	
	menu.uiInited = true

	return true
end


return InitHackingUI