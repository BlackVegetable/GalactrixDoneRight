-- I315 --
-- Precision Rockets -- Hits 1~3 times for 6 Damage each time, lowers enemy reserves of energy.

local function activate(item, world, player, obj,weapon,engine,cpu)

	local enemy = world:GetEnemy(player)
	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")
	local hits = 1
	local num

	if size == 3 then
		num = math.random()
		if num <= 0.8 then
			hits = 3
		elseif num <= 0.95 then
			hits = 2
		else
			hits = 1
		end
	elseif size == 4 then
		num = math.random()
		if num <= 0.5 then
			hits = 3
		elseif num <= 0.85 then
			hits = 2
		else
			hits = 1
		end
	elseif size == 5 then
		num = math.random()
		if num <= 0.1 then
			hits = 3
		elseif num <= 0.8 then
			hits = 2
		else
			hits = 1
		end
	elseif size >= 6 then
		num = math.random()
		if num <= 0.01 then
			hits = 3
		elseif num <= 0.05 then
			hits = 2
		else
			hits = 1
		end
	end

	for i=1,hits do
		num = math.random(1,3)
		if num == 1 then
			item:DamagePlayer(player, world:GetEnemy(player), 6, false, "RedPath")
			item:DeductEnergy(world, enemy, "weapon", 6)
		elseif num == 2 then
			item:DamagePlayer(player, world:GetEnemy(player), 6, false, "RedPath")
			item:DeductEnergy(world, enemy, "engine", 6)
		elseif num == 3 then
			item:DamagePlayer(player, world:GetEnemy(player), 6, false, "RedPath")
			item:DeductEnergy(world, enemy, "cpu", 6)
		end
	end

end

local function should_ai_use_item(item, world, player)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")
	local weight = math.random(1,65)

	if size == 3 then
		weight = weight + 35
	elseif size == 4 then
		weight = weight + 25
	elseif size == 5 then
		weight = weight + 10
	end


	return weight

end

return {
	psi_requirement = 0;

	icon = "img_IM3";
	weapon_requirement = 8;
	engine_requirement = 5;
	cpu_requirement = 0;
	recharge = 4;
	rarity = 1;
	cost = 6200;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_missile";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;

	}

