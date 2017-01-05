-- I305
-- Psi Aggression Drone - Deals 3hp/sp per turn for 6 Turns

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	item:AddEffect(world,player,"FC15",enemy,6,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 11;


	icon = "img_IUP1";
	weapon_requirement = 5;
	engine_requirement = 5;
	cpu_requirement = 5;
	recharge = 7;
	rarity = 3;
	cost = 4500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_drone";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
