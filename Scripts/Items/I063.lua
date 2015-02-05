-- I063
-- Cluster Bomb - All +10 Mines on the board explode destroying the gems surrounding them.  You gain full effect for each gem destroyed.

local function activate(item, world, player, obj,weapon,engine,cpu)
	local gemList = world:GetGemList("GDMX")
	--for i,v in pairs(gemList) do
	--item:ExplodeGem(world, gemList, true)
	--end
	item:ClearGems(world, item:GetAdjacentGems(world, gemList), true, true)
end

local function should_ai_use_item(item, world, player)

	local weight = math.random(1,100)
	local gemList = world:GetGemList("GDMX")
	if #gemList == 0 then
		weight = 0
	else
		weight = weight - 25 + (#gemList * 20)
	end

	if weight < 0 then
		weight = 0
	end

	return weight

end

return {  psi_requirement = 0;


	icon = "img_IMN1";
	weapon_requirement = 20;
	engine_requirement = 4;
	cpu_requirement = 4;
	recharge = 8;
	rarity = 2;
	cost = 18200;
	status_on_enemy = 0;
	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_bomb";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
