-- UpdateOpponent 
--When Players change Hero to use in MP
--This is sent to server to replicate outward.

use_safeglobals()






class "UpdateOpponent" (GameEvent)

UpdateOpponent.AttributeDescriptions = AttributeDescriptionList()


function UpdateOpponent:__init()
    super("UpdateOpponent")
	self:SetSendToSelf(false)
end



function UpdateOpponent:do_OnReceive()
	LOG("UpdateOpponent OnReceive()")
	
	if _G.is_open("MultiplayerGameSetup") then		--pc only
		--SCREENS.MultiplayerGameSetup:hide_widget("icon_wireless_state")
		--SCREENS.ReceptionStrengthMenu:Close()
		SCREENS.MultiplayerGameSetup:UpdateNetworkHero(_G.Hero)
	elseif _G.is_open("MPLobby") then--xbox only
		SCREENS.MPLobby:UpdateNetworkHero(_G.Hero)
		SCREENS.MPLobby:UpdateNetworkReady()
	end
	
end



return ExportClass("UpdateOpponent")
