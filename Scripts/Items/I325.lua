-- I325
-- Military Ion Laser - Does 9 Ion Damage to your enemy + 1 for every 3 Red that you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amt = 9 + math.floor((weapon)/3) + math.floor(player:GetCombatStat("gunnery")/49)
	local enemy = world:GetEnemy(player)
	local enemyShip = enemy:GetAttribute("curr_ship")
	local sHP = enemy:GetAttribute("shield")
	local ion = 0
	local disruptions = 0
	local num


	if sHP == 0 then
		amt = math.ceil(amt * 0.5) -- Ion Hull Damage Reduction
		ion = amt
	elseif sHP > 0 then
		if sHP < amt then
			ion = math.ceil((amt - sHP) * 0.5)
			amt = amt - math.floor((amt - sHP) * 0.5)
		elseif sHP > amt then
			ion = 0
		end
	end

	local items = enemyShip:NumAttributes("battle_items")
	--num = math.random(1,items)

	if _G.GLOBAL_FUNCTIONS.RandomRounding(ion, 4) == "up" then
		disruptions = math.ceil(ion / 4)
	else
		disruptions = math.floor(ion / 4)
	end

	for i=1,disruptions do
		num = math.random(1,items)
		enemyShip:GetAttributeAt("battle_items", num):AddRecharge(2)
	end


	item:DamagePlayer(player,enemy,amt,false,"RedPath")
end

local function should_ai_use_item(item, world, player)
	return 70 + player:GetAttribute("weapon")
end

return {  psi_requirement = 0;


	icon = "img_IGT3";
	weapon_requirement = 13;
	engine_requirement = 0;
	cpu_requirement = 0;
	recharge = 5;
	rarity = 9;
	cost = 15000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_laser";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
