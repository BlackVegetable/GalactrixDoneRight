-- FC05 --
-- Overheated -- Lowers Gunnery skill by 10 ~ 90%

function init_effect(effectObj)
	LOG("Called InitEffect")
	effectObj:GetAttribute("player"):AddCombatStat("gunnery", 0)

	myHero = effectObj:GetAttribute("player")
	myHero_id = myHero:GetAttribute("player_id")
	if myHero_id == 1 then
		_G.PLAYER_1_COOLANT = 0
	elseif myHero_id == 2 then
		_G.PLAYER_2_COOLANT = 0
	end

end

return {
	name = "[FC05_NAME]";
	desc = "[FC05_DESC]";
	sound = "snd_disruptor";
	InitEffect = init_effect
}
