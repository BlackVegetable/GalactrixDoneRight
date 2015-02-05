-- I060
-- Darkmatter Beam - All enemy energy is reduced to zero (Shields at half)

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	local amt = enemy:GetAttribute("weapon")
	item:DeductEnergy(world, enemy, "weapon", amt)
	amt = enemy:GetAttribute("cpu")
	item:DeductEnergy(world, enemy, "cpu", amt)
	amt = enemy:GetAttribute("engine")
	item:DeductEnergy(world, enemy, "engine", amt)
	amt = enemy:GetAttribute("shield")
	item:DeductEnergy(world, enemy, "shield", math.ceil(amt * 0.50))
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local enemy = world:GetEnemy(player)
	weight = weight - 80 + ((enemy:GetAttribute("cpu") * 2.75) + (enemy:GetAttribute("engine") * 2.75) + (enemy:GetAttribute("weapon")) * 4) + (enemy:GetAttribute("shield") * 1.25)

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IGT4";
	weapon_requirement = 12;
	engine_requirement = 8;
	cpu_requirement = 8;
	recharge = 8;
	rarity = 1;
	cost = 18350;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
