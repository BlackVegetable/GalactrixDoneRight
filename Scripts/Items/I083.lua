-- I083
-- Defense Probe - Inflicts Shield Drain effect on the enemy (causing their Shield to lose 4 points each turn) for 4 turns, +1 turn per 5 Yellow Energy you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 4 + math.floor(engine / 5)
	local enemy = world:GetEnemy(player)
	item:AddEffect(world,enemy,"FT03",enemy,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local shield = world:GetEnemy(player):GetAttribute("shield")
	local yellow = player:GetAttribute("engine")


	weight = weight + math.floor((shield - 14) * 1.5) + (math.floor((yellow - 5) / 5) * 7)

	if shield < 4 then
		weight = 0
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_ICB2";
	weapon_requirement = 0;
	engine_requirement = 9;
	cpu_requirement = 1;
	recharge = 4;
	rarity = 6;
	cost = 1510;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_probe";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
