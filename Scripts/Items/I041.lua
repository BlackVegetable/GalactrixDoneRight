-- I041
-- Control Jack -Adds +10 to your maximum Yellow and Green Energy +1 more for every 40 points of Engineer you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
--	local amt = 10 + math.floor(#world:GetGemList("GENG")/4)
--	item:IncreaseMaxEnergy(world, player, {"engine", "cpu"}, amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICC3";
	weapon_requirement = 0;
	engine_requirement = 10;
	cpu_requirement = 6;
	recharge = 99;
	rarity = 7;
	cost = 6500;
	status_on_enemy = 0;
	end_turn = 1;
	passive = 1;
	user_input = 0;

	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
