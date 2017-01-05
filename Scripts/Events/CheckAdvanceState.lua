-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()

class "CheckAdvanceState" (GameEvent)

CheckAdvanceState.AttributeDescriptions = AttributeDescriptionList()
CheckAdvanceState.AttributeDescriptions:AddAttribute("int","state",{default=0})
CheckAdvanceState.AttributeDescriptions:AddAttribute("int","delay",{default=0})


function CheckAdvanceState:__init()
    super("CheckAdvanceState")
	self:SetSendToSelf(true)
end


return ExportClass("CheckAdvanceState")
