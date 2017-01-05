-- FE03
-- Disruptor - Unable to regenerate shields

local function receive_energy(effectObj, event)
	if event:GetAttribute("effect") == "shield" then
		event:SetAttribute("amount", 0)
		PlaySound(effectObj:GetAttribute("sound"))
	end
end


return {
	name = "[FE03_NAME]";
	desc = "[FE03_DESC]";
	sound = "snd_shieldsdown";
	ReceiveEnergy = receive_energy;
}
