-------------------------------------------------------------------------------
--      Mining Mini-Game  -- Earn enough 3 cargo types before locking board
-------------------------------------------------------------------------------

	
local function Mine(sourceMenu,player1,location,questID,objectiveID)
	
	LOG("Mine() questID="..tostring(questID).."  objectiveID="..tostring(objectiveID))

	player1:SetAttribute('team',1)
	
	local event = GameEventManager:Construct("GameStart")
	
	
	event:PushAttribute('Players',player1)	
	
	local gemList = _G.SATELLITES[location].gemList
	local cargo = _G.SATELLITES[location].cargo
	--local cost = _G.SATELLITES[location].miningCost
	local cost = 0
	local location = _G.SATELLITES[location].classIDStr
	
	
	
	--event:SetAttribute("time_limit",location:GetAttribute("time_limit"))
	
	-- set start events attributes
	-- add participants to event
	-- send event to world	

	

	local function StartMineCallback(confirm)			
		if confirm then
			_G.GLOBAL_FUNCTIONS.Backdrop.Open()
			_G.CallScreenSequencer(sourceMenu, "GameMenu",sourceMenu,player1,"B006",event,questID,objectiveID,gemList,cost,cargo)	
		else
			_G.CallScreenSequencer("MiningIntroMenu", sourceMenu)
		end	
	end

	
	SCREENS.MiningIntroMenu:Open(player1,cost,cargo,StartMineCallback)
		
	return true
end

return Mine
