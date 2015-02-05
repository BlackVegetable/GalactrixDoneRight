
-------------------------------------------------------------------------------
--    UpdateMiningUI  -- only used for mining mini game
-------------------------------------------------------------------------------
function UpdateMiningUI()
	local menu = SCREENS.GameMenu
	
    local curr_turn = menu.world:GetAttribute('curr_turn')
    local num_turns = menu.world.turn.turns
    
	if menu.world.state~=STATE_GAME_OVER  and menu.world:NumAttributes("Players") == 1 then
		local player = menu.world:GetAttributeAt('Players',1)  	
	    --update Player Stats
	    for i,v in pairs(menu.world.cargo) do
	    	LOG(string.format("set str_cargo_count_%d -> %s to %d",i,_G.DATA.Cargo[v.cargo].effect,player:GetAttribute(_G.DATA.Cargo[v.cargo].effect)))
	    	menu:set_text_raw(string.format("str_cargo_count_%d",i),tostring(player:GetAttribute(_G.DATA.Cargo[v.cargo].effect)))
	
	    end
    end
	
	return true
end


return UpdateMiningUI