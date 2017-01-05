
-- base class for quest objectives
-- all objectives have to be complete for a quest to count as complete
-- objectives have a location and an action
-- when the action is performed
--		first the cutscene is run
--		then the ActionHandler is run

-- has child classes: 
class "objective"
function objective:__init( arg )
	self.log_text			= arg.log_text --desc text -- not currently used
	self.end_convo			= StringOrNil(arg.end_convo)

	self.text 				= arg.text
	self.end_text 			= arg.end_text
	self.next_state			= arg.next_state
	self.location			= arg.location
	self.conversation		= StringOrNil(arg.conversation)
	self.action				= arg.action
	self.params				= arg.params
end

function objective:GetLocation()
	return self.location[1]
end

function objective:GetLocations()
	return self.location
end


function objective:GetAction()
	return self.action
end



-- called from child classes
function objective:Complete(hero, questState, objectiveIndex)
	-- mark ourselfs as coplete

	LOG("completing quest objective for ".. questState:GetQuestTitle() )
	
	--Was here - moved to be immediately before OnObjectiveComplete 
	--to prevent Sync issues with Hero save
	--questState:SetObjectiveComplete(objectiveIndex)
	
	
	local end_convo     = self.end_convo
	local function PopupTextCallback() 
		-- run end convo on objective completion
		if end_convo then
			RunQuestConversation(hero, end_convo,
				function (a)                
					questState:SetObjectiveComplete(objectiveIndex)
					questState:OnObjectiveComplete(hero)
				end
			)
		else        
			questState:SetObjectiveComplete(objectiveIndex)
			questState:OnObjectiveComplete(hero)
		end 				
	end	
	if self.end_text then
		if hero.PopupObjectiveComplete then
			hero:PopupObjectiveComplete(questState:GetQuestTitle(), self.end_text, PopupTextCallback)
		else
			open_message_menu(questState:GetQuestTitle(),self.end_text,PopupTextCallback)
		end 
	else
		--questState:OnObjectiveComplete(hero)
		PopupTextCallback()
	end    
       
	
	
	-- signal completion
end

function objective:PerformAction(hero, questState, objectiveIndex)
	
			
	local function PopupTextCallback()
		if self.conversation then
			-- run convo with a callback that runs ActionCallback(self, hero, questState, objectiveIndex)
			RunQuestConversation(hero, self.conversation,
				function (a)
					self:ActionCallback(hero, questState, objectiveIndex)
				end
			)
		else
			LOG("calling action callback")
			self:ActionCallback(hero, questState, objectiveIndex)
		end
	end
	
	if self.text then
		if hero.PopupPerformingAction then
			hero:PopupPerformingAction(questState:GetQuestTitle(),self.text,PopupTextCallback)
		else
			open_message_menu(questState:GetQuestTitle(),self.text,PopupTextCallback)	
		end 
	else
		PopupTextCallback()
	end	
	
end

function objective:ActionCallback(hero, questState, objectiveIndex)
end

function objective:ValidQuestEvent(event, hero, questState, objectiveIndex)
end

function objective:ProcessQuestEvent(event, hero, questState, objectiveIndex)
end

return ExportClass("objective")
