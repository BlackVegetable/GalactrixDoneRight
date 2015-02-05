-- Engine Efficiency -- Calculates the bonus Red, Green, Yellow energy generated at the start of every turn.

local function EngineEfficiency(engineer)

local EngineEfficiency = math.floor((engineer - 25) / 50)
	if EngineEfficiency < 0 then
		EngineEfficiency = 0
		return EngineEfficiency
	end
return EngineEfficiency
end
return EngineEfficiency

