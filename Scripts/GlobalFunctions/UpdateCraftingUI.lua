
-------------------------------------------------------------------------------
--    UpdateCraftingUI  -- only used for hacking mini game
-------------------------------------------------------------------------------
function UpdateCraftingUI()
	local menu = SCREENS.GameMenu
	
	assert(menu.world, "no world")
	local player = menu.world:GetCurrPlayer()
	if player:GetAttribute("components_weap_max") > 0 then	
		menu:set_text(string.format("str_cargo_count_%d",menu.craftUIMap["components_weap"]),   tostring(player:GetAttribute("components_weap")))
	end
	if player:GetAttribute("components_eng_max") > 0 then
		menu:set_text(string.format("str_cargo_count_%d",menu.craftUIMap["components_eng"]),   tostring(player:GetAttribute("components_eng")))
	end
	if player:GetAttribute("components_cpu_max") > 0 then
		menu:set_text(string.format("str_cargo_count_%d",menu.craftUIMap["components_cpu"]),   tostring(player:GetAttribute("components_cpu")))
	end
	
	return true
end


return UpdateCraftingUI