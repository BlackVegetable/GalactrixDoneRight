-- I153 - Trident Special
-- Neptune Cannon - Removes all Blue and Red Gems from play, +1 point of damage to the Enemy for every 2 removed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GSHD")
	gemList = world:GetGemList("GWEA", gemList)

	item:DamagePlayer(player, world:GetEnemy(player), math.floor((#gemList)/2), false, "RedPath")
	item:ClearGems(world, gemList)
end

local function should_ai_use_item(item, world, player)
	local gemList = world:GetGemList("GWEA")
	gemList = world:GetGemList("GSHD", gemList)
	local weight = math.random(1,100)

	if #gemList < 6 then
		weight = 0
	else
		weight = weight + ((#gemList - 8) * 4)
	end

	if weight < 0 then
		weight = 0
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 9;
	engine_requirement = 2;
	cpu_requirement = 0;
	recharge = 4;
	rarity = 10;
	cost = 17400;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_bomb";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
