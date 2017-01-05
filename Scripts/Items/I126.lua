-- I126
-- Vortraag Laser - Does +10 damage to your enemy, +1 more for every 5 levels you have

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amount = 10 + math.floor(player:GetLevel() / 5) + math.floor(player:GetCombatStat("gunnery")/49)
	item:DamagePlayer(player, world:GetEnemy(player), amount, false, "RedPath")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local amt = 10 + math.floor(player:GetLevel() / 5)
	local enemy = world:GetEnemy(player)
	local life = enemy:GetAttribute("life") + enemy:GetAttribute("shield") -- I'm not sure If I'm double counting here for the shields.

	if amt >= life then
		weight = 120
	else
		weight = weight + ((amt - 13) * 4)
	end

	if weight < 0 then
		weight = 0
	end

	return weight



end

return {  psi_requirement = 0;


	icon = "img_IGT2";
	weapon_requirement = 16;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 3;
	cost = 9400;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
