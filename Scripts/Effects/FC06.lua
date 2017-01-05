-- FC06 --
-- Engine Fault -- Lowers Engineer by 65% and gives a 20% chance each turn Engine Energy is above 6 to reduce to zero. "Engine Leak"

function init_effect(effectObj)
	LOG("Called InitEffect")
	effectObj:GetAttribute("player"):AddCombatStat("gunnery", 0)

end

return {
	name = "[FC06_NAME]";
	desc = "[FC06_DESC]";
	sound = "snd_disruptor";
	InitEffect = init_effect
}
