-- I127
-- Basilisk Net - Inflicts your enemy with the Time Warp effect (causing them to miss their turn) for 2 turns, +1 more turns for every 8 Red Energy they have

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 2 + math.floor(world:GetEnemy(player):GetAttribute("weapon") / 8)
	local enemy = world:GetEnemy(player)
	item:AddEffect(world,enemy,"FT06",enemy,turns,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local enemy = world:GetEnemy(player)
	local red = enemy:GetAttribute("weapon")

	weight = weight + (math.floor(red / 8) * 10)

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


	icon = "img_ITS2";
	weapon_requirement = 5;
	engine_requirement = 5;
	cpu_requirement = 5;
	recharge = 10;
	rarity = 2;
	cost = 13050;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 1;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
