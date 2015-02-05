-- I132
-- Dark Laser - Does 19 damage to your enemy +1 more for every 2 points of Green Energy you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local dmg = 19 + math.floor(cpu / 2) + math.floor(player:GetCombatStat("gunnery")/49)
	item:DamagePlayer(player, world:GetEnemy(player), dmg, false, "RedPath")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local green = player:GetAttribute("cpu")

	weight = weight + ((math.floor(green / 2) - 5) * 3)

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IGT4";
	weapon_requirement = 15;
	engine_requirement = 0;
	cpu_requirement = 10;
	recharge = 6;
	rarity = 8;
	cost = 19000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
