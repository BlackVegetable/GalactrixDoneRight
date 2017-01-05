-- I084
-- Weapon Probe - Inflicts Weapon Drain effect on the enemy (causing their Red Energy to lose 3 points each turn) for 5 turns, +1 turn per 6 Yellow Energy you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 5 + math.floor(engine / 6)

	for i=1,enemy:NumAttributes("Effects") do
		if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT07_NAME]" then
			local effect = enemy:GetAttributeAt("Effects",i)
			GameObjectManager:Destroy(effect)
			break
		end
	end

	item:AddEffect(world,world:GetEnemy(player),"FT07",world:GetEnemy(player),turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local enemy = world:GetEnemy(player)
	local weapon = enemy:GetAttribute("weapon")
	local yellow = player:GetAttribute("engine")
	local weight = math.random(1,100)

	weight = weight + (math.floor(yellow / 6) * 7)

	if weapon > 14 then
		weight = weight + 15
	elseif weapon > 6 then
		weight = weight + 5
	elseif weapon > 0 then
		weight = weight - 5
	else
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_ICB3";
	weapon_requirement = 0;
	engine_requirement = 7;
	cpu_requirement = 1;
	recharge = 5;
	rarity = 5;
	cost = 1020;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_probe";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
