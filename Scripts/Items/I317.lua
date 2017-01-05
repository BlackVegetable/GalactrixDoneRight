-- I317 --
-- Optimal Position CPU -- Grants +2~9 Damage when matching mines for 3~4 Turns, affected by ship size. Cancelled by hull damage.  Does not end your turn.

local function activate(item, world, player, obj,weapon,engine,cpu)

	if player:NumAttributes("Effects") >= 1 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC08_NAME]" then
				local effect = player:GetAttributeAt("Effects",i)
				GameObjectManager:Destroy(effect)
				break
			end
		end
	end

	local turns = 3
	local sci = player:GetCombatStat("science")
	local bonusWeight = 0

	if sci < 50 then
		bonusWeight = 0
	elseif sci <= 99 then
		bonusWeight = 10
	elseif sci <= 149 then
		bonusWeight = 20
	elseif sci <= 199 then
		bonusWeight = 30
	else
		bonusWeight = 40
	end


	if math.random(1,100) <= (50 + bonusWeight) then
		turns = 4
	end

	item:AddEffect(world,player,"FC08",player,turns,item.classIDStr)

end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)

	if player:GetAttribute("curr_ship"):GetAttribute("max_items") <= 4 then
		weight = weight + 20
	elseif player:GetAttribute("curr_ship"):GetAttribute("max_items") >= 6 then
		weight = weight - 30
	end

	if player:GetCombatStat("science") < 50 then
		weight = weight - 3
	elseif player:GetCombatStat("science") >= 150 then
		weight = weight + 3
	end

	if player:NumAttributes("Effects") >= 1 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC08_NAME]" then
				weight = 0
				break
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

	icon = "img_ICC3";
	weapon_requirement = 0;
	engine_requirement = 0;
	cpu_requirement = 10;
	recharge = 4;
	rarity = 1;
	cost = 7000;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_amplify";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;

	}
