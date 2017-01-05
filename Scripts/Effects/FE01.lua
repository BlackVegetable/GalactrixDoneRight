-- FE01
-- Auxiliary Plating - Incoming Red, Yellow, and Green Energy is partially diverted to shields

local function receive_energy(effectObj, event)
    local effect = event:GetAttribute("effect")
    local amount = event:GetAttribute("amount")
	local player = effectObj:GetAttribute("player")
    local playerID = player:GetAttribute("player_id")
	
	LOG(string.format("%s - %d", effect, amount))
	if effect ~= "shield" then
		event:SetAttribute("amount",amount - 1)
		effectObj:AwardEnergy(player, "shield", 1,true)
		PlaySound(effectObj:GetAttribute("sound"))
		local battleGround = _G.SCREENS.GameMenu.world
					
		battleGround:DrainEffect(effect,playerID,"shield",playerID)	
	end
end

return {
	name = "[FE01_NAME]";
	desc = "[FE01_DESC]";
	sound = "snd_shieldsup";
	ReceiveEnergy = receive_energy;
}
