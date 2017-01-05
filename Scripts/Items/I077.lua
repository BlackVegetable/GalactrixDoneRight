-- I077
-- EM Disruptor - Adds +2 turn to the recharge time of all enemy items, +1 more for each 10 Yellow Energy you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local numTurns = 2 + math.floor(engine / 10)
	local enemyShip = world:GetEnemy(player):GetAttribute("curr_ship")
	if enemyShip:NumAttributes("battle_items") > 0 then
		for i=1,enemyShip:NumAttributes("battle_items") do
			enemyShip:GetAttributeAt("battle_items", i):AddRecharge(numTurns)
		end
	end
end

local function should_ai_use_item(item, world, player)

	local enemyShip = world:GetEnemy(player):GetAttribute("curr_ship")
	local weight = math.random(1,90)
	weight = weight + (math.floor(player:GetAttribute("engine") / 10) * 7)
	if enemyShip:NumAttributes("battle_items") == 0 then
		weight = 0
	end



	return weight

end

return {  psi_requirement = 0;


	icon = "img_ITS2";
	weapon_requirement = 12;
	engine_requirement = 5;
	cpu_requirement = 0;
	recharge = 5;
	rarity = 2;
	cost = 17500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_disruptor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
