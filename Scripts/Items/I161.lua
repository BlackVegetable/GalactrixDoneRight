-- I161 - Keck Special
-- Keck Shell - removes all blue gems and maxes all colored energy

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GSHD")
	item:ClearGems(world, gemList)

	-- Balance Mod Edit --
	item:AwardEnergy(world, player, "weapon", player:GetAttribute("weapon_max"))
	item:AwardEnergy(world, player, "engine", player:GetAttribute("engine_max"))
	item:AwardEnergy(world, player, "cpu", player:GetAttribute("cpu_max"))


	item:AwardEnergy(world, player, "weapon", -8)
	item:AwardEnergy(world, player, "engine", -8)
	item:AwardEnergy(world, player, "cpu", -8)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	if player:GetAttribute("weapon") > (player:GetAttribute("weapon_max") - 8) then
		weight = weight - 34
	end
	if player:GetAttribute("engine") > (player:GetAttribute("engine_max") - 8) then
		weight = weight - 33
	end
	if player:GetAttribute("cpu") > (player:GetAttribute("cpu_max") - 8) then
		weight = weight - 33
	end

	if weight < 0 then
		weight = 0
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 0;
	engine_requirement = 8;
	cpu_requirement = 9;
	recharge = 6;
	rarity = 10;
	cost = 17200;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_capacitor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
