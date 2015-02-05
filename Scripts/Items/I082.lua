-- I082
-- Temporal Probe - Inflicts Time Warp effect  on the enemy (causing them to miss turns) for 2 turn, +1 turn per 10 Yellow Energy you have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 2 + math.floor(engine / 10)
	local enemy = world:GetEnemy(player)
	item:AddEffect(world,enemy,"FT06",enemy,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,90)

	weight = weight + (math.floor(player:GetAttribute("engine") / 10) * 10)

	local enemy = world:GetEnemy(player)

	if enemy:NumAttributes("Effects") > 0 then
		for i=1,enemy:NumAttributes("Effects") do
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT01_NAME]" then
				weight = 0
				break
			end
		end
	end


	return weight

end

return {  psi_requirement = 0;


	icon = "img_ICB4";
	weapon_requirement = 0;
	engine_requirement = 12;
	cpu_requirement = 1;
	recharge = 7;
	rarity = 1;
	cost = 14890;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_probe";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
