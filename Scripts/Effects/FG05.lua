-- FG05
-- Zero Gravity - Gems fall in the opposite direction to your last move

local function get_gravity(effectObj, battleGround, gravity)
	PlaySound(effectObj:GetAttribute("sound"))
	return battleGround.inverseDir[gravity]
end

return {
	name = "[FG05_NAME]";
	desc = "[FG05_DESC]";
	sound = "snd_gravitypull";
	GetGravity = get_gravity;
}
