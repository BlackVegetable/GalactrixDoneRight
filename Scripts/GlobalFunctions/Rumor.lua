
------------------------------------------------------------------------------
-- Rumor mini-game - stay alive for as many moves as possible to gain some
-- hawt gossip.  You die if you match the bad gems!
------------------------------------------------------------------------------
local function RumorGame(sourceMenu, player1, location,questID,objectiveID)
	
	player1:SetAttribute('team', 1)
	
	local event = GameEventManager:Construct("GameStart")
	event:PushAttribute('Players', player1)
	
	local rumor = string.format("R%03d", _G.SATELLITES[location].rumor)
	local cost = _G.SATELLITES[location].moves
	local award = _G.SATELLITES[location].intel
	
	local function StartRumorCallback(confirm)
		if confirm then
			_G.GLOBAL_FUNCTIONS.Backdrop.Open()
			_G.CallScreenSequencer(sourceMenu, "GameMenu", sourceMenu, player1, "B011", event,questID,objectiveID, nil, nil, nil, nil, rumor, cost, award)			
		else
			_G.CallScreenSequencer("RumorIntroMenu", sourceMenu)
		end
	end

	SCREENS.RumorIntroMenu:Open(StartRumorCallback, rumor, cost)
	return true
end

return RumorGame