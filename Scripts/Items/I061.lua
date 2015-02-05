-- I061
-- EM Beam - Halves the Green Energy of your enemy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	local amt = math.ceil(enemy:GetAttribute("cpu")/2)
	item:DeductEnergy(world, enemy, "cpu", amt)
end

local function should_ai_use_item(item, world, player)

	local enemy = world:GetEnemy(player)
	local amt = math.ceil(enemy:GetAttribute("cpu")/2)
	local dropPercent = (amt / enemy:GetAttribute("cpu_max"))
	local weight = math.random(1,100)

	if amt < 8 then
		weight = weight - ((8 - amt) * 4)
	end

	weight = weight - 15 + (dropPercent * 60)

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IGT1";
	weapon_requirement = 2;
	engine_requirement = 0;
	cpu_requirement = 6;
	recharge = 3;
	rarity = 9;
	cost = 640;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
