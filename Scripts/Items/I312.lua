-- I312 --
-- Angst Machine -- Sets both ships' auto-repair to 0 for 5 + Green / 5 Turns.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 5 + math.floor(player:GetAttribute("cpu") / 5)

	item:AddEffect(world,player,"FC04",world,turns,item.classIDStr)

end

local function should_ai_use_item(item, world, player)
	local enemy = world:GetEnemy(player)
	local weight = 30 + math.floor((enemy:GetCombatStat("engineer") - player:GetCombatStat("engineer") / 25) * 18)
	if _G.TOTAL_TURNS >= 51 then
		weight = math.ceil(weight * 0.8)
		if _G.TOTAL_TURNS >= 101 then
			weight = math.ceil(weight * 0.8)
			if _G.TOTAL_TURNS >= 175 then
				weight = 0
			end
		end
	end
	if weight < 0 then
		weight = 0
	end
	return weight

end

return {
	psi_requirement = 0;

	icon = "img_IFT5";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 5;
	recharge = 9;
	rarity = 1;
	cost = 1950;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_gravity";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;

	}
