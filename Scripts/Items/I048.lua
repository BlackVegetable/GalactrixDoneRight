-- I048
-- Network Analyzer - Increases your maximum Red Energy and Yellow Energy by +10, +1 more for every 20 points of Science you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--local amt = 10 + math.floor(cpu / 5)
	--item:IncreaseMaxEnergy(world, player, {"weapon", "engine"}, amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_IS2";
	weapon_requirement = 3;
	engine_requirement = 2;
	cpu_requirement = 6;
	recharge = 99;
	rarity = 1;
	cost = 6225;

	end_turn = 1;
	passive = 1;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
