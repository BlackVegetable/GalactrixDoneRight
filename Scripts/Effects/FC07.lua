-- FC07 --
-- Manual Control -- Increases Shields by ~50% and decreases Science by ~50%

function init_effect(effectObj)
	LOG("Called InitEffect")
	effectObj:GetAttribute("player"):AddCombatStat("gunnery", 0)

end

return {
	name = "[FC07_NAME]";
	desc = "[FC07_DESC]";
	sound = "snd_upgrade";
	InitEffect = init_effect
}
