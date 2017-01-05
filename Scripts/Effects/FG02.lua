-- FG02
-- Grav-Flux - Gems fall in random directions

local function get_gravity(effectObj, battleGround, gravity)
	PlaySound(effectObj:GetAttribute("sound"))
	return battleGround:MPRandom(1,6)
end

return {
	name = "[FG02_NAME]";
	desc = "[FG02_DESC]";
	sound = "snd_gravitypull";
	GetGravity = get_gravity;
}
