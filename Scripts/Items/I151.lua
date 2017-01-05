-- I151 - MRI Special
-- Psi-clone Missiles - Does 5 points of damage to the enemy +1 point for every 2 Purple Gems in play

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GPSI")
	local amt = 5 + math.floor((#gemList) / 2)
	local amount = amt
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
	local gemList = world:GetGemList("GPSI")
	local weight = math.random(1,100)

	local amt = 5 + math.floor((#gemList) / 2)
	local amount = amt
	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		amount = amount + 3
	elseif size == 4 then
		amount = amount + 2
	elseif size == 5 then
		amount = amount + 1
	end

	weight = weight + ((amount - 8) * 3)

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 9;
	engine_requirement = 0;
	cpu_requirement = 3;
	recharge = 3;
	rarity = 10;
	cost = 16800;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_missile";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
