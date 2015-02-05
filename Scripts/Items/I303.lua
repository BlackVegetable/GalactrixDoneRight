-- I303 --
-- Psi Giga-Charge Cannon -- Deals 9 Damage to Shields and 9 Damage to Hull

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	item:DamagePlayer(player,enemy,9,true,"RedPath")
	item:DeductEnergy(world,enemy,"shield",9)

end

local function should_ai_use_item(item, world, player)
end

return {  psi_requirement = 10;


	icon = "img_IGT5";
	weapon_requirement = 5;
	engine_requirement = 5;
	cpu_requirement = 5;
	recharge = 3;
	rarity = 5;
	cost = 1000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
