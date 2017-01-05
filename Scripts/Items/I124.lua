-- I124
-- Adaptive Plating - Gives you the Adapative Armor effect (20% chance to reduce incoming damage to 1 point) for 4 turns, +1 more for every 5 Green Energy you have

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 4 + math.floor(cpu / 5)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	if size == 3 then
		turns = turns + 2
	elseif size == 4 then
		turns = turns + 1
	end

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FD01_NAME]" then
				local effect = player:GetAttributeAt("Effects",i)
				GameObjectManager:Destroy(effect)
				break
			end
		end
	end

	item:AddEffect(world,player,"FD01",player,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local green = player:GetAttribute("cpu")

	weight = weight - 14 + (math.floor(green / 5) * 7)

	if size == 3 then
		weight = weight + 10
	elseif size == 4 then
		weight = weight + 5
	end

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FD01_NAME]" then
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

return {  psi_requirement = 0;


	icon = "img_IFT2";
	weapon_requirement = 0;
	engine_requirement = 0;
	cpu_requirement = 7;
	recharge = 5;
	rarity = 2;
	cost = 7600;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_shieldsup";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
