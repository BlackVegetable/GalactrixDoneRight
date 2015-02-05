-- I072
-- Duplex Node - Increases you maximum Yellow Energy by +5, +1 more for every 4 Yellow Energy you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amt = 5 + math.floor(world:GetEnemy(player):GetAttribute("engine") / 4)
	item:IncreaseMaxEnergy(world, player, "engine", amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICC1";
	weapon_requirement = 2;
	engine_requirement = 8;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 5;
	cost = 3120;
	status_on_enemy = 0;
	end_turn = 1;
	passive = 1;
	user_input = 0;

	activation_sound = "snd_capacitor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
