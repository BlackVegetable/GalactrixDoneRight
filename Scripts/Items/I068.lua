-- I068
-- Interceptor Drone - Activates an Interceptor Drone on your ship for 5 turns (causing all incoming damage of 3+ to  be reduced by 5 points).

local function activate(item, world, player, obj,weapon,engine,cpu)

	if player:NumAttributes("Effects") > 0 then
		for i=1,player:NumAttributes("Effects") do
			if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FD06_NAME]" then
				local effect = player:GetAttributeAt("Effects",i)
				GameObjectManager:Destroy(effect)
				break
			end
		end
	end
	item:AddEffect(world,player,"FD06",player,5,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)

	if player:GetAttribute("shield") > 0 then
		if player:NumAttributes("Effects") > 0 then
			for i=1,player:NumAttributes("Effects") do
				if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FD05_NAME]" then
					weight = weight + 20
					break
				end
			end
		end
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IUP2";
	weapon_requirement = 6;
	engine_requirement = 6;
	cpu_requirement = 1;
	recharge = 5;
	rarity = 2;
	cost = 7500;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_droid";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
