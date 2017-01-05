-- I080
-- Point Disruptor - Adds +4 turns to the recharge time of a random enemy item.  Adds 1 more item for each 50 points in your Gunnery Skill.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local numItems = 1 + math.floor(player:GetCombatStat("gunnery")/50)
	local enemyShip = world:GetEnemy(player):GetAttribute("curr_ship")
	if enemyShip:NumAttributes("battle_items") <= numItems then
		for i=1,enemyShip:NumAttributes("battle_items") do
			enemyShip:GetAttributeAt("battle_items", i):AddRecharge(4)
		end
	else
		local indexTable = { }
		for i=1,enemyShip:NumAttributes("battle_items") do
			table.insert(indexTable, i)
		end

		while #indexTable > numItems do
			table.remove(indexTable, world:MPRandom(1, #indexTable))
		end
		--[[
		local indexTable = { }
		while #indexTable < numItems do
			local index = world:MPRandom(1, enemyShip:NumAttributes("battle_items"))
			local indexFound = false
			for i,v in pairs(indexTable) do
				if v == index then
					indexFound = true
				end
			end
			if not indexFound then
				table.insert(indexTable, index)
			else
				indexFound = false
			end
		end
		]]--
		for i,v in pairs(indexTable) do
			enemyShip:GetAttributeAt("battle_items", v):AddRecharge(4)
		end
	end
end

local function should_ai_use_item(item, world, player)

	local enemyShip = world:GetEnemy(player):GetAttribute("curr_ship")
	local weight = math.random(1,100)
	if enemyShip:NumAttributes("battle_items") <= 3 then
		weight = weight + 5
	end
	weight = weight + (7 * math.floor(player:GetCombatStat("gunnery") / 50))

	if enemyShip:NumAttributes("battle_items") == 0 then
		weight = 0
	end



	return weight

end

return {  psi_requirement = 0;


	icon = "img_ITS1";
	weapon_requirement = 6;
	engine_requirement = 3;
	cpu_requirement = 0;
	recharge = 4;
	rarity = 3;
	cost = 10780;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_disruptor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
