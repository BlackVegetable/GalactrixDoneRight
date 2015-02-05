-- FG03
-- Gravity - Gems fall downwards

local function get_gravity(effectObj, battleGround, gravity)
	PlaySound(effectObj:GetAttribute("sound"))
	
	if battleGround.turn.chainCount > 1 then
		return gravity
	else
		return 4
	end
end

return {
	name = "[FG03_NAME]";
	desc = "[FG03_DESC]";
	sound = "snd_gravitypull";
	GetGravity = get_gravity;
}
