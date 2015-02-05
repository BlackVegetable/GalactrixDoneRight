-- I149
-- Doomsday Bomb - All gems on the board are removed and new gems fall in to replace them.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--[[
	local gemList = {}
	for i =1,55 do
		table.insert(gemList, i)
	end

	item:ClearGems(world, gemList, false)
	]]--
	item:ResetBoard(world)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,70)

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IWM2";
	weapon_requirement = 15;
	engine_requirement = 5;
	cpu_requirement = 5;
	recharge = 6;
	rarity = 1;
	cost = 13400;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_bomb";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
