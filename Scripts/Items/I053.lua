-- I053
-- Mine Array - Applies Minefield to the board for 8 turns (causing all damage gems to double in effect).

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AddEffect(world,player,"FM02",world,8,item.classIDStr)
	_G.BigMessage(world, "[MINE_DAMAGE_DOUBLED]", item.message_x, item.message_input_y)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,90)

	local bg = SCREENS.GameMenu.world
	if bg:NumAttributes("Effects") >= 1 then
		for i=1,bg:NumAttributes("Effects") do
			if bg:GetAttributeAt("Effects", i):GetAttribute("name") == "[FM02_NAME]" then
				weight = 0
			end
		end
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IMN1";
	weapon_requirement = 16;
	engine_requirement = 8;
	cpu_requirement = 3;
	recharge = 5;
	rarity = 2;
	cost = 3120;
	status_on_enemy = 0;
	end_turn = 0;  passive = 0;
	user_input = 0;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
