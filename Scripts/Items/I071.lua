-- I071
-- Ferrite Capacitor - Increases your maximum Red Energy and Green Energy by +10, +1 more for every 20 points of Engineer you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--local amt = 10 + math.floor(engine / 5)
	--item:IncreaseMaxEnergy(world, player, {"weapon", "cpu"}, amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICC1";
	weapon_requirement = 2;
	engine_requirement = 6;
	cpu_requirement = 3;
	recharge = 99;
	rarity = 6;
	cost = 6225;
	status_on_enemy = 0;
	end_turn = 1;
	passive = 1;
	user_input = 0;

	activation_sound = "snd_capacitor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
