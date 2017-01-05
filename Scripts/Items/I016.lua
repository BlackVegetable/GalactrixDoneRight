-- I016
-- Military Laser - Does +8 damage to your enemy +1 more for every 3 points of Red Energy you have

local function activate(item, world, player, obj,weapon,engine,cpu)
	local bonus = math.floor(weapon /3) + math.floor(player:GetCombatStat("gunnery")/49)
	local enemy = world:GetEnemy(player)

	item:DamagePlayer(player,enemy,8+bonus,false,"RedPath")
end

local function should_ai_use_item(item, world, player)
	return 75 + math.floor(player:GetAttribute("weapon")*1.3)
end

return {  psi_requirement = 0;


	icon = "img_IGT3";
	weapon_requirement = 12;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 4;
	rarity = 8;
	cost = 5000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
