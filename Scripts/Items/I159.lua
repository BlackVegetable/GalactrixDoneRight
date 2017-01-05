-- I159 - Vortraag Special
-- Vortraag Death Ray - halves enemy's life, excluding shields

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amount = math.floor(world:GetEnemy(player):GetAttribute("life") / 2)

	local enemy = world:GetEnemy(player)
	local ship = enemy:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		amount = amount - 8
	elseif size == 4 then
		amount = amount - 5
	elseif size == 5 then
		amount = amount - 2
	end

	if amount < 0 then
		amount = 1
	end




	item:DamagePlayer(player, world:GetEnemy(player), amount, true, "RedPath")
end

local function should_ai_use_item(item, world, player)
	local enemy = world:GetEnemy(player)
	local lifePercent = enemy:GetAttribute("life") / enemy:GetAttribute("life_max")
	local weight = 0
	if lifePercent > 0.8 then
		weight = 118
	elseif lifePercent > 0.5 then
		weight = 89
	elseif lifePercent > 0.3 then
		weight = 75
	else
		weight = 0
	end

	local ship = enemy:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		weight = weight - 20
	elseif size == 4 then
		weight = weight - 12
	elseif size == 5 then
		weight = weight - 4
	end

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 18;
	engine_requirement = 8;
	cpu_requirement = 0;
	recharge = 7;
	rarity = 10;
	cost = 19000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_bomb";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
