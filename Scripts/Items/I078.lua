-- I078
-- Power Disruptor - Adds 3 turns to the Recharge time of the most powerful Item on the opponent ship (Item with the highest Energy cost).

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemyShip = world:GetEnemy(player):GetAttribute("curr_ship")
	local highestItem = {energy = 0}
	for i=1,enemyShip:NumAttributes("battle_items") do
		local enemyItem = enemyShip:GetAttributeAt("battle_items", i)
		local itemEnergy = enemyItem:GetAttribute("weapon_requirement") + enemyItem:GetAttribute("engine_requirement") + enemyItem:GetAttribute("cpu_requirement")
		if itemEnergy > highestItem.energy then
			highestItem.energy = itemEnergy
			highestItem.item = enemyItem
		end
	end
	if highestItem.item then
		highestItem.item:AddRecharge(3)
	end
end

local function should_ai_use_item(item, world, player)

	local enemyShip = world:GetEnemy(player):GetAttribute("curr_ship")
	local weight = math.random(1,100)
	if enemyShip:NumAttributes("battle_items") <= 3 then
		weight = weight + 5
	end
	if enemyShip:NumAttributes("battle_items") == 0 then
		weight = 0
	end



	return weight

end

return {  psi_requirement = 0;


	icon = "img_ITS3";
	weapon_requirement = 9;
	engine_requirement = 0;
	cpu_requirement = 4;
	recharge = 4;
	rarity = 2;
	cost = 8390;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_disruptor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
