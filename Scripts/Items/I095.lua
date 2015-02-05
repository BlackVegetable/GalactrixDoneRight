-- I095
-- Vampyre Drone - Reduces enemy Shield by 10, +1 point for each 5 levels the enemy has.  Adds those points to your own Shield.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	local amt = math.min(enemy:GetAttribute("shield"), math.floor(enemy:GetLevel() / 5) + 10)
	item:DeductEnergy(world, enemy, "shield", amt)
	item:AwardEnergy(world, player, "shield", amt)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(5,100)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
				weight = 0
			end
		end
	end

	local enemy = world:GetEnemy(player)
	local dmg = math.floor(enemy:GetLevel() / 5) + 10
	local amt = math.min(enemy:GetAttribute("shield"), math.floor(enemy:GetLevel() / 5) + 10)
	local wasted = dmg - amt

	if wasted > 0 then
		weight = weight - (wasted * 1) -- x by 1 for clarity of purpose
	end

	local deficit = (player:GetAttribute("shield_max") - player:GetAttribute("shield"))
	local gain = 0

	if deficit >= amt then
		gain = amt
	else
		gain = deficit
	end

	if gain < amt then
		weight = weight - (1 * (amt - gain)) -- x by 1 for clarity of purpose
	end

	if amt >= 16 then
		weight = weight + 15
		if amt == 20 then
			weight = weight + 5
		end
	end

	if amt <= 4 then
		weight = 0
	end

	if weight < 0 then
		weight = 0
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_IUP1";
	weapon_requirement = 14;
	engine_requirement = 8;
	cpu_requirement = 5;
	recharge = 5;
	rarity = 1;
	cost = 16600;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_drone";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
