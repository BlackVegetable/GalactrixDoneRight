-- I136
-- Weapons Uplink - Converts all green gems into red gems.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GCPU")
	item:TransformGems(world, gemList, false, "GWEA")
end

local function should_ai_use_item(item, world, player)

	local gemListG = world:GetGemList("GCPU")
	local gemListR = world:GetGemList("GWEA")
	local weight = math.random(1,85)

	if #gemListG < 3 then
		weight = 0
	else
		weight = weight + ((#gemListG - 3) * 4) + ((#gemListR - 2) * 2)
	end

	if weight < 0 then
		weight = 0
	end

	return weight


end

return {  psi_requirement = 0;


	icon = "img_ICC1";
	weapon_requirement = 3;
	engine_requirement = 0;
	cpu_requirement = 8;
	recharge = 2;
	rarity = 4;
	cost = 5500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
