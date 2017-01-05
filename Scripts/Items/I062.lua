-- I062
-- Space Bomb - Causes an explosion on a random grid, destroying the gem there and all gems surrounding it.  You gain full effect for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--item:ExplodeGem(world, { world:MPRandom(1, 55) }, true)

	item:ClearGems(world, item:GetAdjacentGems(world, { world:MPRandom(1,55) }), true, true)
end

local function should_ai_use_item(item, world, player)

	local gemList3 = world:GetGemList("GDM3")
	local gemList5 = world:GetGemList("GDM5")
	local gemListX = world:GetGemList("GDMX")

	local weight = math.random(1,65)

	local bonus = 0
	bonus = bonus + math.floor(#gemList3 * 0.5)
	bonus = bonus + (#gemList5 * 5)
	bonus = bonus + (#gemListX * 10)

	weight = weight + bonus

	return weight





end

return {  psi_requirement = 0;


	icon = "img_IMN2";
	weapon_requirement = 9;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 0;
	rarity = 5;
	cost = 2450;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_bomb";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
