
-------------------------------------------------------------------------------
--    UpdateUI  
-------------------------------------------------------------------------------

local icon_player_turn_1 = 2001
local icon_player_turn_2 = 2002
local icon_turnlight_1 = 2003
local icon_turnlight_2 = 2004
	

function UpdateUI()
	local menu = SCREENS.GameMenu
	local curr_turn = menu.world:GetAttribute('curr_turn')
    local num_turns = menu.world.turn.turns
    
	local update_effects = false
	menu.effect_counter = menu.effect_counter + 1
	if menu.effect_counter == 2 then
		menu.effect_alpha = 0.7
		update_effects = true
		--menu.effect_counters["bg"] = menu:UpdateEffects(world,menu.effect_counters["bg"],"bg_effects")

		menu:set_alpha("icon_bg_effects",menu.effect_alpha)	
	elseif menu.effect_counter > 2 then
		--update_effects = true
		menu.effect_alpha = 1
		menu.effect_counter = 0	
		menu.effect_counters["bg"] = menu:UpdateEffects(menu.world,menu.effect_counters["bg"],"bg_effects")

		menu:set_alpha("icon_bg_effects",menu.effect_alpha)	
	end
	
	_G.GLOBAL_FUNCTIONS["UpdateTimer"]()
	
	
    --update Player Stats
    for i=1, menu.world:NumAttributes('Players') do
    	
		local player = menu.world:GetAttributeAt('Players',i)     
		 
		--If turn belongs to this player
		if i == curr_turn then
			--menu:set_text_raw("str_turns_"..i,tostring(num_turns))
			menu:set_alpha("player_turn_1", 0)
			menu:set_alpha("player_turn_2", 1)
		else
			menu:set_alpha("player_turn_1", 1)
			menu:set_alpha("player_turn_2", 0)
		end
		
		menu:UpdateEnergyUI(player)		  
    	menu:UpdateItemsUI(player)

		if update_effects == true then
			menu.effect_counters[i] = menu:UpdateEffects(player,menu.effect_counters[i],"player_effects_"..tostring(i))	
		end
		menu:set_alpha("icon_player_effects_"..tostring(i),menu.effect_alpha)		
    end
	
	return true

end


return UpdateUI