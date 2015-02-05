-- I047
-- Threat Analyzer - Increases your maximum Red Energy and Green Energy by +20 +1 more for every 250 PSI you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
--	local amt = 20 + math.floor(world:GetEnemy(player):GetAttribute("weapon")/5)
--	item:IncreaseMaxEnergy(world, player, {"weapon", "cpu"}, amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_IS4";
	weapon_requirement = 12;
	engine_requirement = 0;
	cpu_requirement = 10;
	recharge = 99;
	rarity = 1;
	cost = 13600;
	status_on_enemy = 0;
	end_turn = 1;
	passive = 1;
	user_input = 0;

	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
