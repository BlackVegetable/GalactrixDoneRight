-- I119
-- Cluster Missiles - Does +4 damage to your enemy and destroys 3 random gems on the board

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amount = 4
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
	item:ClearGems(world,item:GetRandomGems(3, nil, world),false)
end

local function should_ai_use_item(item, world, player)

	local gemList3 = world:GetGemList("GDM3")
	local gemList5 = world:GetGemList("GDM5")
	local gemListX = world:GetGemList("GDMX")

	local weight = math.random(1,80)

	local bonus = 0
	bonus = bonus + math.floor(#gemList3 / 3)
	bonus = bonus + (#gemList5 * 3)
	bonus = bonus + (#gemListX * 6)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		bonus = bonus + 5
	elseif size == 4 then
		bonus = bonus + 3
	elseif size == 5 then
		bonus = bonus + 1
	end

	weight = weight + bonus

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IM4";
	weapon_requirement = 5;
	engine_requirement = 6;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 2;
	cost = 4500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_missile";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
