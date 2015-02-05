-- I109
-- Robotic Minelayer - Turns all Yellow Gems into +1 Mines

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GENG")
	item:TransformGems(world, gemList, false, "GDMG")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,90)
	local gemListY = world:GetGemList("GENG")
	local gemList = world:GetGemList("GDMG", gemList)
	gemList = world:GetGemList("GDM3", gemList)
	gemList = world:GetGemList("GDM5", gemList)
	gemList = world:GetGemList("GDMX", gemList)

	if #gemListY <= 2 then
		weight = 0
	else
		weight = weight + (#gemListY * 5) + (#gemList * 3)
	end

	return weight




end

return {  psi_requirement = 0;


	icon = "img_IMN1";
	weapon_requirement = 0;
	engine_requirement = 8;
	cpu_requirement = 2;
	recharge = 3;
	rarity = 2;
	cost = 6890;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
