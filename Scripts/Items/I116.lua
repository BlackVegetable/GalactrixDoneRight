-- I116
-- Trident Missiles - Does +3 damage to your enemy, +1 damage for every Red Gem on the board

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amount = 3 + #world:GetGemList("GWEA")

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

	weight = weight - 18 + (#world:GetGemList("GWEA") * 3)

	local size = player:GetAttribute("curr_ship"):GetAttribute("max_items")

	if size == 3 then
		weight = weight + 12
	elseif size == 4 then
		weight = weight + 8
	elseif size == 5 then
		weight = weight + 3
	else
		weight = weight - 1
	end

	if #world:GetGemList("GWEA") == 0 then
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_IM1";
	weapon_requirement = 7;
	engine_requirement = 0;
	cpu_requirement = 3;
	recharge = 2;
	rarity = 4;
	cost = 6500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_missile";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
