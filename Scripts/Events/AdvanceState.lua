-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()

class "AdvanceState" (GameEvent)

AdvanceState.AttributeDescriptions = AttributeDescriptionList()
AdvanceState.AttributeDescriptions:AddAttribute("int","state",{default=0,serialize= 1})
AdvanceState.AttributeDescriptions:AddAttribute("int","delay",{default=0,serialize= 1})


function AdvanceState:__init()
    super("AdvanceState")
	self:SetSendToSelf(true)
end

function AdvanceState:do_OnReceive()

	local battleground = _G.SCREENS.GameMenu.world
	
	if battleground.state == _G.STATE_GAME_OVER then--Don't progress State if game over
		return
	end
	
	
	battleground.state = self:GetAttribute("state")
 	local nextTime = GetGameTime() + self:GetAttribute("delay")
	
	LOG("AdvanceState:do_OnReceive id="..tostring(battleground.my_id).." state="..tostring(battleground.state))
	
	if battleground.state == _G.STATE_SWAPPING then 
		battleground:InitStateSwapping()
	elseif battleground.state == _G.STATE_ILLEGALMOVE then 
		battleground:InitStateIllegalMove()
	elseif battleground.state == _G.STATE_SEARCHING then 
		battleground:InitStateSearching()
	elseif battleground.state == _G.STATE_REMOVING then 
		battleground:InitStateRemoving()
	elseif battleground.state == _G.STATE_FALLING then 
		battleground:InitStateFalling()
	elseif battleground.state == _G.STATE_REPLENISHING then 
		battleground:InitStateReplenishing()
	end
	
	
 	local event = GameEventManager:Construct("Update")
	GameEventManager:SendDelayed( event, battleground, nextTime )
end


return ExportClass("AdvanceState")
