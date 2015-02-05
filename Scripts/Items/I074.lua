-- I074
-- Multiphase Node - Increases all maximum Energy (except Shield energy) by +3.

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:IncreaseMaxEnergy(world, player, {"weapon", "engine", "cpu"}, 3)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICC1";
	weapon_requirement = 5;
	engine_requirement = 5;
	cpu_requirement = 5;
	recharge = 6;
	rarity = 1;
	cost = 8250;

	end_turn = 0; passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_capacitor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
