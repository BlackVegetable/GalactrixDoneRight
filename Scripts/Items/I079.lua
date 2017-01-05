-- I079
-- Burst Disruptor - Adds +2 turns to the recharge time of a random enemy item.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemyShip = world:GetEnemy(player):GetAttribute("curr_ship")
	if enemyShip:NumAttributes("battle_items") ~= 0 then
		local enemyItem = enemyShip:GetAttributeAt("battle_items", world:MPRandom(1,enemyShip:NumAttributes("battle_items")))
		enemyItem:AddRecharge(2)
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


	icon = "img_ITS4";
	weapon_requirement = 6;
	engine_requirement = 1;
	cpu_requirement = 3;
	recharge = 3;
	rarity = 1;
	cost = 7640;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_disruptor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
