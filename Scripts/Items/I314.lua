-- I314 --
-- Paralyzation Emitter -- Causes an "Engine Fault" which lowers Engineer skill by 65% and has a chance of losing Engine Energy through a "leak."

local function activate(item, world, player, obj,weapon,engine,cpu)

	local enemy = world:GetEnemy(player)

	item:AddEffect(world,enemy,"FC06",enemy,5,item.classIDStr)

end

local function should_ai_use_item(item, world, player)

	local enemy = world:GetEnemy(player)
	local weight = 0

	weight = 45 + enemy:GetCombatStat("engineer")

	if enemy:GetCombatStat("engineer") <= 20 then
		weight = 0
	end

	if enemy:NumAttributes("Effects") >= 1 then
		for i=1,enemy:NumAttributes("Effects") do
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC06_NAME]" then
				weight = 0
				break
			end
		end
	end

	return weight

end

return {
	psi_requirement = 0;

	icon = "img_ICC5";
	weapon_requirement = 3;
	engine_requirement = 0;
	cpu_requirement = 6;
	recharge = 6;
	rarity = 1;
	cost = 5600;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_disruptor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;

	}
