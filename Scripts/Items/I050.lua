-- I050
-- Anti-Grav Array - Applies Anti-Gravity to the board for 5 turns (causing gems to fall upwards).

local function activate(item, world, player, obj,weapon,engine,cpu)
	item:AddEffect(world,player,"FG01",world,5,item.classIDStr)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,90)

	local bg = SCREENS.GameMenu.world
	if bg:NumAttributes("Effects") >= 1 then
		for i=1,bg:NumAttributes("Effects") do
			if bg:GetAttributeAt("Effects", i):GetAttribute("name") == "[FG01_NAME]" then
				weight = 0
			end
		end
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_ITS3";
	weapon_requirement = 0;
	engine_requirement = 4;
	cpu_requirement = 0;
	recharge = 7;
	rarity = 3;
	cost = 700;

	end_turn = 0;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_gravity";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
