
local objective = import("quests/objectives/objective")

-- go_to_location_event
--	listens for the ArriveAtLocation event
class "go_to_location_event" (objective)
function go_to_location_event:__init( arg )
	super(arg)
	self.action = ""--Never seen by user - necessary in displaying available quest actions at location
	-- we use the location attribute
end

function go_to_location_event:ActionCallback(hero, questState, objectiveIndex)
	self:Complete(hero, questState, objectiveIndex)
end

function go_to_location_event:ProcessQuestEvent(event, hero, questState, objectiveIndex)
	if event:GetName() == "ArriveAtLocation" 
		and self:GetLocations()[event:GetAttribute('location')]
	then
		if self.text then
			local function PopupTextCallback() 
				self:Complete(hero, questState, objectiveIndex)				
			end
			if hero.PopupArriveAtLocation then
				hero:PopupArriveAtLocation(questState:GetQuestTitle(),self.text,PopupTextCallback)
			else
				open_message_menu(questState:GetQuestTitle(),self.text,PopupTextCallback)
			end
			
		else
			self:Complete(hero, questState, objectiveIndex)
		end
	end
end

function go_to_location_event:ValidQuestEvent(event, hero, questState, objectiveIndex)
	
	if event:GetName() == "ArriveAtLocation" 
		and self:GetLocations()[event:GetAttribute('location')]
	then		
		return true
	end
end

return ExportClass("go_to_location_event")
