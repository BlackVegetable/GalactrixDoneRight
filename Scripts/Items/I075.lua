-- I075
-- Shield Capacitor - Increases maximum Shield Energy by +20, +1 more for every 30 points of Pilot Skill.

local function activate(item, world, player, obj,weapon,engine,cpu)
--	local gemList = world:GetGemList("GSHD")
--	local amt = 20 + math.floor(#gemList / 3)
--	item:IncreaseMaxEnergy(world, player, "shield", amt)
--	item:ClearGems(world, gemList, false)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICC1";
	weapon_requirement = 0;
	engine_requirement = 10;
	cpu_requirement = 7;
	recharge = 99;
	rarity = 7;
	cost = 11200;

	end_turn = 1;
	passive = 1;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_capacitor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
