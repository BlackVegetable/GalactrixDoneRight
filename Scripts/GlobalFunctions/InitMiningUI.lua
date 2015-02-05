
-------------------------------------------------------------------------------
--    InitMiningUI  -- inits the UI for the mining game
--    gamemenu - the name of the gamemenu in use
-------------------------------------------------------------------------------

function InitMiningUI()
	LOG("init mining gameUI()")
	local menu = SCREENS.GameMenu
	
	--LoadAssetGroup("AssetsInventory")
	--LoadAssetGroup("AssetsUI")
	
	if menu.world:NumAttributes("Players") == 1 then
	
		
		for i,v in pairs(menu.world.cargo) do
			--LOG(string.format("%d = %d",i,v.cargo))
			local base_cargo = "img_cargo_big_"
			--if _G.GetScreenWidth()==256 then
				--base_cargo = "img_cargo"
			--end			
				
			menu:set_text_raw(string.format("str_cargo_max_%d",i),string.format("/%d",v.min))
			menu:set_text_raw(string.format("str_cargo_count_%d",i), "0")
			menu:set_image(string.format("icon_cargo_%d",i),string.format("%s%d",base_cargo,v.cargo))
		end			
	end
	
	menu:set_image("icon_backdrop_top", "img_backdrop_mining")
	
	menu:set_image("icon_player_1", string.format("%s_B",CREW["C003"].portrait))
	menu:set_text_raw("str_player_name_1", translate_text(CREW["C003"].name))
	
	menu:set_text("str_heading", translate_text("[MINE_ASTD]"))
	
	menu.uiInited = true
	
	return true
end


return InitMiningUI