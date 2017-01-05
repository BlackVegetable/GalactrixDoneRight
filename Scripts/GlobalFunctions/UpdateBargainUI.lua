
-------------------------------------------------------------------------------
--    UpdateBargainUI  -- only used for bargain mini game
-------------------------------------------------------------------------------
function UpdateBargainUI()
	local menu = SCREENS.GameMenu
	
	local gemsLeft = 55-#menu.world:GetGemList("GHNL")
	menu:set_text_raw("str_gemcount", tostring(gemsLeft))
	local multiplier = _G.Hero:GetHaggleTable()[gemsLeft]
	if not multiplier then
		multiplier = 0
	else
		multiplier = 1 - multiplier
	end
	menu:set_text_raw("str_bonus", string.format("%.2f%s", multiplier*100,"%"))
	
	return true
end


return UpdateBargainUI