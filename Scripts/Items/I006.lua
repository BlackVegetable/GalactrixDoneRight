-- I006
-- Multiphase Thruster - Destroys all gem of matching color to the one chosen. You gain full effect for all gems destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemType = obj.classIDStr
	local gemList = world:GetGemList(gemType)

	item:ClearGems(world,gemList,true,true)
end

local function should_ai_use_item(item, world, player)
	local numGems = 0
	for i,v in pairs(world.gemCounts) do
		if v > numGems then
			numGems = v
		end
	end
	return math.min(80, numGems*13)
end

function valid_input(item,obj)
	if obj:HasAttribute("isGem") then
		return true
	end
end

function get_ai_input(item,world,player)
	local gemWeights = {}
	local max = 0
	local gridID = 1
	local prefList = player:GetPrefList(world)

	for i,v in pairs(world.gemCounts) do
		local count = #v
		LOG(i.." "..tostring(count))
		gemWeights[i] = prefList[GEMS[i].effect] * count
		if gemWeights[i] > max then
			gridID=v[math.random(1,count)]
			max = gemWeights[i]
		end
	end
	--Highlight selected Gem
	world:SelectGem(gridID)

	LOG("AI Select Gem "..world:GetGem(gridID).classIDStr.." "..tostring(gridID))

	return world:GetGem(gridID)
end

return {  psi_requirement = 0;


	icon = "img_IT3";
	weapon_requirement = 3;
	engine_requirement = 5;
	cpu_requirement = 2;
	recharge = 5;
	rarity = 3;
	cost = 5600;

	end_turn = 1;  passive = 0;
	user_input = _G.STATE_USER_INPUT_GEM;
	input_msg = "[SELECT_GEM]";
	status_on_enemy = 0;

	activation_sound = "snd_destroy";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
	ValidateInput = valid_input;
	GetAIUserInput = get_ai_input;
}
