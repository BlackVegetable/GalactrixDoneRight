-- I073
-- Modified Capacitor - Adds +15 to your maximum Yellow Energy for the remainder of this battle +1 more per 40 points of Engineer.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--local amt = 15 + math.floor(#world:GetGemList("GENG")/4)
	--item:IncreaseMaxEnergy(world, player, "engine", amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICC1";
	weapon_requirement = 0;
	engine_requirement = 6;
	cpu_requirement = 1;
	recharge = 99;
	rarity = 2;
	cost = 5750;
	status_on_enemy = 0;
	end_turn = 1;
	passive = 1;
	user_input = 0;

	activation_sound = "snd_capacitor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
