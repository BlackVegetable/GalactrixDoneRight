-- I115
-- Giga Minelayer - Turns all Mines into +10 Mines

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GDMG")
	gemList = world:GetGemList("GDM3", gemList)
	gemList = world:GetGemList("GDM5", gemList)
	item:TransformGems(world, gemList, true, "GDMX")
end

local function should_ai_use_item(item, world, player)

	local gemList = world:GetGemList("GDMG")
	gemList = world:GetGemList("GDM3", gemList)
	gemList = world:GetGemList("GDM5", gemList)
	local weight = math.random(1,100)
	if #gemList == 0 then
		weight = 0
	elseif #gemList == 1 then
		weight = weight - 40
	elseif #gemList == 2 then
		weight = weight - 20
	elseif #gemList == 3 then
		weight = weight - 10
	elseif #gemList > 8 then
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IMN2";
	weapon_requirement = 5;
	engine_requirement = 8;
	cpu_requirement = 16;
	recharge = 4;
	rarity = 2;
	cost = 18000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
