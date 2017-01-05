-- I088
-- Solar Drive - Gives you the Solar Flare effect (matching Red, Green or Blue gems gives you +2 Yellow Energy) for 5 turns.

local function activate(item, world, player, obj,weapon,engine,cpu)

	local turns = 5
	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC10_NAME]" then
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

	item:AddEffect(world,player,"FE05",player,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local turns = 5

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		turns = turns + 3
	elseif size == 4 then
		turns = turns + 2
	elseif size == 5 then
		turns = turns + 1
	end

	weight = weight + ((turns - 5) * 5)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FC10_NAME]" then
				weight = 0
				break
			end
		end
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IEC5";
	weapon_requirement = 0;
	engine_requirement = 8;
	cpu_requirement = 0;
	recharge = 5;
	rarity = 7;
	cost = 970;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_drive";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
