-- I157 - Pirates Special
-- Bola Mines - doubles the number of mines in play

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GDMG")
	LOG("STAGE 1")
	gemList = world:GetGemList("GDM3",gemList)
	LOG("STAGE 2")
	gemList = world:GetGemList("GDM5",gemList)
	LOG("STAGE 3")
	gemList = world:GetGemList("GDMX",gemList)
	LOG("STAGE 4")

	local numgems

	if(#gemList >= 28)then
		numgems = 55 - #gemList
	else
		numgems = #gemList
	end

	--Balance Mod Edit--
	if numgems >= 8 then
		numgems = 8
	end

	gemList = item:GetRandomGems(numgems, {"GDMG", "GDM3", "GDM5", "GDMX"}, world)
	LOG("STAGE 5")
	item:TransformGems(world, gemList, true, "GDMG")
	LOG("STAGE 6")
end

local function should_ai_use_item(item, world, player)

	local aiLevel = player:GetLevel()

	local gemList = world:GetGemList("GDMG")
	gemList = world:GetGemList("GDM3",gemList)
	gemList = world:GetGemList("GDM5",gemList)
	gemList = world:GetGemList("GDMX",gemList)
	local numGems = #gemList
	if aiLevel < 10 then
		if numGems < 6 then
			return 110
		else
			return 65
		end
	end
	if numGems <= 0 then
		return 0
	elseif numGems < 4 then
		return 65
	elseif numGems < 8 then
		return 85
	else
		return 110
	end
end

return {  psi_requirement = 0;


	icon = "img_IS1";
	weapon_requirement = 9;
	engine_requirement = 4;
	cpu_requirement = 0;
	recharge = 5;
	rarity = 10;
	cost = 18000;

	end_turn = 1;  passive = 0;
	user_input = 0;
	status_on_enemy = 0;
	activation_sound = "snd_capacitor";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
