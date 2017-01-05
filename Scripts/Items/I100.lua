-- I100
-- ADV Laser - Does +6 damage to your enemy +1 more for every 4 points of Red Energy you have

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amount = 6 + math.floor(weapon / 4) + math.floor(player:GetCombatStat("gunnery")/49)
	item:DamagePlayer(player, world:GetEnemy(player), amount, false, "RedPath")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,90)
	weight = weight + (math.floor(player:GetAttribute("weapon") / 4) * 5)

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IGT4";
	weapon_requirement = 8;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 6;
	cost = 1050;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
