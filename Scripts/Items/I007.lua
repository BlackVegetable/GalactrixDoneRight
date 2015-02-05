-- I007
-- Auxiliary Plating - Drains energy from other systems to reinforce your shields for 6 turns.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)

	local ship = player:GetAttribute("curr_ship")
	local size = ship:GetAttribute("max_items")

	for i=1,player:NumAttributes("Effects") do
		if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE01_NAME]" then
			local effect = player:GetAttributeAt("Effects",i)
			GameObjectManager:Destroy(effect)
			break
		end
	end

	if size == 3 then
		turns = turns + 2
	elseif size == 4 then
		turns = turns + 1
	end

	item:AddEffect(world,player,"FE01",player,6,item.classIDStr)
end

local function should_ai_use_item(item, world, player)
	local shield = player:GetAttribute("shield") / player:GetAttribute("shield_max")*100

	for i=1,player:NumAttributes("Effects") do
		if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FE03_NAME]" then
			return 0
		end
	end

	if world.gemCounts["GSHD"] then
		shield = shield + #world.gemCounts["GSHD"]
	end
	return 90 - shield
end

return {  psi_requirement = 0;


	icon = "img_IFT1";
	weapon_requirement = 0;
	engine_requirement = 7;
	cpu_requirement = 5;
	recharge = 9;
	rarity = 4;
	cost = 2500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;

	activation_sound = "snd_shieldsup";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
