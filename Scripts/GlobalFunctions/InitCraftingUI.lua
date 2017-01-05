
-------------------------------------------------------------------------------
--    InitCraftingUI  -- inits the UI for the crafting game
--    gamemenu - the name of the gamemenu in use
-------------------------------------------------------------------------------


function InitCraftingUI()
	local menu = SCREENS.GameMenu
	
	LOG("init crafting gameUI()")
	local player = menu.world:GetCurrPlayer()

	menu:set_text("str_heading", "[CRAFT_ITEM]")		
	
	local ui_counter = 1
	menu.craftUIMap = {["components_weap"]=0,["components_eng"]=0,["components_cpu"]=0}

	if player:GetAttribute("components_weap_max") > 0 then
		menu:set_text(string.format("str_cargo_count_%d",ui_counter), tostring(player:GetAttribute("components_weap")))
		menu:set_text(string.format("str_cargo_max_%d",ui_counter),   string.format("/%d",player:GetAttribute("components_weap_max")))
		menu:set_image(string.format("icon_cargo_%d",ui_counter),     "img_StatWep")
		menu.craftUIMap["components_weap"]=ui_counter
		ui_counter = ui_counter + 1
	end
	
	if player:GetAttribute("components_eng_max") > 0 then
		menu:set_text(string.format("str_cargo_count_%d",ui_counter), tostring(player:GetAttribute("components_eng")))
		menu:set_text(string.format("str_cargo_max_%d",ui_counter),   string.format("/%d", player:GetAttribute("components_eng_max")))
		menu:set_image(string.format("icon_cargo_%d",ui_counter),     "img_StatEng")
		menu.craftUIMap["components_eng"]=ui_counter
		ui_counter = ui_counter + 1
	end
	
	if player:GetAttribute("components_cpu_max") > 0 then
		menu:set_text(string.format("str_cargo_count_%d",ui_counter), tostring(player:GetAttribute("components_cpu")))
		menu:set_text(string.format("str_cargo_max_%d",ui_counter),   string.format("/%d", player:GetAttribute("components_cpu_max")))
		menu:set_image(string.format("icon_cargo_%d",ui_counter),     "img_StatSci")
		menu.craftUIMap["components_cpu"]=ui_counter
	end
	
	local ship = player:GetAttribute("curr_ship")

	menu:set_text("str_itemname", string.format("[%s_NAME]", menu.world.item))
	
		-- Set player/ship name on the UI
	--menu:InitPlayerName(player, ship, 1)
      
   --SetCraftingPortrait()
   local callback = dofile("Assets/Scripts/GlobalFunctions/InitCraftingUIPlatform.lua")
   callback()
	menu.uiInited = true
	
	return true
end


return InitCraftingUI