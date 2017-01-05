-- I033
-- Adrenal Implant - Adds +15 to your maximum Red Energy for the remainder of this battle +1 more per 30 Gunnery.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--local amt = 15 + math.floor(#world:GetGemList("GWEA")/4)
	--item:IncreaseMaxEnergy(world, player, "weapon", amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICB1";
	weapon_requirement = 6;
	engine_requirement = 1;
	cpu_requirement = 0;
	recharge = 99;
	rarity = 3;
	cost = 5750;

	end_turn = 0;
	passive = 1;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
