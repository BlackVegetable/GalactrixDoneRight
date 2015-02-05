-- I042
-- Data Jack - Adds +15 to your maximum Green Energy +1 more for every 40 points of Science you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
--	local amt = 15 + math.floor(#world:GetGemList("GCPU")/4)
--	item:IncreaseMaxEnergy(world, player, "cpu", amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICC1";
	weapon_requirement = 0;
	engine_requirement = 1;
	cpu_requirement = 6;
	recharge = 99;
	rarity = 3;
	cost = 5750;
	status_on_enemy = 0;
	end_turn = 1;
	passive = 1;
	user_input = 0;

	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
