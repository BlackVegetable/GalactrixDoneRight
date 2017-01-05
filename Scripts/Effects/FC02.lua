-- FC02
-- Booby-Trapped - Ship takes 30 damage whenever it creates a Supernova

function init_effect(effectObj)
	LOG("Called InitEffect")
	effectObj:GetAttribute("player"):AddCombatStat("gunnery", 0)
end

return {
	name = "[FC02_NAME]";
	desc = "[FC02_DESC]";
	sound = "snd_destroy";
	InitEffect = init_effect
}
