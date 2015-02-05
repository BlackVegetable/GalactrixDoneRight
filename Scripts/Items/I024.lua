-- I024
-- Ultra Degausser - Removes all status effects in play.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--player:ClearAttributeCollection("Effects")
	--world:ClearAttributeCollection("Effects")
	--world:GetEnemy(player):ClearAttributeCollection("Effects")
	item:ClearEffects(player)
	item:ClearEffects(world)
	item:ClearEffects(world:GetEnemy(player))
end

local function should_ai_use_item(item, world, player)
	if player:NumAttributes("Effects") == 0 or world:NumAttributes("Effects") == 0 or world:GetEnemy(player):NumAttributes("Effects") == 0 then
		return math.random(0,85)
	else
		return 0
	end
end

return {  psi_requirement = 0;


	icon = "img_IFT5";
	weapon_requirement = 5;
	engine_requirement = 14;
	cpu_requirement = 5;
	recharge = 4;
	rarity = 3;
	cost = 1600;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_degauss";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
