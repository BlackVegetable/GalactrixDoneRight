-- I098
-- Mining Laser - Does +3 damage to your enemy +1 more for every 6 points of Yellow Energy you have

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amount = 3 + math.floor(engine / 6) + math.floor(player:GetCombatStat("gunnery")/49)
	item:DamagePlayer(player, world:GetEnemy(player), amount, false, "RedPath")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,75)
	local yellow = player:GetAttribute("engine")

	weight = weight + (math.floor(yellow / 6) * 3)

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IGT5";
	weapon_requirement = 4;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 9;
	cost = 250;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
