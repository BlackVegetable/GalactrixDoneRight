-- I156 - Soulless Special
-- Modified Laser - Does 15 damage to the enemy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local damage = 15 + math.floor(player:GetCombatStat("gunnery") / 49)

	item:DamagePlayer(player, world:GetEnemy(player), damage, false, "RedPath")
end

local function should_ai_use_item(item, world, player)
	local enemy = world:GetEnemy(player)
	if enemy:GetAttribute("shield") + enemy:GetAttribute("life") <= 15 then
		return 150
	else
		return math.random(50,100)
	end
end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 8;
	engine_requirement = 0;
	cpu_requirement = 5;
	recharge = 0;
	rarity = 10;
	cost = 14000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
