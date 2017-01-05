
-------------------------------------------------------------------------------
--    Hacking Mini-Game  -- collect X number of Commodity Gems in Y time_limit
--    location = satellite object Hero is going to mine
-------------------------------------------------------------------------------

local function Hack(sourceMenu,player1,location,questID,objectiveID)


	player1:SetAttribute('team',1)
	local sci = _G.Hero:GetCombatStat("science")
	local sciHack = _G.GLOBAL_FUNCTIONS.ScienceHackingBonus(sci)
	local keys = _G.GATES[location].keys - sciHack
	local time = _G.GATES[location].time
	player1:SetAttribute("seq_length",keys)


	local function GamePadTime()
		time =  math.floor(time * 1.4)
	end
	_G.XBoxOnly(GamePadTime)


	--player2 = GameObjectManager:Construct("HS01")--Simulatron 5000
	--player2:SetAttribute('team',2)


	local event = GameEventManager:Construct("GameStart")


	event:PushAttribute('Players',player1)
	--event:PushAttribute('Players',player2)
	event:SetAttribute("time_limit", time)

	-- set start events attributes
	-- add participants to event
	-- send event to world
	local function StartHackCallback(confirm)
		if confirm then
			--StartHack(sourceMenu,player1,event,questID,objectiveID)
			_G.GLOBAL_FUNCTIONS.Backdrop.Open()
			_G.CallScreenSequencer(sourceMenu, "GameMenu",sourceMenu,player1,"B002",event,questID,objectiveID)
		else
			SCREENS[sourceMenu]:GetWorld():DeselectSatellite()
		end
	end

	SCREENS.HackIntroMenu:Open(StartHackCallback,keys,time)

	return true
end


return Hack
