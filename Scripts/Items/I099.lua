-- I099
-- Mining Scoop - Destroys 6 random Gems.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = { world:MPRandom(1,9), world:MPRandom(10,19), world:MPRandom(20,29), world:MPRandom(30,39), world:MPRandom(40,49), world:MPRandom(50,55) }
	item:ClearGems(world, gemList, false)
end

local function should_ai_use_item(item, world, player)

	local gemList3 = world:GetGemList("GDM3")
	local gemList5 = world:GetGemList("GDM5")
	local gemListX = world:GetGemList("GDMX")

	local weight = math.random(1,75)

	local bonus = 0
	bonus = bonus + math.floor(#gemList3 * 0.5)
	bonus = bonus + (#gemList5 * 5)
	bonus = bonus + (#gemListX * 10)

	weight = weight + bonus

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IFT1";
	weapon_requirement = 0;
	engine_requirement = 6;
	cpu_requirement = 0;
	recharge = 4;
	rarity = 8;
	cost = 600;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
