-- I122
-- EM Net - Inflicts your enemy with the Time Warp effect (causing them to miss their turn) for 2 turns.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local enemy = world:GetEnemy(player)
	item:AddEffect(world,enemy,"FT06",enemy,2,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(5,100)
	local enemy = world:GetEnemy(player)

	if enemy:NumAttributes("Effects") > 0 then
		for i=1,enemy:NumAttributes("Effects") do
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT01_NAME]" then
				weight = 0
				break
			end
		end
	end

	if enemy:NumAttributes("Effects") > 0 then
		for i=1,enemy:NumAttributes("Effects") do
			if enemy:GetAttributeAt("Effects", i):GetAttribute("name") == "[FT06_NAME]" then
				weight = 0
				break
			end
		end
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IS5";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 5;
	recharge = 7;
	rarity = 3;
	cost = 3500;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
