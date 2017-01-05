-- I086
-- Mass Drive - Gives you the Mass Driver effect (adds +1 Damage for every 2 Yellow Gems in play) for 6 turns.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 6
	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	for i=1,player:NumAttributes("Effects") do
		if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FD07_NAME]" then
			local effect = player:GetAttributeAt("Effects",i)
			GameObjectManager:Destroy(effect)
			break
		end
	end

	if size == 3 then
		turns = turns + 3
	elseif size == 4 then
		turns = turns + 2
	elseif size == 5 then
		turns = turns +1
	end

	item:AddEffect(world,player,"FD07",player,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)

	local gemList = world:GetGemList("GENG")

	if #gemList < 2 then
		weight = 0
	else
		weight = weight + (math.floor((#gemList - 2) / 2) * 10)
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IEC1";
	weapon_requirement = 3;
	engine_requirement = 8;
	cpu_requirement = 0;
	recharge = 6;
	rarity = 2;
	cost = 6550;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_drive";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
