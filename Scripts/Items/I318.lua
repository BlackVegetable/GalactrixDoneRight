-- I318 --
-- Advanced Position CPU -- Grants +5~12 Damage when matching mines for 5 Turns, affected by ship size. Cancelled by hull damage.  Does not end your turn.

local function activate(item, world, player, obj,weapon,engine,cpu)

	if player:NumAttributes("Effects") >= 1 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC09_NAME]" then
				local effect = player:GetAttributeAt("Effects",i)
				GameObjectManager:Destroy(effect)
				break
			end
		end
	end

	item:AddEffect(world,player,"FC09",player,5,item.classIDStr)

end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)

	if player:GetAttribute("curr_ship"):GetAttribute("max_items") <= 4 then
		weight = weight + 20
	elseif player:GetAttribute("curr_ship"):GetAttribute("max_items") >= 6 then
		weight = weight - 30
	end

	if player:NumAttributes("Effects") >= 1 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC09_NAME]" then
				weight = 0
				break
			end
		end
	end

	return weight

end

return {
	psi_requirement = 0;

	icon = "img_ICC3";
	weapon_requirement = 0;
	engine_requirement = 0;
	cpu_requirement = 10;
	recharge = 4;
	rarity = 1;
	cost = 9000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_amplify";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;

	}
