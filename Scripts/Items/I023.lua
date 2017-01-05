-- I023
-- Environmental Degausser - Removes all status effects on the board.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--world:ClearAttributeCollection("Effects")
	item:ClearEffects(world)
end

local function should_ai_use_item(item, world, player)
	if world:NumAttributes("Effects") > 0 then
		return math.random(0, 80)
	else
		return 0
	end
end

return {  psi_requirement = 0;


	icon = "img_IFT4";
	weapon_requirement = 2;
	engine_requirement = 6;
	cpu_requirement = 0;
	recharge = 2;
	rarity = 5;
	cost = 750;
	status_on_enemy = 0;
	end_turn = 0;  passive = 0;
	user_input = 0;

	activation_sound = "snd_degauss";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
