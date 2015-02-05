
-------------------------------------------------------------------------------
--    SetEncounters  -- inits the enounters when solar system opened
-------------------------------------------------------------------------------
function SetEncounters(sstm, alert)	
	--encounter:SetPos(math.random(_G.MIN_HORIZONTAL,_G.MAX_HORIZONTAL),math.random(_G.MIN_VERTICAL,_G.MAX_VERTICAL))
	
	local sun = SCREENS.SolarSystemMenu.sun
	local faction = sun:GetFaction()
	local tech = sun:GetTechLevel()
	local gov = sun:GetGovernment()
	
	local prob = math.random(1,100)	
	
	local forceNeutral
	if _G.Hero.neutral == _G.Hero:GetCurrSystem() then
		LOG("Generating neutral encounters")
		forceNeutral = true
	end
	
	local enemyList = _G.GLOBAL_FUNCTIONS.GetEnemyList(faction, sun.classIDStr, sun:GetIndustry())

	local num_encounters = 0
	if alert == _G.ALERT_ENCOUNTER then
		local encounter = _G.GLOBAL_FUNCTIONS.GetEncounter(_G.Hero,sstm,faction,alert,enemyList, forceNeutral)
		if encounter then
			num_encounters = 1
			local contraband = false
			if _G.Hero:GetAttributeAt("cargo",_G.CARGO_CONTRABAND) > 0 then
				contraband = true
			end
			encounter:AlertToHero(_G.Hero,contraband)
			sstm:AddChild(encounter.enemy)				
			table.insert(sstm.encounters,encounter)
			encounter:InitMovement(_G.Hero)
			--sstm:DisappearEncounter(encounter)
		end			
	else
		local police = _G.DATA.Governments[gov].law
		if police > 0 then
			local encounter = _G.GLOBAL_FUNCTIONS.GetEncounter(_G.Hero,sstm,faction,police,enemyList, forceNeutral)
			local contraband = _G.Hero:GetAttributeAt("cargo",_G.CARGO_CONTRABAND)
			if contraband > 0 and tech > 2 then
				LOG("contraband "..tostring(contraband))
				if prob <= police then--Randomly Alert police encounter to hero on entering system
					LOG("Set Police Encounter targeting hero")
					if encounter then
						encounter:AlertToHero(_G.Hero,true)
					end
				end
			end
			if encounter then
				num_encounters = 1
				sstm:AddChild(encounter.enemy)				
				table.insert(sstm.encounters,encounter)
				encounter:InitMovement(_G.Hero)
				----sstm:DisappearEncounter(encounter)
			end		
		end
	end

	local min_percentage = 50
	while num_encounters < _G.Hero.num_encounters do
		num_encounters = num_encounters + 1

		--prob = math.random(1,100)	
		--if prob < min_percentage then
			LOG(tostring(prob).." < "..(min_percentage).." = Construct Encounter "..tostring(num_encounters))	
			
			
			local encounter = _G.GLOBAL_FUNCTIONS.GetEncounter(_G.Hero,sstm,faction,nil,enemyList, forceNeutral)
			
			if encounter then
				sstm:AddChild(encounter.enemy)
				table.insert(sstm.encounters,encounter)
				encounter:InitMovement(_G.Hero)
				--sstm:DisappearEncounter(encounter)
				min_percentage = min_percentage - 5
			end
--		else
--			LOG(tostring(prob))					
--		end

	end
	
end
	

return SetEncounters