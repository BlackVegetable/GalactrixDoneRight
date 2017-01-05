-- I333
-- PSI Augmenter -- Increases PSI gained per match by 1.

local function activate(item, world, player, obj,weapon,engine,cpu)

end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICB5";
	weapon_requirement = 0;
	engine_requirement = 3;
	cpu_requirement = 2;
	recharge = 99;
	rarity = 2;
	cost = 3333;

	end_turn = 1;
	passive = 1;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_capacitor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
