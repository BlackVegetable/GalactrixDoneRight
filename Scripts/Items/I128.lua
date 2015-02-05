-- I128
-- Seeker Torpedoes - Does +6 damage to your enemy, +1 more for every 8 points of Yellow Energy they have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amount = 6 + math.floor(world:GetEnemy(player):GetAttribute("engine") / 8)

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

	weight = weight - 10 + (math.floor(yellow / 8) * 9)
	if size == 3 then
		weight = weight + 18
	elseif size == 4 then
		weight = weight + 9
	elseif size == 5 then
		weight = weight + 1
	else
		weight = weight - 5
	end

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IM1";
	weapon_requirement = 5;
	engine_requirement = 8;
	cpu_requirement = 0;
	recharge = 2;
	rarity = 5;
	cost = 5460;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_missile";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
