-- I094
-- Sabotage Drone - Randomly switches energy totals on your enemy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	local statTable = { }
	statTable[1] = "weapon"
	statTable[2] = "engine"
	statTable[3] = "cpu"

	local swap1 = world:MPRandom(1, #statTable)
	local swap1_val = statTable[swap1]
	table.remove(statTable, swap1)
	local swap2 = world:MPRandom(1, #statTable)
	local swap2_val = statTable[swap2]
	table.remove(statTable, swap2)
	local swap3 = world:MPRandom(1, #statTable)
	local swap3_val = statTable[swap3]
	table.remove(statTable, swap3)

	local temp1 = enemy:GetAttribute(swap2_val)
	enemy:SetAttribute(swap2_val, enemy:GetAttribute(swap1_val))
	local temp2 = enemy:GetAttribute(swap3_val)
	enemy:SetAttribute(swap3_val, temp1)
	enemy:SetAttribute(swap1_val, temp2)

	statTable[1] = "weapon"
	statTable[2] = "engine"
	statTable[3] = "cpu"
	local maxTable = {enemy:GetAttribute("weapon_max"),
				enemy:GetAttribute("engine_max"),
				enemy:GetAttribute("cpu_max")}


	for i=1,3 do
		if enemy:GetAttribute(statTable[i]) > maxTable[i] then
			enemy:SetAttribute(statTable[i], maxTable[i])
		end
		enemy:UpdateEffectGraphics(statTable[i],enemy:GetAttribute("player_id"),enemy:GetAttribute(statTable[i]),maxTable[i])
	end
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local enemy = world:GetEnemy(player)
	local red = enemy:GetAttribute("weapon")
	local yellow = enemy:GetAttribute("engine")
	local green = enemy:GetAttribute("cpu")

	local r_y = math.abs(red - yellow)
	local r_g = math.abs(red - green)
	local y_g = math.abs(yellow - green)

	local difference = 0

	if r_y > r_g then
		difference = r_y
		if r_y < y_g then
			difference = y_g
		end
	else
		difference = r_g
		if r_g < y_g then
			difference = y_g
		end
	end

	if difference < 4 then
		weight = 0
	elseif difference < 8 then
		weight = weight - 15
	elseif difference > 12 then
		weight = weight + 5
	end

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IUP1";
	weapon_requirement = 5;
	engine_requirement = 2;
	cpu_requirement = 2;
	recharge = 3;
	rarity = 2;
	cost = 2200;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_drone";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
