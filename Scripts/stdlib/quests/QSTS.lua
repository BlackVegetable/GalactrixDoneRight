

-- import "safeglobals"



-- an instance of this class is created for each running quest
-- this holds all the mutable data for a quest
class "QuestState" (GameObject)

-- setup serializable attributes
-- TODO: make objective_complete use bool type when its supported
local adl = AttributeDescriptionList()
adl:AddAttribute('string', 'questID', {default="Q000", serialize=1} )
adl:AddAttribute('int', 'state', {default=1,serialize=1})--starting state
adl:AddAttributeCollection('int', 'objective_complete', {})
QuestState.AttributeDescriptions = adl

function QuestState:__init()
    super('QSTS')
end

-- only called by StartQuest
function QuestState:SetQuest(questID)
    assert(self:NumAttributes('objective_complete') == 0)
    self:SetAttribute('questID', questID)
	assert(self:HasAttribute('state'))
    self.quest = QUESTS[questID]--gets quest from autoload table? hmmm

    -- setup our objective_complete collection (no objectives complete at start)
    --local numObjectives = table.getn(self:GetObjectives())
    --for i=1,numObjectives do
    --    self:PushAttribute('objective_complete', 0)
    --end
end


-- returns the immutable quest information
function QuestState:GetQuest()
	if not self.quest then
		self.quest = QUESTS[self:GetAttribute("questID")]
	end		
		
    assert(self.quest)
    return self.quest
end

function QuestState:GetQuestID()
	return self:GetAttribute("questID")
end

function QuestState:GetQuestTitle()
	return "["..self:GetAttribute("questID").."_TITLE]"
end

function QuestState:GetQuestDesc()
	return "["..self:GetAttribute("questID").."_DESC]"
end

function QuestState:GetState()
	return self:GetAttribute("state")
end

function QuestState:CanAbandon()
	return self:GetQuest().can_abandon
end


-- returns the table of objectives for this quest
-- the index in the table is the index of the objectives state in the objective_complete collection
function QuestState:GetObjectives()
	assert(self:HasAttribute("questID"))
    return self:GetQuest().objectives[self:GetState()]
end

function QuestState:GetObjective(i)
    return self:GetQuest().objectives[self:GetState()][i]
end

-- returns the table of incomplete objectives
function QuestState:GetIncompleteObjectives()
	--LOG("GETINCOMPLETEOBJECTIVES - THIS SHOULD NOT BE BEING USED")
    local t= {}
    local objectives = self:GetObjectives()
    --[[
	for i,o in pairs(objectives) do
        complete = self:GetAttributeAt('objective_complete', i)
        -- TODO: fix when bool attributes are in
        if complete == 0 then
            table.insert(t,o)
        end
    end
	]]--
    return objectives
end

function QuestState:GetNumObjectives()
	assert(self:GetObjectives(),"No Objectives at index "..tostring(self:GetState()))
    return #self:GetObjectives()
end

function QuestState:IsObjectiveComplete(index)
    local complete = self:GetAttributeAt('objective_complete', index)
    if complete == 0 then
        return false
    end
    return true
end

function QuestState:SetObjectiveComplete(index)
    --self:SetAttributeAt('objective_complete', index, 1)
	--LOG("next state = "..tostring(self:GetObjective(index).next_state))
	self:SetAttribute("state",self:GetObjective(index).next_state)
end

-- returns true if all objectives are complete
function QuestState:AreObjectivesComplete()
    
	if self:GetState() >= QUESTS[self:GetQuest():GetQuestID()].end_state then
		return true
	end
	return false
	
end


-- returns a table of available actions at location
function QuestState:GetAvailableActions(hero, location)
    local actions = {}
    
    -- add any actions for objectives we havent finished
    for i=1,self:GetNumObjectives() do
        local objective = self:GetObjective(i)
		local locations = objective:GetLocations()
		if locations[location] then
			table.insert( actions, objective:GetAction() )
        end
    end
    return actions
end


-- returns a table of available objectives at location
--Returns relevant data only.
function QuestState:GetAvailableObjectives(hero, location)
    local actions = {}
	local questID = self:GetQuest():GetQuestID()
    
    -- add any actions for objectives we havent finished
    for i=1,self:GetNumObjectives() do
        local objective = self:GetObjective(i)
		local locations = objective:GetLocations()
		if locations[location] then
			table.insert( actions, {action=objective:GetAction();
				location=objective.location;
				battleground=objective.battleground;
				quest_id = questID} )
        end
    end
    return actions
end


-- 
function QuestState:PerformQuestAction(hero,action)
    if not action then
        return
    end
   
    -- if we have an objective with this action then perform the objectives action
    for i=1,self:GetNumObjectives() do
        local objective = self:GetObjective(i)
		
        if objective:GetAction() == action then
        	if self:GetQuest():MeetsPreconditions(hero,objective.next_state) then  	
				--LOG("performing quest action "..action)
            	objective:PerformAction(hero, self, i)
				return true
        	else
        		local condition_text = ""
				for _,t in pairs(self:GetQuest():GetUnmetPreconditions(hero,objective.next_state)) do
					condition_text = string.format("%s%s  ",condition_text,translate_text(t))
				end
				if hero.PopupUnmetPreconditions then
					hero:PopupUnmetPreconditions(self:GetQuestTitle(),condition_text)	
				else
					open_message_menu(self:GetQuestTitle(),condition_text)			
        		end     
        	end
        end
    end


end



function QuestState:Start(hero)
    local quest         = self:GetQuest()
    local start_actions = quest.start_actions
    local start_message = quest.start_message
    local start_convo   = quest.start_convo
    
    -- run on start actions for quest
    --local l = {}
    for _,v in pairs(start_actions) do
        v:execute(hero)
    end

    -- TODO: check l for items,gold etc and trigger small info popup?
    local function StartConvoCallback ()
    -- run start convo
	    if (start_convo) then
	        RunQuestConversation(hero, start_convo)
	    end
    end
	
	if start_message then
		if hero.PopupQuestStart then
			hero:PopupQuestStart(self:GetQuestTitle(),start_message)	
		else
			open_message_menu(self:GetQuestTitle(),start_message)
		end		 
	else
		StartConvoCallback()
	end
	
end


function QuestState:End(hero)
    -- assert that all objectives are complete
    assert(self:AreObjectivesComplete())
    local end_convo     = self:GetQuest().end_convo
    
    -- run end convo
    if end_convo then
        RunQuestConversation(hero, end_convo,
            function (a)
                self.OnEndQuest(self, hero)
            end
        )
    else
        self:OnEndQuest(hero)
    end

end

function QuestState:OnEndQuest(hero)
    
	local questID = self:GetQuest():GetQuestID()
    -- Destroy self and remove from running quests
    -- WARNING: dont access quest state after this
	
	local e = GameEventManager:Construct("QuestComplete")
	e:SetAttribute("quest_id",questID)
	GameEventManager:Send(e,hero)
	
    RemoveRunningQuest(hero, questID)
	
	

    -- if repeatable re-add to available quests
    if repeatable then
        AddAvailableQuest(hero, questID)
    end
end


function QuestState:Abandon(hero)
	local questID = self:GetQuest():GetQuestID()
	local incomplete_message = self.incomplete_message
	local incomplete_convo   = self.incomplete_convo
		
	local function IncompleteConvoCallback ()
   		-- run start convo
	   	if (incomplete_convo) then
			RunQuestConversation(hero, incomplete_convo)
	   	end
   	end
   
   	if incomplete_message then
		if hero.PopupAbandonQuest then
			hero:PopupAbandonQuest(self:GetQuestTitle(),incomplete_message,IncompleteConvoCallback)	
		else
	   		open_message_menu(self:GetQuestTitle(),incomplete_message,IncompleteConvoCallback)
		end 		
			
   	else
   		IncompleteConvoCallback()
   	end
	   	
	RemoveRunningQuest(hero, questID)	
	AddAvailableQuest(hero, questID)    
    -- run on abandon actions
end

--Processes End actions for current NEW State
function QuestState:OnObjectiveComplete(hero)
	LOG("OnObjectiveComplete()")
	local end_actions   = self:GetQuest().end_actions[self:GetState()]
    local actionDetails = {}
	
	if end_actions then
		-- run on end actions for end quest state
		for _,v in pairs(end_actions) do
			--v:collate(actionDetails)
			v:execute(hero)
		end
	end
	
    -- TODO: check l for items,gold etc and trigger small info popup?
    --          or if show_reward is true use the full reward screen
    --if show_reward_details then show_reward_details(actionDetails) end


	_G.UpdateQuestHero(hero)	
	
    local complete = self:AreObjectivesComplete()
    -- send hero objective complete event
    -- (eg so they can play a sound and update their locations)
	

    -- if theres no objectives left 
    if complete  then
        self:End(hero)
    end
end



function QuestState:ProcessQuestEvent(hero, event)
						
    --local complete = self:AreObjectivesComplete()
	local objective_match = false
    -- check each objective to see if it processes the event
    local objectives    = self:GetObjectives()
	if (objectives) then
	    for i,o in pairs(objectives) do
	        -- detect objective transition
	        --completed_objective = 
			if o:ValidQuestEvent(event, hero, self, i) then
				if self:GetQuest():MeetsPreconditions(hero,o.next_state) then
					o:ProcessQuestEvent(event, hero, self, i)
				else
					local condition_text = ""
					for _,t in pairs(self:GetQuest():GetUnmetPreconditions(hero,o.next_state)) do
						condition_text = string.format("%s%s  ",condition_text,translate_text(t))
					end
					
					if hero.PopupUnmetPreconditions then
						hero:PopupUnmetPreconditions(self:GetQuestTitle(),condition_text)	
					else					
						open_message_menu(self:GetQuestTitle(),condition_text)
					end    
				end			
				objective_match = true
			end
	    end
	end
	return objective_match
end


return ExportClass("QuestState")