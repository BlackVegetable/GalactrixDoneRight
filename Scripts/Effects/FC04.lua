-- FC04 --
-- "Combat Stress" -- Reduces both players' auto-repair to 0.

function init_effect(effectObj)
	LOG("Called InitEffect")
end

return {
	name = "[FC04_NAME]";
	desc = "[FC04_DESC]";
	sound = "snd_gravity";
	InitEffect = init_effect
}
