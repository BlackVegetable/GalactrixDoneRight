
------------------------------------------------------------------------------
-- Crafting mini-game - gather a number of components before locking board
------------------------------------------------------------------------------
function CraftItem(sourceMenu, player1, questID,objectiveID)
	
	player1:SetAttribute('team', 1)
	
	local event = GameEventManager:Construct("GameStart")
	event:PushAttribute('Players', player1)
	
	local function StartCraftCallback(exiting, itemID)
		if not exiting then
			_G.GLOBAL_FUNCTIONS.Backdrop.Open()
			_G.CallScreenSequencer(sourceMenu, "GameMenu", sourceMenu, player1, "B010", event,questID,objectiveID, nil, nil, nil, itemID)
		else
			_G.CallScreenSequencer("CraftingIntroMenu", sourceMenu)
		end
	end

	_G.LoadAssetGroup("AssetsInventory")	
	_G.LoadAssetGroup("AssetsItems")		

	SCREENS.CraftingIntroMenu:Open(StartCraftCallback)
	
	return true
end

return CraftItem