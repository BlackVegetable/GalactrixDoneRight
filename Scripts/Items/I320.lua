-- I320 --
-- Mobility Core -- Reduce incoming damage by 75% on small ships, ~30% of the time for ~7 Turns, dependent on ship size.

local function activate(item, world, player, obj,weapon,engine,cpu)


	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")
	local turns = 11 - size

	for i=1,player:NumAttributes("Effects") do
		if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC11_NAME]" then
			local effect = player:GetAttributeAt("Effects",i)
			GameObjectManager:Destroy(effect)
			break
		end
	end

	item:AddEffect(world,player,"FC11",player,turns,item.classIDStr)

end

local function should_ai_use_item(item, world, player)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")
	local weight = math.random(1,100)

	if size == 3 then
		weight = weight + 25
	elseif size == 4 then
		weight = weight + 10
	end

	if player:NumAttributes("Effects") >= 1 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC11_NAME]" then
				weight = 0
				break
			end
		end
	end

	return weight

end

return {
	psi_requirement = -1;

	icon = "img_IEC2";
	weapon_requirement = 0;
	engine_requirement = 9;
	cpu_requirement = 1;
	recharge = 5;
	rarity = 1;
	cost = 1350;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_gravity";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;

	}
