
 --Ejects Hero from System
-- Sets curr_loc to valid Jumpgate in system(This is kindof assumed to exist, but won't fall over)
local function FleeSystem(sourceMenu)
	LOG("Flee System")
	local entryGate = _G.Hero:GetAttribute("curr_loc")
	local star = _G.Hero:GetAttribute("curr_system")

	

	local list = _G.DATA.StarTable[star]
	--For each jumpgate j connected with this star

	-- always force encounters on this faction from now until you win a battle against them
	_G.DATA.Factions[STARS[star].faction].forceEncounters = true
	
		
	local gate
	
	if _G.Hero.last_gate and _G.CollectionContainsAttribute(_G.Hero,"hacked_gates",_G.Hero.last_gate) then
		gate = _G.Hero.last_gate
	else--get any open gate
		for i,j in pairs(list) do
			if string.char(string.byte(j))=="J" then
				LOG("push Jumpgate "..j)
				gate = j
				if _G.CollectionContainsAttribute(_G.Hero,"hacked_gates",gate) then
					LOG("Hacked -> Break")
					break
				end			
			end
		end			
	
	end
	
	--[[
	local loc = _G.Hero:GetAttribute("curr_loc")
	-- if curr_loc already set to a gate
	
	
	local numGates = _G.StarList[star]:NumAttributes("jumpgates")
	LOG("Foreach GATE")
	for i=1,numGates do
		gate = _G.StarList[star]:GetAttributeAt("jumpgates",i)
		LOG("check "..gate)
		if _G.CollectionContainsAttribute(_G.Hero,"hacked_gates",gate) then
			LOG("Hacked -> Break")
			break
		end
	end
	--]]
	
	_G.Hero:SetMovementController(nil)
	_G.CallScreenSequencer(sourceMenu, "MapMenu", gate)
end


return FleeSystem