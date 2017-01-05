local function SetCraftingPortrait()
	if CollectionContainsAttribute(_G.Hero, "crew", "C001") then
      SCREENS.GameMenu:set_image("icon_player_1", string.format("%s_B",CREW["C001"].portrait))
		SCREENS.GameMenu:set_text("str_player_name_1", translate_text(CREW["C001"].name))
	elseif CollectionContainsAttribute(_G.Hero, "crew", "C000") then
		SCREENS.GameMenu:set_image("icon_player_1", string.format("%s_B",CREW["C000"].portrait))
		SCREENS.GameMenu:set_text("str_player_name_1", translate_text(CREW["C000"].name))	
	elseif CollectionContainsAttribute(_G.Hero, "crew", "C006") then
		SCREENS.GameMenu:set_image("icon_player_1", string.format("%s_B",_G.Hero:GetAttribute("portrait")))
		SCREENS.GameMenu:set_text("str_player_name_1",_G.Hero:GetAttribute("name"))
	else
		SCREENS.GameMenu:set_image("icon_player_1", string.format("%s_B",CREW["C000"].portrait))
		SCREENS.GameMenu:set_text("str_player_name_1", translate_text(CREW["C000"].name))		
	end

end

return SetCraftingPortrait
