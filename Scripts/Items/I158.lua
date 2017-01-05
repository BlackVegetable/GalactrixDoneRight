-- I158 - Jahrwoxi Special
-- Zapper - leeches a random energy type from the enemy ship to yours

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	local energyTable = { "weapon", "engine", "cpu" }
	local energyType = energyTable[world:MPRandom(1, 3)]
	local amount = world:GetEnemy(player):GetAttribute(energyType)
	LOG("Energy type = " .. tostring(energyType))

	item:DeductEnergy(world, enemy, energyType, amount)
	item:AwardEnergy(world, player, energyType, amount)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,110)
	local penalty = 0 -- Each will deduct 1/6 of the weight
	local deficit_red = player:GetAttribute("weapon_max") - player:GetAttribute("weapon")
	local enemy = world:GetEnemy(player)
	local Ered = enemy:GetAttribute("weapon")
	local deficit_green = player:GetAttribute("cpu_max") - player:GetAttribute("cpu")
	local Egreen = enemy:GetAttribute("cpu")
	local deficit_yellow = player:GetAttribute("engine_max") - player:GetAttribute("engine")
	local Eyellow = enemy:GetAttribute("engine")

	if deficit_red <= 5 then
		penalty = penalty + 1
	end
	if deficit_green <= 5 then
		penalty = penalty + 1
	end
	if deficit_yellow <= 5 then
		penalty = penalty + 1
	end

	if Ered <= 5 then
		penalty = penalty + 1
	end
	if Egreen <= 5 then
		penalty = penalty + 1
	end
	if Eyellow <= 5 then
		penalty = penalty + 1
	end

	if Ered >= 15 then
		weight = weight + 8
		if Ered >= 20 then
			weight = weight + 4
		end
	end

	if Egreen >= 15 then
		weight = weight + 7
		if Egreen >= 20 then
			weight = weight + 3
		end
	end

	if Eyellow >= 15 then
		weight = weight + 7
		if Eyellow >= 20 then
			weight = weight + 3
		end
	end

	if deficit_red <= Ered then
		weight = weight + 10
	elseif (deficit_red * 0.75) <= Ered then
		weight = weight - 1
	elseif (deficit_red * 0.4) <= Ered then
		weight = weight - 10
	end

	if deficit_green <= Egreen then
		weight = weight + 10
	elseif (deficit_green * 0.75) <= Egreen then
		weight = weight - 1
	elseif (deficit_green * 0.4) <= Egreen then
		weight = weight - 10
	end

	if deficit_yellow <= Eyellow then
		weight = weight + 10
	elseif (deficit_yellow * 0.75) <= Eyellow then
		weight = weight - 1
	elseif (deficit_yellow * 0.4) <= Eyellow then
		weight = weight - 10
	end

	weight = math.floor(weight * ((6 - penalty) / 6))

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 5;
	engine_requirement = 5;
	cpu_requirement = 5;
	recharge = 5;
	rarity = 10;
	cost = 13500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_drive";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
