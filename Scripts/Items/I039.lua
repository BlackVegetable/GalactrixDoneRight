-- I039
-- Helm Implant - Adds +10 to your maximum Shield Energy, +1 more per 8 levels you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--local amt = 10 + math.floor(player:GetLevel()/8)
	--item:IncreaseMaxEnergy(world, player, "shield", amt)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICC2";
	weapon_requirement = 0;
	engine_requirement = 0;
	cpu_requirement = 5;
	recharge = 99;
	rarity = 3;
	cost = 3500;

	end_turn = 1;
	passive = 1;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
