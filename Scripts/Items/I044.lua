-- I044
-- Cloaking Module - Cloaks your ship for 10 turns, so you take no damage. The cloak ends if you damage your enemy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AddEffect(world,player,"FD02",player,10,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 12;
	recharge = 99;
	rarity = 2;
	cost = 10320;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
