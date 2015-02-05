-- I113
-- Ultra Minelayer - Turns all lesser Mines into +3 Mines

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GDMG")
	item:TransformGems(world, gemList, true, "GDM3")
end

local function should_ai_use_item(item, world, player)

	local gemList = world:GetGemList("GDMG")
	local weight = math.random(1,100)
	if #gemList == 0 then
		weight = 0
	elseif #gemList == 1 then
		weight = weight - 40
	elseif #gemList == 2 then
		weight = weight - 20
	elseif #gemList > 7 then
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_IMN2";
	weapon_requirement = 0;
	engine_requirement = 1;
	cpu_requirement = 8;
	recharge = 3;
	rarity = 2;
	cost = 9000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
