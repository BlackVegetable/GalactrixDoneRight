-- I017
-- Wasp Missiles - Does +2 damage to your enemy,   +1 damage for every yellow gem on the board

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GENG")
	local bonus = #gemList

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")
	local amount = 0

	if size == 3 then
		amount = amount + 3
	elseif size == 4 then
		amount = amount + 2
	elseif size == 5 then
		amount = amount + 1
	end

	item:DamagePlayer(player,world:GetEnemy(player),2+bonus+amount,false,"RedPath")
end

local function should_ai_use_item(item, world, player)

	local size = player:GetAttribute("curr_ship"):GetAttribute("max_items")
	local weight = math.random(1, 70)

	weight = 70 + (#world:GetGemList("GENG")*2)
	if size == 3 then
		weight = weight + 6
	elseif size == 4 then
		weight = weight + 4
	elseif size == 5 then
		weight = weight + 2
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_IM1";
	weapon_requirement = 8;
	engine_requirement = 2;
	cpu_requirement = 2;
	recharge = 3;
	rarity = 4;
	cost = 2200;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_missile";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
