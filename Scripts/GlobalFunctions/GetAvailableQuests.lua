
local function GetAvailableQuestsAtLoc(starID,locID)
	
	local t = {}
	for i,a in IterateCollection(_G.Hero, "available_quests") do
		if _G.DATA.QuestStart[a] == starID and _G.QUESTS[a].start_locations[locID] then
			t[#t+1] = a -- append
		end
	end
	return t
	
	--[[
	local quests = {}
	for i=1,_G.Hero:NumAttributes("available_quests") do
		local questID = _G.Hero:GetAttributeAt("available_quests", i)
		local star = _G.DATA.QuestStart[questID]	
		if star == starID then
			if _G.QUESTS[questID].start_locations[locID] then
				table.insert(quests,questID)
			end
		end
	end
	return quests
	--]]
end

return GetAvailableQuestsAtLoc;