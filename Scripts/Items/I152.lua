-- I152 - CyTech Special
-- Cy-Tech Assimilator - Changes all green and red gems into yellow gems

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GWEA")
	gemList = world:GetGemList("GCPU", gemList)

	item:TransformGems(world, gemList, true, "GENG")
end

local function should_ai_use_item(item, world, player)
	local gemList = world:GetGemList("GWEA")
	gemList = world:GetGemList("GCPU", gemList)
	local gemListE = world:GetGemList("GENG")
	local weight = math.random(1,90)

	if #gemList < 6 then
		weight = 0
	else
		weight = weight + ((#gemList - 6) * 3) + ((#gemListE - 3) * 2)
	end

	if weight < 0 then
		weight = 0
	end

	return weight



end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 7;
	engine_requirement = 0;
	cpu_requirement = 7;
	recharge = 5;
	rarity = 10;
	cost = 18800;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
