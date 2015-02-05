-- I004
-- Power Laser - Does 5 points of damage to your enemy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	local damage = 5 + math.floor(player:GetCombatStat("gunnery")/49)


	item:DamagePlayer(player,enemy,damage,false,"RedPath")
end

local function should_ai_use_item(item, world, player)
	local enemy = world:GetEnemy(player)
	return math.random(1,65)
	--return (enemy:GetAttribute("shield") / enemy:GetAttribute("shield_max"))*70
	--return math.floor((1-(value / 50))*100)
end

return {  psi_requirement = 0;


	icon = "img_IWM1";
	weapon_requirement = 6;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 0;
	rarity = 9;
	cost = 400;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
