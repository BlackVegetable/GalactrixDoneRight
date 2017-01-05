-- I096
-- Temporal Field - Inflicts Time Warp effect  on the enemy (causing them to miss turns) for 2 turn, +1 turn for every 20 points of Shield I have.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 2 + math.floor(player:GetAttribute("shield") / 20)
	local enemy = world:GetEnemy(player)
	item:AddEffect(world,enemy,"FT06",enemy,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)

	weight = weight + (math.floor(player:GetAttribute("shield") / 20) * 10)

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


	icon = "img_ITS4";
	weapon_requirement = 0;
	engine_requirement = 7;
	cpu_requirement = 6;
	recharge = 7;
	rarity = 2;
	cost = 10000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
