-- I138
-- Photonic Transformer - Select a gem then convert all gems of matching color to white.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemType = obj.classIDStr
	local gemList = world:GetGemList(gemType)

	item:TransformGems(world, gemList, false, "GINT")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,70)
	local gemList = world:GetGemList("GINT")

	if #gemList < 5 then
		weight = 0
	else
		weight = weight + ((#gemList - 5) * 4)
	end

	return weight


end

function valid_input(item,obj)
	if obj:HasAttribute("isGem") then
		return true
	end
end

return {  psi_requirement = 0;


	icon = "img_ITS1";
	weapon_requirement = 0;
	engine_requirement = 7;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 2;
	cost = 2990;

	end_turn = 1;  passive = 0;
	user_input = _G.STATE_USER_INPUT_GEM;
	input_msg = "[SELECT_GEM]";
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
	ValidateInput = valid_input;
	GetAIUserInput = get_ai_input;
}
