-- FG01
-- Anti-Gravity - Gems fall upwards

local function get_gravity(effectObj, battleGround, gravity)
	PlaySound(effectObj:GetAttribute("sound"))
	
	if battleGround.turn.chainCount > 1 then
		return gravity
	else
		return 1
	end	
end

return {
	name = "[FG01_NAME]";
	desc = "[FG01_DESC]";
	sound = "snd_gravitypull";
	GetGravity = get_gravity;
}
