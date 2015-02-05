-- I037
-- Control Implant - Adds +10 to your maximum Yellow Energy for the remainder of this battle, +1 more per 30 Engineer you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--local amt = 10 + math.floor(engine /5)
	--item:IncreaseMaxEnergy(world, player, "engine", amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICB5";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 0;
	recharge = 99;
	rarity = 3;
	cost = 1600;

	end_turn = 1;
	passive = 1;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
