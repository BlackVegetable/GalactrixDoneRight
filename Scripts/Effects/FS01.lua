-- FS01
-- Confusion - Halves pilot's stats

function init_effect(effectObj)
	LOG("Called InitEffect")
	effectObj:GetAttribute("player"):AddCombatStat("gunnery", 0)
end

return {
	name = "[FS01_NAME]";
	desc = "[FS01_DESC]";
	sound = "snd_shieldsdown";
	InitEffect = init_effect
}
