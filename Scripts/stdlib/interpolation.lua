
-- different interpolation techniques


--require "import"
use_safeglobals()

function _G.lerp(t, startTime, duration, startParam, endParam)
	
	if t < startTime then
		return startParam
	end
	if t > startTime+duration then
		return endParam
	end
	
	local offset = (t-startTime)*(endParam-startParam)/duration
	
	return startParam+offset
end
