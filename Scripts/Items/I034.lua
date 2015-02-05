-- I034
-- Landing Rockets - Randomly adds 4 yellow gems to the board +1 more for each 15 points of Engineering Skill you have (maximum of +10).

local function activate(item, world, player, obj,weapon,engine,cpu)
	local numGems = 4
	numGems = numGems + math.min(math.floor(player:GetCombatStat("engineer")/15),10)
	local gemList = item:GetRandomGems(numGems, "GENG", world)

	item:TransformGems(world, gemList, true, "GENG")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,90)

	weight = weight - 10 + (math.floor(player:GetAttribute("engineer") / 15) * 5)

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IT5";
	weapon_requirement = 0;
	engine_requirement = 5;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 8;
	cost = 660;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
