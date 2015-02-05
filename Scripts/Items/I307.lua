-- I307 --
-- Psi Sacrifice Cannon - Deals 5 hp/sp to user, 14 to enemy and destroys all purple gems.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	item:DamagePlayer(player,enemy,14,true,"RedPath")
	item:DeductEnergy(world,enemy,"shield",14)

	item:DamagePlayer(player,player,5,true,"RedPath")
	item:DeductEnergy(world,player,"shield",5)

	local gemList = world:GetGemList("GPSI")
	item:ClearGems(world,gemList,true,true)
end

local function should_ai_use_item(item, world, player)
end

return {  psi_requirement = 42;


	icon = "img_IWM2";
	weapon_requirement = 5;
	engine_requirement = 5;
	cpu_requirement = 5;
	recharge = 5;
	rarity = 5;
	cost = 6000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
