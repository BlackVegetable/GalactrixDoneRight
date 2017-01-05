-- I131
-- A.I. Missiles - Does 1 point of damage to your enemy for every 2 points of your Green Energy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local dmg = math.floor(cpu / 2)
	local amount = dmg
	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		amount = amount + 3
	elseif size == 4 then
		amount = amount + 2
	elseif size == 5 then
		amount = amount + 1
	end

	item:DamagePlayer(player, world:GetEnemy(player), amount, false, "RedPath")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		weight = weight + 9
	elseif size == 4 then
		weight = amount + 6
	elseif size == 5 then
		weight = amount + 3
	end

	local green = player:GetAttribute("cpu")

	weight = weight + ((math.floor(green / 2) - 7) * 3)

	if weight < 0 then
		weight = 0
	end

	return weight


end

return {  psi_requirement = 0;


	icon = "img_IM4";
	weapon_requirement = 2;
	engine_requirement = 0;
	cpu_requirement = 15;
	recharge = 3;
	rarity = 1;
	cost = 12460;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_missile";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
