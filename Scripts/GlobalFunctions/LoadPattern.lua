
use_safeglobals()

local function LoadPattern(patternID,pattern)	
	LOG("Load Pattern "..patternID)
	if not pattern then
		pattern = GameObjectManager:Construct(_G.PATTERNS[patternID].obj)
	end
	if _G.PATTERNS[patternID].award then
		pattern:SetAttribute("award",_G.PATTERNS[patternID].award)
	end
	if _G.PATTERNS[patternID].bonus then	
		pattern:SetAttribute("bonus",_G.PATTERNS[patternID].bonus)
	end
	if _G.PATTERNS[patternID].multiplier then	
		pattern:SetAttribute("multiplier",_G.PATTERNS[patternID].multiplier)
	end
	if _G.PATTERNS[patternID].name then	
		pattern:SetAttribute("name",_G.PATTERNS[patternID].name)
	end
	if _G.PATTERNS[patternID].message then	
		pattern:SetAttribute("message",_G.PATTERNS[patternID].message)	
	end
	if _G.PATTERNS[patternID].extra_turn then	
		pattern:SetAttribute("extra_turn",_G.PATTERNS[patternID].extra_turn)
	end
	if _G.PATTERNS[patternID].award_delay then	
		pattern:SetAttribute("award_delay",_G.PATTERNS[patternID].award_delay)
	end
	if _G.PATTERNS[patternID].time_bonus then	
		pattern:SetAttribute("time_bonus",_G.PATTERNS[patternID].time_bonus)
	end
	if _G.PATTERNS[patternID].len then	
		pattern:SetAttribute("len",_G.PATTERNS[patternID].len)
	end

	if _G.PATTERNS[patternID].pattern then	
		pattern.pattern = _G.PATTERNS[patternID].pattern
	end
	if _G.PATTERNS[patternID].center then	
			pattern.pattern = _G.PATTERNS[patternID].center
	end	
	if _G.PATTERNS[patternID].min_gems then	
		pattern.pattern = _G.PATTERNS[patternID].min_gems
	end	
	if _G.PATTERNS[patternID].hackGem then	
		pattern.pattern = _G.PATTERNS[patternID].hackGem
	end	
	if _G.PATTERNS[patternID].hackID then	
		pattern.pattern = _G.PATTERNS[patternID].hackID
	end	
	if _G.PATTERNS[patternID].board then	
		pattern.pattern = _G.PATTERNS[patternID].board
	end	
	pattern.classIDStr = patternID
	
	return pattern
end

return LoadPattern