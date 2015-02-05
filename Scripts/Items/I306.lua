-- I306
-- Psi Havoc Drone - Deals 1hp/sp per turn and reduces stats by 20% for 7 Turns; does not end your turn.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	item:AddEffect(world,player,"FC16",enemy,7,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 12;


	icon = "img_IUP2";
	weapon_requirement = 4;
	engine_requirement = 4;
	cpu_requirement = 4;
	recharge = 4;
	rarity = 4;
	cost = 4200;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;
	activation_sound = "snd_drone";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
