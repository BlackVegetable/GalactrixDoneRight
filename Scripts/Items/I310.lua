-- I310
-- Contingency Tool - Inflicts "Booby-Trapped" on enemy which will deal 20 damage when they create a supernova and 10 for each nova (for E/8 + 6 turns)

local function activate(item, world, player, obj,weapon,engine,cpu)

	local turns = math.floor(player:GetAttribute("engine") / 8) + 6
	local enemy = world:GetEnemy(player)

	item:AddEffect(world,enemy,"FC02",enemy,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local enemy = world:GetEnemy(player)
	local weight = math.random(1,100)

	if enemy:NumAttributes("Effects") >= 1 then
		for i=1,enemy:NumAttributes("Effects") do
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC02_NAME]" then
				weight = 0
				break
			end
		end
	end

	return weight
end

return {
	psi_requirement = 0;

	icon = "img_IMN2";
	weapon_requirement = 2;
	engine_requirement = 5;
	cpu_requirement = 2;
	recharge = 5;
	rarity = 1;
	cost = 6000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;

	}
