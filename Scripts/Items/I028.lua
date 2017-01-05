-- I028
-- Psi Transformer - Choose a gem on the board.  All gems of matching color are transformed into purple gems.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemType = obj.classIDStr
	local gemList = world:GetGemList(gemType)
	item:TransformGems(world, gemList, false, "GPSI")
end

local function should_ai_use_item(item, world, player)

end

local function valid_input(item, obj)
	if obj:HasAttribute("isGem") then
		return true
	end
end

local function get_ai_input(item, world, player)
	--AAAAHAHAHAHAH This need work !!!!!!!!!!!!!!!!!!!!!!!!!!!

	local valid = false
	local gem = nil
	while not valid do
		local num = math.random(1,55)
		gem = world:GetGem(num)
		if gem and gem.classIDStr ~= "GPSI" then
			valid = true
		end
	end

	return gem
end

return {  psi_requirement = 0;


	icon = "img_IS5";
	weapon_requirement = 1;
	engine_requirement = 0;
	cpu_requirement = 8;
	recharge = 3;
	rarity = 1;
	cost = 1960;

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
