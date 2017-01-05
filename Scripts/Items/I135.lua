-- I135
-- Yellowfin Torpedoes - Does 1 point of damage to your enemy for every 2 points of Yellow Energy that enemy has.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local dmg = math.floor(world:GetEnemy(player):GetAttribute("engine") / 2)
	local amount = dmg
	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		amount = amount + 5
	elseif size == 4 then
		amount = amount + 3
	elseif size == 5 then
		amount = amount + 1
	end

	item:DamagePlayer(player, world:GetEnemy(player), amount, false, "RedPath")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local enemy = world:GetEnemy(player)
	local yellow = enemy:GetAttribute("engine")

	weight = weight - 45 + (math.floor(yellow / 2) * 5)
	if size == 3 then
		weight = weight + 20
	elseif size == 4 then
		weight = weight + 12
	elseif size == 5 then
		weight = weight + 4
	else
		weight = weight - 1
	end

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IM5";
	weapon_requirement = 9;
	engine_requirement = 1;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 3;
	cost = 2900;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_missile";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
