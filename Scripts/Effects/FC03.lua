-- FC03 --
-- Reverse-Engineering Probe -- Auto-Repairs deal damage instead of healing (Max: 7)

function init_effect(effectObj)
	LOG("Called InitEffect")
	effectObj:GetAttribute("player"):AddCombatStat("gunnery", 0)
end

return {
	name = "[FC03_NAME]";
	desc = "[FC03_DESC]";
	sound = "snd_probe";
	InitEffect = init_effect
}
