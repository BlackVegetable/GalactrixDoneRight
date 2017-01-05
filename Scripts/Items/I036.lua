-- I036
-- Targeting Node - Adds +10 to your maximum Red Energy for the remainder of this battle and reduces the Red Energy of your opponent to 0.

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:IncreaseMaxEnergy(world, player, "weapon", 10)
	local enemy = world:GetEnemy(player)
	local amt = math.ceil(enemy:GetAttribute("weapon"))
	item:DeductEnergy(world, enemy, "weapon", amt)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,90)

	local enemy = world:GetEnemy(player)
	local red = enemy:GetAttribute("weapon")
	local red_max = enemy:GetAttribute("weapon_max")

	if red >= math.ceil(0.7 * red_max) then
		weight = weight + 10
		if red >= math.ceil(0.85 * red_max) then
		weight = weight + 10
			if red == red_max then
				weight = 110
			end
		end
	elseif red == 0 then
		weight = weight - 30
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_ICB4";
	weapon_requirement = 9;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 99;
	rarity = 3;
	cost = 6200;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
