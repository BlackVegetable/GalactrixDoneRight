-- I081
-- Cargo Probe - Causes enemy to lose 10% of cargo.

local function activate(item, world, player, obj,weapon,engine,cpu)
	--player.statBonus.cargo = player.statBonus.cargo + 1
	local enemy = world:GetEnemy(player)
	for i=1,_G.NUM_CARGOES do
		enemy:RemoveCargo(i, enemy:GetAttributeAt("cargo", i)*0.1)
	end
end

local function should_ai_use_item(item, world, player)

end

return {  psi_requirement = 0;


	icon = "img_ICB1";
	weapon_requirement = 0;
	engine_requirement = 8;
	cpu_requirement = 1;
	recharge = 9;
	rarity = 2;
	cost = 0;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_probe";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
