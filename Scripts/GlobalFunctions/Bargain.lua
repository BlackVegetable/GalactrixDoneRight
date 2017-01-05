

------------------------------------------------------------------------------
-- Bargaining mini-game - match as many gems as possible on a fixed-size board
------------------------------------------------------------------------------
function Bargain(sourceMenu, player1,location, questID,objectiveID)
	
	player1:SetAttribute('team', 1)
	
	local event = GameEventManager:Construct("GameStart")
	event:PushAttribute("Players", player1)
	
	local function StartBargainCallback(confirm)
		if confirm then		
			local function transition()
				_G.Hero.isBuying = SCREENS.ShopMenu.buying
				_G.GLOBAL_FUNCTIONS.Backdrop.Open()
				
				local function StartGame()
					close_yesno_menu(false,false)
					_G.CallScreenSequencer(sourceMenu, "GameMenu", sourceMenu, player1, "B008", event,questID,objectiveID)
				end
										
				if SCREENS.ShopMenu:IsOpen() then
					--SCREENS.ShopMenu:Close()
					_G.CallScreenSequencer("ShopMenu", StartGame)
					--_G.FadeToBlack()
					--_G.CallScreenSequencer("ShopMenu",nil)
				else
					StartGame()
				end	
			end	
			SCREENS.CustomLoadingMenu:Open(nil, transition, nil, "GameMenu")	
		end
	end

	open_yesno_menu("[BARGAIN_HEADING]","[BARGAIN_DESC]",StartBargainCallback,"[OKAY]","[CANCEL]")
	--SCREENS.BargainIntroMenu:Open(StartBargainCallback)
end

return Bargain