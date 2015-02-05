-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "TimerRunOut" (GameEvent)

TimerRunOut.AttributeDescriptions = AttributeDescriptionList()
TimerRunOut.AttributeDescriptions:AddAttribute("int","broadcast",{default=0,serialize= 1})
TimerRunOut.AttributeDescriptions:AddAttribute("int","turn_count",{default=0,serialize= 1})




function TimerRunOut:__init()
    super("TimerRunOut")
	LOG("TimerRunOut __init()")
	self:SetSendToSelf(false)	
end


function TimerRunOut:do_OnReceive()
	LOG("TimerRunOut:do_OnReceive()")	
	local world = _G.SCREENS.GameMenu.world
	if not world then
		return
	end
	
	if self:GetAttribute("broadcast")==0 then
		if world.state and world.state <= _G.STATE_USER_INPUT_PLAYER and world.turn_count == self:GetAttribute("turn_count") then
			world.state = STATE_ENDING_TURN
			self:SetSendToSelf(true)	
			self:SetAttribute("broadcast",1)
			GameEventManager:Send(self)
		else
			LOG("Throw TimerRunOut event away")
		end
	else
		LOG("broadcast == 1 - End Turn")
		--if world.state and world.state <= _G.STATE_USER_INPUT_PLAYER then
			world.state = STATE_ENDING_TURN
			local e = GameEventManager:Construct("EndTurn")
			world:OnEventEndTurn(e)
		
		--end		
		
	end
	
	

	
end

return ExportClass("TimerRunOut")
