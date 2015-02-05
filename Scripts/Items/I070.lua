-- I070
-- Guardian Droid - Activates a Guardian Droid on your ship for 5 turns (causing all damage to be halved if your Shield Energy is greater than 0).

local function activate(item, world, player, obj,weapon,engine,cpu)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FD05_NAME]" then
				local effect = player:GetAttributeAt("Effects",i)
				GameObjectManager:Destroy(effect)
				break
			end
		end
	end

	item:AddEffect(world,player,"FD05",player,5,item.classIDStr)


end

local function should_ai_use_item(item, world, player)

	local weight
	local shield = player:GetAttribute("shield")
	local max = player:GetAttribute("shield_max")

	weight =  math.floor((shield/max)*100) - math.random(15,40)
	if weight < 0 then
		weight = 0
	end

	if shield > 0 then
		if player:NumAttributes("Effects") > 0 then
			for i=1,player:NumAttributes("Effects") do
				if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FD06_NAME]" then
					weight = weight + 20
				end
			end
		end
	end

	return weight
end

return {  psi_requirement = 0;


	icon = "img_ITS3";
	weapon_requirement = 0;
	engine_requirement = 14;
	cpu_requirement = 5;
	recharge = 5;
	rarity = 3;
	cost = 15000;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_droid";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
