-- I311 --
-- Reverse-Engineering Probe -- Reverses the repairs done automatically by engineering to deal damage instead!

local function activate(item, world, player, obj,weapon,engine,cpu)

	local enemy = world:GetEnemy(player)

	item:AddEffect(world,enemy,"FC03",enemy,5,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local enemy = world:GetEnemy(player)
	local weight

	weight = math.random(1,15) + enemy:GetCombatStat("engineer")

	if enemy:GetAttribute("life") <= 10 then
		if enemy:GetCombatStat("engineer") >= 50 then
			weight = weight + 20
		end
	end

	if _G.TOTAL_TURNS >= 50 then
		weight = math.ceil(weight * 0.8)
		if _G.TOTAL_TURNS >= 100 then
			weight = math.ceil(weight * 0.8)
			if _G.TOTAL_TURNS >= 174 then
				weight = 0
			end
		end
	end

	if enemy:GetAttribute("life") == enemy:GetAttribute("life_max") then
		weight = 0
	end

	return weight
end

return {
	psi_requirement = 0;

	icon = "img_ICC4";
	weapon_requirement = 8;
	engine_requirement = 0;
	cpu_requirement = 5;
	recharge = 10;
	rarity = 1;
	cost = 4200;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_probe";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;

	}
