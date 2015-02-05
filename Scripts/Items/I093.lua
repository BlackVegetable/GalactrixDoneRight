-- I093
-- Needle Drone - Reduces enemy Shield by 1 point for each 2 points of Red Energy they have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	local amt = math.floor(enemy:GetAttribute("weapon") / 2)
	item:DeductEnergy(world, enemy, "shield", amt)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,88)
	local enemy = world:GetEnemy(player)
	local shield = enemy:GetAttribute("shield")
	local red = enemy:GetAttribute("weapon")

	local bonus = -36 + (math.floor(red/2)) * 4
	if shield < 9 then
		if bonus >= 0 then
			bonus = bonus - ((shield - 9) * 4)
		end
	else
		bonus = bonus + 5
	end

	weight = weight + bonus
	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IUP1";
	weapon_requirement = 6;
	engine_requirement = 4;
	cpu_requirement = 0;
	recharge = 0;
	rarity = 3;
	cost = 5600;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_drone";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
