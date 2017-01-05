-- I319 --
-- Critical Trajectory Processor -- Gives a ~25% chance to deal +50% damage, unusable by large ships, lasts 5 Turns + 1/5 Green. Drains Green.

local function activate(item, world, player, obj,weapon,engine,cpu)

	local turns = 5 + math.floor(player:GetAttribute("cpu") / 5)

	for i=1,player:NumAttributes("Effects") do
		if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC10_NAME]" then
			local effect = player:GetAttributeAt("Effects",i)
			GameObjectManager:Destroy(effect)
			break
		end
	end

	item:AddEffect(world,player,"FC10",player,turns,item.classIDStr)
	item:DeductEnergy(world, player, "cpu", player:GetAttribute("cpu"))
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)

	if player:NumAttributes("Effects") >= 1 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC10_NAME]" then
				weight = 0
				break
			end
		end
	end

	return weight

end


return {
	psi_requirement = -1;

	icon = "img_ICB2";
	weapon_requirement = 4;
	engine_requirement = 0;
	cpu_requirement = 8;
	recharge = 7;
	rarity = 1;
	cost = 3400;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_drive";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;

	}

