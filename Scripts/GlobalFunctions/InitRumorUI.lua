
-------------------------------------------------------------------------------
--    InitRumorUI  -- inits the UI for the rumor game
--    gamemenu - the name of the gamemenu in use
-------------------------------------------------------------------------------

function InitRumorUI()
	LOG("init rumor gameUI()")
	local menu = SCREENS.GameMenu
	
	menu:set_image("icon_player_1", string.format("%s_B",CREW["C006"].portrait))
	menu:set_text_raw("str_player_name_1", translate_text(CREW["C006"].name))

	menu:set_text_raw("str_counter", tostring(menu.world.cost))
	
	menu.uiInited = true
	
	return true
end


return InitRumorUI