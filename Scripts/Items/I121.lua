-- I121
-- Shield Multiplexor - Drains your Shield but fills your Red Energy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amt = player:GetAttribute("shield")
	item:DeductEnergy(world, player, "shield", amt)
	item:AwardEnergy(world, player, "weapon", player:GetAttribute("weapon_max"))

	local playerID = player:GetAttribute("player_id")
	world:DrainEffect("shield",playerID,"weapon",playerID)
end

local function should_ai_use_item(item, world, player)

	local weight = 0
	local red = player:GetAttribute("weapon")
	local red_max = player:GetAttribute("weapon_max")
	local shieldPercent = (player:GetAttribute("shield") / player:GetAttribute("shield_max"))

	if red >= (red_max - 3) then
		weight = 0
	else
		weight = weight + (((red_max - red) - 3) * 2)
	end

	if red >= (red_max - 3) then
		weight = 0
	elseif shieldPercent >= 0.85 then
		weight = 0
	elseif shieldPercent >= 0.6 then
		weight = weight + math.random(1,65)
	elseif shieldPercent >= 0.35 then
		weight = weight + math.random(1,80)
	elseif shieldPercent >= 0.05 then
		weight = weight + math.random(1,95)
	else
		weight = weight + math.random(10,100)
	end

	return weight



end

return {  psi_requirement = 0;


	icon = "img_ICC1";
	weapon_requirement = 0;
	engine_requirement = 10;
	cpu_requirement = 6;
	recharge = 8;
	rarity = 2;
	cost = 6000;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
