-- I031
-- A.I. Transformer - Converts all yellow gems into green gems.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GENG")
	item:TransformGems(world, gemList, true, "GCPU")
end

local function should_ai_use_item(item, world, player)


	local cpu_need = -2
	local engine_need = -10
	local ship = player:GetAttribute("curr_ship")
	local weight = 0

	if ship:NumAttributes("battle_items") >= 1 then
		for i=1,ship:NumAttributes("battle_items") do
			weapon_need = cpu_need + ship:GetAttributeAt("battle_items", i):GetAttribute("cpu_requirement")
			engine_need = engine_need + ship:GetAttributeAt("battle_items", i):GetAttribute("engine_requirement")
		end
	end

	if engine_need > (cpu_need + 5) then
		weight = math.random (1,55)
	elseif engine_need < (cpu_need - 5) then
		weight = math.random (1,100)
	else
		weight = math.random (1,80)
	end

	local gemList = world:GetGemList("GENG")
	if #gemList < 4 then
		weight = 0
	else
		weight = weight + (#gemList * 2)
	end

	if player:GetAttribute("cpu") >= (player:GetAttribute("cpu_max") - 1) then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IEC4";
	weapon_requirement = 0;
	engine_requirement = 10;
	cpu_requirement = 2;
	recharge = 3;
	rarity = 5;
	cost = 3200;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
