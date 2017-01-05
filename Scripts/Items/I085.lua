-- I085
-- Data Probe - Inflicts CPU Drain effect on the enemy (causing their Green Energy to lose 3 points each turn) for 5 turns, +1 turn per 6 Yellow Energy you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 5 + math.floor(engine / 6)
	local enemy = world:GetEnemy(player)

	for i=1,enemy:NumAttributes("Effects") do
		if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT02_NAME]" then
			local effect = enemy:GetAttributeAt("Effects",i)
			GameObjectManager:Destroy(effect)
			break
		end
	end

	item:AddEffect(world,enemy,"FT02",enemy,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)
	local enemy = world:GetEnemy(player)
	local cpu = enemy:GetAttribute("cpu")
	local yellow = player:GetAttribute("engine")
	local weight = math.random(1,100)

	weight = weight + (math.floor(yellow / 6) * 7)

	if cpu > 14 then
		weight = weight + 15
	elseif cpu > 6 then
		weight = weight + 5
	elseif cpu > 0 then
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


	icon = "img_ICB5";
	weapon_requirement = 0;
	engine_requirement = 6;
	cpu_requirement = 2;
	recharge = 5;
	rarity = 4;
	cost = 769;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_probe";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
