-- I313 --
-- Heat Ray -- Lowers enemy "Gunnery" skill to 10% but gradually recovers

local function activate(item, world, player, obj,weapon,engine,cpu)

	local enemy = world:GetEnemy(player)

	item:AddEffect(world,enemy,"FC05",enemy,9,item.classIDStr)

end

local function should_ai_use_item(item, world, player)

	local enemy = world:GetEnemy(player)
	local weight = 0

	weight = 30 + enemy:GetCombatStat("gunnery")

	if enemy:GetCombatStat("gunnery") <= 10 then
		weight = 0
	end

	if enemy:NumAttributes("Effects") >= 1 then
		for i=1,enemy:NumAttributes("Effects") do
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC05_NAME]" then
				weight = 0
				break
			end
		end
	end

	return weight

end

return {
	psi_requirement = 0;

	icon = "img_IEC3";
	weapon_requirement = 6;
	engine_requirement = 0;
	cpu_requirement = 3;
	recharge = 6;
	rarity = 1;
	cost = 2950;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_disruptor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;

	}

