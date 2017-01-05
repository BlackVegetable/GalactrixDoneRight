-- I139
-- Mersenne Transformer - Changes all Gems of a random color into Purple Gems.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gem = world:MPRandom(1,55)
   local gemID = world:GetGem(gem).classIDStr
	while(gemID == "GPSI") do
		--gem = world:MPRandom(1,55)
      gem = gem + 1
      if gem > 55 then
         gem = 1
      end
      gemID = world:GetGem(gem).classIDStr
	end

	local gemList = world:GetGemList(world:GetGem(gem).classIDStr)
	item:TransformGems(world, gemList, false, "GPSI")
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,70)
	local gemList = world:GetGemList("GPSI")

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


	icon = "img_ITS4";
	weapon_requirement = 0;
	engine_requirement = 7;
	cpu_requirement = 0;
	recharge = 3;
	rarity = 2;
	cost = 3490;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_transform";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
	ValidateInput = valid_input;
	GetAIUserInput = get_ai_input;
}
