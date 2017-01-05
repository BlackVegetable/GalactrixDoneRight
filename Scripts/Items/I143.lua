-- I143
-- Laser Blaster - Does +6 damage to your enemy, ignoring shields, +1 more for every 5 points of Red Energy you have

local function activate(item, world, player, obj,weapon,engine,cpu)
	local dmg = 6 + math.floor(weapon / 5) + math.floor(player:GetCombatStat("gunnery")/49)

	local enemy = world:GetEnemy(player)
	local ship = enemy:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		dmg = math.ceil(dmg * 0.7)
	elseif size == 4 then
		dmg = math.ceil(dmg * 0.8)
	elseif size == 5 then
		dmg = math.ceil(dmg * 0.9)
	end


	item:DamagePlayer(player, world:GetEnemy(player), dmg, true, "RedPath")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local enemy = world:GetEnemy(player)
	local eSize = enemy:GetAttribute("curr_ship"):GetAttribute("max_items")

	if eSize == 3 then
		weight = weight - 20
	elseif eSize == 4 then
		weight = weight - 10
	elseif eSize == 5 then
		weight = weight
	else
		weight = weight + 5
	end

	if player:GetAttribute("weapon") >= 15 then
		weight = weight + 8
		if player:GetAttribute("weapon") >= 25 then
			weight = weight + 8
		end
	else
		weight = weight - 8
	end

	if weight <= 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IGT4";
	weapon_requirement = 9;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 6;
	rarity = 6;
	cost = 4050;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
