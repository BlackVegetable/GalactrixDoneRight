-- I069
-- Chronotron Droid - Activates an Chronotron Droid on your ship for 5 turns (causing any Time Warp effect s that make you miss a turn to be deleted automatically).

local function activate(item, world, player, obj,weapon,engine,cpu)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT01_NAME]" then
				local effect = player:GetAttributeAt("Effects",i)
				GameObjectManager:Destroy(effect)
				break
			end
		end
	end

	item:AddEffect(world,player,"FT01",player,5,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local enemy = world:GetEnemy(player)
	local loadout = enemy:GetAttributeAt("ship_list",enemy:GetAttribute("ship_loadout"))
	local use = 0
	local weight = 0

	if CollectionContainsAttribute(loadout,"items","I082") then
		use = use + 1
	end
	if CollectionContainsAttribute(loadout,"items","I096") then
		use = use + 1
	end
	if CollectionContainsAttribute(loadout,"items","I122") then
		use = use + 1
	end
	if CollectionContainsAttribute(loadout,"items","I123") then
		use = use + 1
	end
	if CollectionContainsAttribute(loadout,"items","I127") then
		use = use + 1
	end

	if use ~= 0 then
		weight = math.random(30,100)
	end

	if use > 1 then
		weight = weight + ((use - 1) * 25)
	end

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT01_NAME]" then
				weight = 0
			end
		end
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IUP1";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 1;
	recharge = 5;
	rarity = 1;
	cost = 850;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_droid";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
