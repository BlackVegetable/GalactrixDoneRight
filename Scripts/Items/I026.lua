-- I026
-- Psi Amplifier - Drains 1-10 Psi Points randomly from your Psi total, doing  1 point of damage to the enemy for each point drained.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amt = math.min(player:GetAttribute("psi"), world:MPRandom(1,10))

	item:DamagePlayer(player, world:GetEnemy(player), amt, false, "RedPath")
	item:DeductEnergy(world, player, "psi", amt)
end

local function should_ai_use_item(item, world, player)
	return math.min(80, player:GetAttribute("psi") * 10)
end

return {  psi_requirement = 0;


	icon = "img_ICC1";
	weapon_requirement = 0;
	engine_requirement = 0;
	cpu_requirement = 6;
	recharge = 3;
	rarity = 1;
	cost = 2000;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
