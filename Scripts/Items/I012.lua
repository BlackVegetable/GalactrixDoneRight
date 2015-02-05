-- I012
-- Weapons Matrix - Adds +5 to red energy.  Does not end your turn.

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AwardEnergy(world, player, "weapon", 5)
end

local function should_ai_use_item(item, world, player)
	--if player:GetAttribute("weapon") + 5 > player:GetAttribute("weapon_max") then
	---	return 0
	---else
	---	return math.random(1,80)
	---end

	local weapon_need = 0
	local ship = player:GetAttribute("curr_ship")
	local weight = 0

	if ship:NumAttributes("battle_items") >= 1 then
		for i=1,ship:NumAttributes("battle_items") do
			weapon_need = weapon_need + ship:GetAttributeAt("battle_items", i):GetAttribute("weapon_requirement")
		end
	end

	if (weapon_need / ship:GetAttribute("weapons_rating")) <= 0.2 then
		weight = math.random(1,20)
	elseif (weapon_need / ship:GetAttribute("weapons_rating")) <= 0.4 then
		weight = math.random(1,45)
	elseif (weapon_need / ship:GetAttribute("weapons_rating")) <= 0.6 then
		weight = math.random(1,65)
	elseif (weapon_need / ship:GetAttribute("weapons_rating")) <= 0.8 then
		weight = math.random(1,85)
	elseif (weapon_need / ship:GetAttribute("weapons_rating")) <= 1 then
		weight = math.random(15,85)
	end

	if player:GetAttribute("weapon") + 5 > player:GetAttribute("weapon_max") then
		weight = 0
	elseif
		player:GetAttribute("weapon") < 6 then
		weight = weight + 15
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_IS3";
	weapon_requirement = 0;
	engine_requirement = 8;
	cpu_requirement = 5;
	recharge = 0;
	rarity = 5;
	cost = 4000;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_gemred";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
