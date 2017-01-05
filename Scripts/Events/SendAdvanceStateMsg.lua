-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()

class "SendAdvanceStateMsg" (GameEvent)

SendAdvanceStateMsg.AttributeDescriptions = AttributeDescriptionList()
SendAdvanceStateMsg.AttributeDescriptions:AddAttribute("int","state",{default=0,serialize= 1})


function SendAdvanceStateMsg:__init()
    super("SendAdvanceStateMsg")
	self:SetSendToSelf(false)
end

function SendAdvanceStateMsg:do_OnReceive()

	LOG(string.format("SendAdvanceStateMsg:do_OnReceive (%s) ... received msg",tostring(_G.SCREENS.GameMenu.world.my_id)))
	
	local battleground = _G.SCREENS.GameMenu.world
	battleground.receivedAdvanceStateMsg = true
end


return ExportClass("SendAdvanceStateMsg")
