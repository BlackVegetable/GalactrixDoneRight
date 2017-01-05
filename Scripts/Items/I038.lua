-- I038
-- Data Implant -  Increases maximum Shield Energy by +10, +1 more for every 30 points of Pilot you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--local gemList = world:GetGemList("GSHD")
	--local amt = 10 + math.floor(#gemList / 3)
	--item:IncreaseMaxEnergy(world, player, "shield", amt)
	--item:ClearGems(world, gemList, false)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICC4";
	weapon_requirement = 0;
	engine_requirement = 8;
	cpu_requirement = 0;
	recharge = 99;
	rarity = 6;
	cost = 7000;

	end_turn = 1;
	passive = 1;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
