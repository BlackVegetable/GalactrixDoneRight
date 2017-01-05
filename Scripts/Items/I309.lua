-- I309 --
-- Psi Shield Emancipator - Reduces enemy shield capacity by 15%

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	local reduction = math.floor(enemy:GetAttribute("shield_max") * 0.15)

	item:IncreaseMaxEnergy(world, enemy, "shield", -reduction)

end

local function should_ai_use_item(item, world, player)
end

return {  psi_requirement = 10;


	icon = "img_ICC4";
	weapon_requirement = 7;
	engine_requirement = 7;
	cpu_requirement = 7;
	recharge = 4;
	rarity = 5;
	cost = 2980;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_shieldsdown";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
