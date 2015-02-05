-- I015
-- Basic Laser - Does +4 damage to your enemy +1 more for every 5 points of Red Energy you have

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amt = 4 + math.floor((weapon)/5) + math.floor(player:GetCombatStat("gunnery")/49)
	local enemy = world:GetEnemy(player)

	item:DamagePlayer(player,enemy,amt,false,"RedPath")
end

local function should_ai_use_item(item, world, player)
	return 65 + (math.floor(player:GetAttribute("weapon") / 5) * 6)
end

return {  psi_requirement = 0;


	icon = "img_IGT4";
	weapon_requirement = 5;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 2;
	rarity = 9;
	cost = 350;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
