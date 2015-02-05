-- I308 --
-- Psi Endurance Matrix - Increases all max energy by 8.  Costs 20 PSI.

local function activate(item, world, player, obj,weapon,engine,cpu)

	item:IncreaseMaxEnergy(world, player, {"weapon", "cpu", "engine", "shield"}, 8)

end

local function should_ai_use_item(item, world, player)
end

return {  psi_requirement = 20;


	icon = "img_ICC1";
	weapon_requirement = 9;
	engine_requirement = 9;
	cpu_requirement = 9;
	recharge = 5;
	rarity = 5;
	cost = 5980;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_shieldsup";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
