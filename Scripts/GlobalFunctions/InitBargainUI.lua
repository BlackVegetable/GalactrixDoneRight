
-------------------------------------------------------------------------------
--    InitBargainUI  -- inits the UI for the bargain game
--    gamemenu - the name of the gamemenu in use
-------------------------------------------------------------------------------

function InitBargainUI()
	LOG("init bargain gameUI()")
	local menu = SCREENS.GameMenu
	
	local player = menu.world:GetCurrPlayer()	
	
	menu:set_text_raw("str_gemcount", "55")--gems_clear
	menu:set_text_raw("str_bonus", "0.00%")--bonus val
	
	menu:set_image("icon_backdrop_top", "img_backdrop_haggling")

	menu:set_text("str_heading", "[BARGAIN_HEADING]")	
	
	menu:set_image("icon_player_1", string.format("%s_B",CREW["C004"].portrait))
	menu:set_text("str_player_name_1", translate_text(CREW["C004"].name))
	menu.uiInited = true
	
	return true
end


return InitBargainUI