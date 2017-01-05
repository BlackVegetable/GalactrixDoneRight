-- I022
-- Degausser - Removes all status effects on your ship.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--player:ClearAttributeCollection("Effects")
	item:ClearEffects(player)
end

local function should_ai_use_item(item, world, player)
	if player:NumAttributes("Effects") > 0 then
		return math.random(0, 85)
	else
		return 0
	end
end

return {  psi_requirement = 0;


	icon = "img_IFT2";
	weapon_requirement = 3;
	engine_requirement = 8;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 8;
	cost = 700;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_degauss";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
