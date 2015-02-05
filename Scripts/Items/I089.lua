-- I089
-- Nova Drive - Gives you the Nova effect (Any Nova fills up your energy bars) for 5 turns, +1 more turn for every 4 Yellow Energy you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 5 + math.floor(engine / 4)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FS02_NAME]" then
				local effect = player:GetAttributeAt("Effects",i)
				GameObjectManager:Destroy(effect)
				break
			end
		end
	end

	if size == 3 then
		turns = turns + 3
	elseif size == 4 then
		turns = turns + 2
	elseif size == 5 then
		turns = turns +1
	end

	item:AddEffect(world,player,"FS02",player,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local turns = 5 + math.floor(player:GetAttribute("engine") / 4)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		turns = turns + 3
	elseif size == 4 then
		turns = turns + 2
	elseif size == 5 then
		turns = turns + 1
	end

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FS02_NAME]" then
				weight = 0
				break
			end
		end
	end

	weight = weight + ((turns - 5) * 2)

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IEC4";
	weapon_requirement = 2;
	engine_requirement = 9;
	cpu_requirement = 2;
	recharge = 6;
	rarity = 2;
	cost = 13450;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_drive";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
