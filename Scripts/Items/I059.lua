-- I059
-- Multiphasic Beam - Halves all enemy energy (excluding Shields)

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	local amt = math.ceil(enemy:GetAttribute("weapon")/2)
	item:DeductEnergy(world, enemy, "weapon", amt)
	amt = math.ceil(enemy:GetAttribute("cpu")/2)
	item:DeductEnergy(world, enemy, "cpu", amt)
	amt = math.ceil(enemy:GetAttribute("engine")/2)
	item:DeductEnergy(world, enemy, "engine", amt)
end

local function should_ai_use_item(item, world, player)

	local enemy = world:GetEnemy(player)

	dropRed = enemy:GetAttribute("weapon") - math.ceil(enemy:GetAttribute("weapon")/2)
	RedPercent = (dropRed / enemy:GetAttribute("weapon_max"))
	dropGreen = enemy:GetAttribute("cpu") - math.ceil(enemy:GetAttribute("cpu")/2)
	GreenPercent = (dropGreen / enemy:GetAttribute("cpu_max"))
	dropYellow = enemy:GetAttribute("engine") - math.ceil(enemy:GetAttribute("engine")/2)
	YellowPercent = (dropYellow / enemy:GetAttribute("engine_max"))

	local weight = math.random(10,109)

	weight = weight - 60 + math.ceil(RedPercent * 90) + math.ceil(GreenPercent * 75) + math.ceil(YellowPercent * 75)

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IWM2";
	weapon_requirement = 6;
	engine_requirement = 6;
	cpu_requirement = 6;
	recharge = 3;
	rarity = 3;
	cost = 3450;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
