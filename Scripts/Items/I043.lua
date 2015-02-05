-- I043
-- Helm Jack - Increases maximum Shield Energy by +5, +1 more for every 40 points of Pilot you have.


local function activate(item, world, player, obj,weapon,engine,cpu)
	--local amt = 5 + math.floor(#world:GetGemList("GSHD")/4)
	--item:IncreaseMaxEnergy(world, player, "shield", amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICC2";
	weapon_requirement = 0;
	engine_requirement = 3;
	cpu_requirement = 2;
	recharge = 99;
	rarity = 3;
	cost = 600;
	status_on_enemy = 0;
	end_turn = 1;
	passive = 1;
	user_input = 0;

	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
