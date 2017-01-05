-- I130
-- Trident Laser - Does +9 damage to your enemy +1 more for every 4 points of Red Energy you have.  Your turn does not end.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local dmg = 9 + math.floor(weapon / 4) + math.floor(player:GetCombatStat("gunnery")/49)
	item:DamagePlayer(player,world:GetEnemy(player),dmg,false,"RedPath")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local amt = 9 + math.floor(player:GetAttribute("weapon") / 4)
	local enemy = world:GetEnemy(player)
	local life = enemy:GetAttribute("life") + enemy:GetAttribute("shield") -- Not sure if I'm double counting the shields here.

	if amt >= life then
		weight = 119
	else
		weight = weight - 9 + (math.floor(player:GetAttribute("weapon") / 4) * 3)
	end

	if weight < 0 then
		weight = 0
	end

	return weight



end

return {  psi_requirement = 0;


	icon = "img_IGT1";
	weapon_requirement = 15;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 5;
	rarity = 8;
	cost = 10000;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
