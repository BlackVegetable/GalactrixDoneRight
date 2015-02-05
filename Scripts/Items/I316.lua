-- I316 --
-- Manual Control Chip -- Increases Pilot Skill by ~50%, Decreases Science Skill by ~50%, for 10 turns, affected by ship size.

local function activate(item, world, player, obj,weapon,engine,cpu)

 -- Ship Size Effect modified in Hero.lua --
	item:AddEffect(world,player,"FC07",player,10,item.classIDStr)

end

local function should_ai_use_item(item, world, player)

	local weight

	weight = player:GetCombatStat("pilot") - player:GetCombatStat("science")

	if player:GetCombatStat("pilot") >= 200 then
		if player:GetCombatStat("science") >= 50 then
			weight = 0
		end
	end

	if player:NumAttributes("Effects") >= 1 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC07_NAME]" then
				weight = 0
				break
			end
		end
	end

	return weight

end

return {
	psi_requirement = 0;

	icon = "img_ICB4";
	weapon_requirement = 0;
	engine_requirement = 5;
	cpu_requirement = 1;
	recharge = 8;
	rarity = 1;
	cost = 3500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_upgrade";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;

	}



