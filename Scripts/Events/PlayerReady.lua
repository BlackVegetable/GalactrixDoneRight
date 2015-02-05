-- PlayerReady 
--When Players change Hero to use in MP
--This is sent to server to replicate outward.

use_safeglobals()






class "PlayerReady" (GameEvent)

PlayerReady.AttributeDescriptions = AttributeDescriptionList()


--PlayerReady.AttributeDescriptions:AddAttribute('int', 'mp_id', {default=1,serialize= 1})
PlayerReady.AttributeDescriptions:AddAttribute('int', 'player_id', {default=1,serialize= 1})
PlayerReady.AttributeDescriptions:AddAttribute('int', 'player_ready', {default=0,serialize= 1})





function PlayerReady:__init()
    super("PlayerReady")
    LOG("PlayerReady Init()")
	self:SetSendToSelf(false)
end



function PlayerReady:do_OnReceive()
	LOG("PlayerReady OnReceive() "..tostring(SCREENS.MultiplayerGameSetup.my_player_id))
	--and add an entry to the log
	if SCREENS.MultiplayerGameSetup.my_player_id ~= self:GetAttribute('player_id') then
		SCREENS.MultiplayerGameSetup:SetPlayerReady(self:GetAttribute('player_id'),self:GetAttribute("player_ready"))
	end
	
end



return ExportClass("PlayerReady")
