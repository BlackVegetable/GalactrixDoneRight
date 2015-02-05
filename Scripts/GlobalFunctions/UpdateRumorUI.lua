
-------------------------------------------------------------------------------
--    UpdateRumorUI  -- only used for rumor mini game
-------------------------------------------------------------------------------
function UpdateRumorUI()
	local menu = SCREENS.GameMenu
	
	--[[
	if menu.world.turn_count ~= 0 then
		menu:set_text("str_counter", tostring(menu.world.turns_remaining))
	else
		menu:set_text("str_counter", tostring(menu.world.turns_remaining))
	end
	--]]
	
	menu:set_text("str_counter", tostring(menu.world.turns_remaining))
	return true
end


return UpdateRumorUI