-- I040
-- Targeting Jack - Adds +25 to your maximum Red Energy for the remainder of this battle +1 more per 40 Gunnery Skill you have.


local function activate(item, world, player, obj,weapon,engine,cpu)
--	local amt = 25 + math.floor(#world:GetGemList("GWEA")/4)
--	item:IncreaseMaxEnergy(world, player, "weapon", amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICC1";
	weapon_requirement = 13;
	engine_requirement = 3;
	cpu_requirement = 0;
	recharge = 99;
	rarity = 3;
	cost = 7500;

	end_turn = 1;
	passive = 1;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
