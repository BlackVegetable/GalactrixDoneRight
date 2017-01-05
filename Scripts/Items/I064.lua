-- I064
-- Mini Cluster Bomb - All +1 Mines on the board explode destroying the gems surrounding them.  You gain full effect for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GDMG")
	--item:ExplodeGem(world, gemList, true)
	item:ClearGems(world, item:GetAdjacentGems(world, gemList), true, true)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local gemList = world:GetGemList("GDMG")
	if #gemList == 0 then
		weight = 0
	else
		weight = weight - 25 + (#gemList * 10)
	end

	if weight < 0 then
		weight = 0
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_IMN2";
	weapon_requirement = 12;
	engine_requirement = 2;
	cpu_requirement = 2;
	recharge = 5;
	rarity = 3;
	cost = 12800;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_bomb";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
