-- I117
-- Needle Missiles - Does +3 damage to your enemy, +1 damage for every 2 Green Gems on the board

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amount = 3 + math.floor(#world:GetGemList("GCPU") / 2)

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

	weight = weight - 20 + (math.floor(#world:GetGemList("GCPU") / 2) * 5)

	local size = player:GetAttribute("curr_ship"):GetAttribute("max_items")

	if size == 3 then
		weight = weight + 15
	elseif size == 4 then
		weight = weight + 10
	elseif size == 5 then
		weight = weight + 5
	else
		weight = weight - 1
	end

	if #world:GetGemList("GCPU") <= 1 then
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IM3";
	weapon_requirement = 4;
	engine_requirement = 0;
	cpu_requirement = 5;
	recharge = 2;
	rarity = 3;
	cost = 2500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_missile";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
