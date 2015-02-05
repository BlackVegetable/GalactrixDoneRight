
-------------------------------------------------------------------------------
--    UpdateHackingUI  -- only used for hacking mini game
-------------------------------------------------------------------------------
function UpdateHackingUI()

	local menu = SCREENS.GameMenu
	
	if menu.update_sequence then
		for i=1,5 do
			local gemStr = string.format("icon_gem_%d",i)
			if menu.world.sequence[_G.Hero:GetAttribute("seq_pos")+(i-1)] then
				menu:activate_widget("icon_gem_"..i)
				menu:set_image("icon_gem_"..i, string.format("%s%s", "img_hack_", GEMS[menu.world.sequence[_G.Hero:GetAttribute("seq_pos")+(i-1)]].color))
			else
				menu:hide_widget(gemStr)
			end
		end
		menu:set_text_raw("str_gem_count","")
		
		menu:set_text_raw("str_gem_count",string.format("%d/%d", _G.Hero:GetAttribute("seq_pos")-1, #menu.world.sequence))
		menu.update_sequence = false	
		menu:StartAnimation("ResetGems")		
	end
	--_G.GLOBAL_FUNCTIONS["UpdateTimer"]()
	
	return true
end


return UpdateHackingUI