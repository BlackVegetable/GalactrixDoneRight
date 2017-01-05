-- I032
-- Shield Virus - Reduces an opponent’s Shield to zero.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	--world:GetEnemy(player):SetAttribute("shield", 0)
	item:DeductEnergy(world, enemy, "shield", enemy:GetAttribute("shield"))
end

local function should_ai_use_item(item, world, player)

	local weight = math.random (1,100)

	local enemy = world:GetEnemy(player)
	local sp = enemy:GetAttribute("shield")

	if sp < 10 then
		weight = weight - 45
	elseif sp < 20 then
		weight = weight - 20
	elseif sp < 40 then
		weight = weight + 1
	elseif sp >= 40 then
		weight = weight + 25
	end

	if weight <= 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_ICB3";
	weapon_requirement = 9;
	engine_requirement = 0;
	cpu_requirement = 18;
	recharge = 8;
	rarity = 1;
	cost = 4000;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_shieldsdown";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
