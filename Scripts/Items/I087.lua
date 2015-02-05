-- I087
-- Temporal Drive - Gives you the Time Loop effect (25% chance of an extra turn) for 4 turns, +1 more turn for every 8 Yellow Energy you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 4 + math.floor(engine / 8)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT05_NAME]" then
				local effect = player:GetAttributeAt("Effects",i)
				GameObjectManager:Destroy(effect)
				break
			end
		end
	end

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		turns = turns + 3
	elseif size == 4 then
		turns = turns + 2
	elseif size == 5 then
		turns = turns + 1
	end

	item:AddEffect(world,player,"FT05",player,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local turns = 4 + math.floor(player:GetAttribute("engine") / 8)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		turns = turns + 3
	elseif size == 4 then
		turns = turns + 2
	elseif size == 5 then
		turns = turns + 1
	end

	weight = weight + ((turns - 4) * 4)

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IEC1";
	weapon_requirement = 0;
	engine_requirement = 8;
	cpu_requirement = 0;
	recharge = 9;
	rarity = 3;
	cost = 2930;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_drive";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
