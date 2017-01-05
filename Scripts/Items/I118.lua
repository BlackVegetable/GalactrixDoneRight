-- I118
-- Counter Missiles - Does +5 damage to your enemy and turns all Red Gems to Blue Gems

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amount = 5
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
	local gemList = world:GetGemList("GWEA")
	item:TransformGems(world, gemList, true, "GSHD")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local gemList = world:GetGemList("GWEA")

	if #gemList <= 1 then
		weight = 0
	else
		weight = weight + (#gemList * 2)
	end

	return weight


end

return {  psi_requirement = 0;


	icon = "img_IM2";
	weapon_requirement =7;
	engine_requirement = 7;
	cpu_requirement = 0;
	recharge = 4;
	rarity = 8;
	cost = 1650;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_missile";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
