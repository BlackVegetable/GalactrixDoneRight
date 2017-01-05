-- I101
-- Regulon Field - Halves an enemy's shield

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	local amt = math.floor(enemy:GetAttribute("shield") / 2)
	item:DeductEnergy(world, enemy, "shield", amt)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local enemy = world:GetEnemy(player)
	local shield = enemy:GetAttribute("shield")
	local shield_max = enemy:GetAttribute("shield_max")

	if (shield / shield_max) == 1 then
		weight = weight + 20
	elseif (shield / shield_max) > 0.8 then
		weight = weight + 10
	elseif (shield / shield_max) > 0.5 then
		weight = weight
	elseif (shield / shield_max) > 0.2 then
		weight = weight - 12
	elseif (shield / shield_max) > 0 then
		weight = weight - 30
	else
		weight = 0
	end

	if shield > 60 then
		weight = weight + 12
	end

	if weight < 0 then
		weight = 0
	end

	return weight




end

return {  psi_requirement = 0;


	icon = "img_ITS3";
	weapon_requirement = 5;
	engine_requirement = 5;
	cpu_requirement = 0;
	recharge = 7;
	rarity = 3;
	cost = 7000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_shieldsdown";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
