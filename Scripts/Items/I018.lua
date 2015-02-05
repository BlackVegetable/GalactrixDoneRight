-- I018
-- Basic Thruster - Destroys a single gem of your choice on the board.   You gain full effect for the gem destroyed

local function activate(item, world, player, obj,weapon,engine,cpu)
	local index = world:GetGemFromPos(obj:GetX(), obj:GetY())
	local gemList = { index }
	item:ClearGems(world,gemList,true)
end

local function should_ai_use_item(item, world, player)
	return math.random(1,70)
end

local function valid_input(item, obj)
	if obj:HasAttribute("isGem") then
		return true
	end
end

local function get_ai_input(item, world, player)
	local gemID = math.random(1,55)
	world:SelectGem(gemID)
	LOG(string.format("%s %s %s", "AI Select Gem", world:GetGem(gridID).classIDStr,tostring(gridID)))
	return world:GetGem(gridID)
end

return {  psi_requirement = 0;


	icon = "img_IT1";
	weapon_requirement = 0;
	engine_requirement =3;
	cpu_requirement = 2;
	recharge = 3;
	rarity = 9;
	cost = 1000;

	end_turn = 1;  passive = 0;
	user_input = _G.STATE_USER_INPUT_GEM;
	input_msg = "[SELECT_GEM]";

	activation_sound = "snd_capacitor";
	recharged_sound = "snd_recharge";
	status_on_enemy = 0;
	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
	ValidateInput = valid_input;
	GetAIUserInput = get_ai_input;
}
