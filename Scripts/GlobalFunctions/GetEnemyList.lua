

local function GetEnemyList(faction, system, industry)
	--local lists = { SystemMatch = { }, IndustryMatch = { }, FactionMatch = { } }	
	local known = false
	if CollectionContainsAttribute(_G.Hero,"encountered_factions",faction) then
		known = true
	end
		 
	for i=#_G.DATA.EnemyList,1,-1 do
		--if system == _G.DATA.EnemyList[i].system then
		--	return _G.DATA.EnemyList[i].enemy_list
		--end
		if faction == _G.DATA.EnemyList[i].faction then
			if not known and _G.DATA.EnemyList[i].unknown then--if unknown enemy list exists for this unknown faction.
				return _G.DATA.EnemyList[i].unknown
			elseif industry == _G.DATA.EnemyList[i].industry then
				return _G.DATA.EnemyList[i].enemy_list
			elseif not _G.DATA.EnemyList[i].industry then
				return _G.DATA.EnemyList[i].enemy_list
			end
		end
	end
	return _G.DATA.EnemyList.default.enemy_list
end

return GetEnemyList