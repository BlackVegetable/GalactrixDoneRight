-- FG04
-- Linear Grav-Flux - Gems fall in a rotating pattern

local function get_gravity(effectObj, battleGround, gravity)
	if battleGround:GetEnemy(effectObj:GetAttribute("player")) == battleGround:GetCurrPlayer() then	
		--gravity = gravity + battleGround.turn.chainCount
		gravity = gravity + 1
	
		while gravity > 6 do
			gravity = gravity - 6
		end
		PlaySound(effectObj:GetAttribute("sound"))
	end
	
	return gravity
end

return {
	name = "[FG04_NAME]";
	desc = "[FG04_DESC]";
	sound = "snd_gravitypull";
	GetGravity = get_gravity;
}
