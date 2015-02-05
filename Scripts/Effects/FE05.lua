-- FE05
-- Solar Flare - Matching Red, Green, or Blue gems gives you +2 Yellow Energy

local function receive_energy(effectObj, event)
	local effect = event:GetAttribute("effect")
	if effect == "weapon" or effect == "cpu" or effect == "shield" then
		local player = effectObj:GetAttribute("player")
		local world = SCREENS.GameMenu.world
		effectObj:AwardEnergy(player, "engine", 2)
		PlaySound(effectObj:GetAttribute("sound"))
	end
end


return {
	name = "[FE05_NAME]";
	desc = "[FE05_DESC]";
	sound = "snd_amplify";
	ReceiveEnergy = receive_energy;
}
