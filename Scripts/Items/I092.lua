-- I092
-- Worm Drone - Drains 20 Intel points from the enemy. (removed due to the slew of associated lost-level bugs)

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	item:DeductEnergy(world, enemy, "intel", 20)
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_IUP2";
	weapon_requirement = 4;
	engine_requirement = 0;
	cpu_requirement = 4;
	recharge = 1;
	rarity = 5;
	cost = 750;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_drone";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
