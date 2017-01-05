-- I025
-- Reflec Armor - Does 1 point of damage to your enemy for every 2 points in your Shield.  Drains your shield to half.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	local amt = math.floor(player:GetAttribute("shield") / 2)
	item:DamagePlayer(player, enemy, amt, false, "RedPath")
	item:DeductEnergy(world, player, "shield", amt)
end

local function should_ai_use_item(item, world, player)
	local enemy = world:GetEnemy(player)
	if enemy:GetAttribute("life") < math.floor(player:GetAttribute("shield") / 2) then
		return 150
	elseif player:GetAttribute("shield") > 20 then
		return math.random(1,90)
	elseif player:GetAttribute("shield") == 0 then
		return 0
	else
		return math.random(1,80)
	end
end

return {  psi_requirement = 0;


	icon = "img_IS2";
	weapon_requirement = 8;
	engine_requirement = 7;
	cpu_requirement = 7;
	recharge = 5;
	rarity = 2;
	cost = 1800;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_shieldsdown";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
