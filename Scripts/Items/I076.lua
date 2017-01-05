-- I076
-- Basic Disruptor - Adds +4 turns to the recharge time of a random enemy item.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemyShip = world:GetEnemy(player):GetAttribute("curr_ship")
	if enemyShip:NumAttributes("battle_items") > 0 then
		local enemyItem = enemyShip:GetAttributeAt("battle_items", world:MPRandom(1,enemyShip:NumAttributes("battle_items")))

		LOG("Item = " .. item:GetAttribute("description"))
		enemyItem:AddRecharge(4)
	else
		LOG("Warning - no items")
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


	icon = "img_ITS1";
	weapon_requirement = 7;
	engine_requirement = 1;
	cpu_requirement = 0;
	recharge = 4;
	rarity = 3;
	cost = 5780;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_disruptor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
