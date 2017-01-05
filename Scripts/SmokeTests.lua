local SmokeTests = {}
local TestingHelpers = require("TestingHelpers")

local function GetRandomAI()
	return _G.GLOBAL_FUNCTIONS.LoadHero.LoadEnemy("HE02", nil, "I007", "I002")
end

function SmokeTests.RunLoopingBattle(runs)
	local numruns = runs or 10000
	_G.smokeTestThread = coroutine.create(function ()
		for i=1,numruns do
			LOG(string.format("SmokeTest: before starting battle there is %dK of memory allocated", collectgarbage("count")))
		
			GLOBAL_FUNCTIONS.Battle.Battle("SinglePlayerMenu", GetRandomAI(), GetRandomAI())
			
			TestingHelpers.WaitForScreen("CombatIntroMenu", 10000)
			TestingHelpers.FakeButtonClick("CombatIntroMenu", "butt_yes")
			
			TestingHelpers.WaitForScreen("CombatResultsMenu", math.huge)
			TestingHelpers.Wait(2000)
			
			TestingHelpers.FakeButtonClick("CombatResultsMenu", "butt_continue")
			TestingHelpers.Wait(2000)
		end
	end)
end

function SmokeTests.Update()
	if _G.smokeTestThread and coroutine.status(_G.smokeTestThread) ~= "dead" then
		local res, msg = coroutine.resume(_G.smokeTestThread)
		if not res then
			error(msg .. debug.traceback(_G.smokeTestThread))
		end
	end
end

return SmokeTests
