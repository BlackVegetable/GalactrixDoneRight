-- I046
-- Flightpath Analyzer - Increases maximum Shield Energy by +20 and Increases your Shield by 10.

local function activate(item, world, player, obj,weapon,engine,cpu)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		item:IncreaseMaxEnergy(world, player, "shield", 35)
		item:AwardEnergy(world, player, "shield", 20)
	elseif size == 4 then
		item:IncreaseMaxEnergy(world, player, "shield", 30)
		item:AwardEnergy(world, player, "shield", 15)
	else
		item:IncreaseMaxEnergy(world, player, "shield", 20)
		item:AwardEnergy(world, player, "shield", 10)
	end

end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_IS3";
	weapon_requirement = 0;
	engine_requirement = 10;
	cpu_requirement = 6;
	recharge = 99;
	rarity = 1;
	cost = 13200;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
