-- I300 --
-- Psi Micro-Charge Cannon --  Deals 3 damage to shields and 3 damage to hull

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	item:DamagePlayer(player,enemy,3,true,"RedPath")
	item:DeductEnergy(world,enemy,"shield",3)

end

local function should_ai_use_item(item, world, player)
end

return {  psi_requirement = 3;


	icon = "img_IGT1";
	weapon_requirement = 2;
	engine_requirement = 2;
	cpu_requirement = 2;
	recharge = 2;
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
