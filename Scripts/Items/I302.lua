-- I302 --
-- Psi Mega-Charge Cannon -- Deals 5 Damage to Shield and 5 Damage to Hull

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	item:DamagePlayer(player,enemy,5,true,"RedPath")
	item:DeductEnergy(world,enemy,"shield",5)

end

local function should_ai_use_item(item, world, player)
end

return {  psi_requirement = 6;


	icon = "img_IGT1";
	weapon_requirement = 3;
	engine_requirement = 3;
	cpu_requirement = 3;
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
