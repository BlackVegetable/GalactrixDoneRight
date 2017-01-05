-- I141
-- Weapons Bot - Drains all Red Energy. Doubles Green Energy.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local amt = player:GetAttribute("weapon")
	item:DeductEnergy(world, player, "weapon", amt)


	item:AwardEnergy(world, player, "cpu", cpu)

	local playerID = player:GetAttribute("player_id")
	world:DrainEffect("weapon",playerID,"cpu",playerID)
end

local function should_ai_use_item(item, world, player)

	local weapon_need = 0
	local cpu_need = 0
	local ship = player:GetAttribute("curr_ship")
	local weight = 0
	local red = player:GetAttribute("weapon")
	local red_max = player:GetAttribute("weapon_max")
	local green_max = player:GetAttribute("cpu_max")
	local green = player:GetAttribute("cpu")

	if ship:NumAttributes("battle_items") >= 1 then
		for i=1,ship:NumAttributes("battle_items") do
			weapon_need = weapon_need + ship:GetAttributeAt("battle_items", i):GetAttribute("weapon_requirement") -- Tally up needed Red
		end
	end

	if ship:NumAttributes("battle_items") >= 1 then
		for i=1,ship:NumAttributes("battle_items") do
			cpu_need = cpu_need + ship:GetAttributeAt("battle_items", i):GetAttribute("cpu_requirement") -- Tally up needed Green
		end
	end

	local fraction = 0
	if weapon_need > 0 then
		fraction = cpu_need / weapon_need -- How much more do you need green than red?  From infinity to 0.
	else
		fraction = cpu_need -- Avoids an infinite value by avoiding a divide by 0.
	end

	if green < 4 then -- If you aren't gaining much to begin with
		weight = 0
	else
		weight = weight + ((green - 7) * 2) -- Use more often when you have more Green to begin with
		if red > 3 then
			weight = weight - (red * 2) -- Use less often when you will lose more Red

			if (red + 1) >= red_max then -- If Red is nearly full
				if fraction <= 1.10 then -- (But only if you need much Red in the first place)
					weight = 0
				end
			end

			if (green * 2) > (green_max + 11) then -- If much of the gained Green energy will be wasted
				weight = 0
			elseif (green * 2) > (green_max + 7) then -- If much (a little less) of the gained Green Energy will be wasted
				weight = weight - 10
			end
		end
	end

	if fraction <= 0.25 then -- The more you need Green, the higher the range of random values.
		weight = 0
	elseif fraction <= 0.50 then
		weight = weight + math.random(1,55)
	elseif fraction <= 0.75 then
		weight = weight + math.random(1,65)
	elseif fraction <= 1.00 then
		weight = weight + math.random(1,70)
	elseif fraction <= 1.25 then
		weight = weight + math.random(1,85)
	elseif fraction <= 1.75 then
		weight = weight + math.random(1,95)
	else
		weight = weight + math.random(10,100)
	end


	return weight

end

return {  psi_requirement = 0;


	icon = "img_IUP2";
	weapon_requirement = 0;
	engine_requirement = 6;
	cpu_requirement = 0;
	recharge = 1;
	rarity = 5;
	cost = 880;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_disruptor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
