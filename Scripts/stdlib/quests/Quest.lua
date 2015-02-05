-- LUA_PATH = LUA_PATH or "?.lua;../?.lua"

require "import"
require "autoload"
require "stringex"
require "tableex"
--require "quests/objectives"
--require "quests/actions"
--require "quests/preconditions"

-- use_safeglobals()


local table_insert = table.insert
local string_format = string.format

local assert = assert
local pairs = pairs

-- TODO:
--          handle latent commands
--              eg we could implement the conversations as latent commands
--              ie commands that finish at a later time than they start
--              this is needed for example if we have multiple conversations that need to run
--
--          function to return what expansion packs are used (regardless of if they are present)
--              we need to support marking a hero as invalid due to missing expansion packs
--          
--          handle network case better
--              creating game objects is done on server. So Server should call StartQuest/EndQuest
--              but then there is setup code that must be executed on all clients. so need 
--              events for this. 
--
--          use iterators. we call NumAttributes and AttributeAt way to much. code looks too verbose
--          for i,v in collection(o, colnam) do end
--
--          cull duplicates. dont we have some extended table funcs in stdlib for some of this?

function _G.MakeQuestable(heroClass)
    -- add attribute collection for available quests
    heroClass.AttributeDescriptions:AddAttributeCollection('string', 'available_quests', {serialize=1})
    -- add attribute collection for running quests
    heroClass.AttributeDescriptions:AddAttributeCollection('GameObject', 'running_quests', {serialize=1})
    -- add any functions we need
end


-- setup autoload table for quests
_G.QUESTS = autoload("Assets/Scripts/Quests/")
_G.ACTIONS = autoload("quests/actions/")
_G.OBJECTIVES = autoload("quests/objectives/")
_G.CONDITIONS = autoload("quests/conditions/")

-- register quest state constructor
RegisterClassFactory( "QSTS", ImportConstructor("quests/"))


--------------------------------------------------------------------------------
--  player quest functions
--


function AddAvailableQuest(hero, questID)
    if CollectionContainsAttribute(hero, 'available_quests', questID) then
        return
    end
    hero:PushAttribute('available_quests', questID)

	_G.UpdateQuestHero(hero)	
end


-- returns a table of 4CCs
function GetAvailableQuests(hero)
    local t={}
    for i=1,hero:NumAttributes("available_quests") do
        local questID = hero:GetAttributeAt("available_quests", i)
        table_insert(t, questID )
    end
    return t
end

-- returns 4CCs of running quests
function GetRunningQuests(hero)
    local t = {}
    for i=1,hero:NumAttributes("running_quests") do
        local quest = hero:GetAttributeAt("running_quests", i)
        table_insert(t, quest:GetQuest():GetQuestID() )
    end
    return t
end

-- returns a table of 4CCs
function GetAvailableQuestsAtLocations(hero, locationList)
    local t={}
    for i=1,hero:NumAttributes("available_quests") do
    	local insertQuest = true
        local questID = hero:GetAttributeAt("available_quests", i)
		local locations = QUESTS[questID]:GetStartLocations()
		for i,v in pairs(locationList) do
			if not (locations[v]) then
				insertQuest= false
				break
        	end
		end
		if insertQuest then
			table_insert(t, questID)
		end		
    end
    return t
end

-- returns a table of 4CCs
function GetAvailableQuestsAtLocation(hero, location)
    local t={}
    for i=1,hero:NumAttributes("available_quests") do
        local questID = hero:GetAttributeAt("available_quests", i)
        if (QUESTS[questID]:GetStartLocations()[location]) then
            table_insert(t, questID )
        end
    end
    return t
end


-- returns locations that have available quests at them
function GetAvailableQuestsLocations(hero)
    local quests = GetAvailableQuests(hero)
    local t = {}
	local keys = {}
    for _,q in pairs(quests) do
        local quest = QUESTS[q]
        for i in pairs(quest:GetStartLocations()) do
			if not keys[i] then
				keys[i] = true
				table_insert( t, i )
			end
        end
    end
    return t
end

-- returns locations that we have objectives at
function GetQuestObjectiveLocations(hero)
    local t = {}
	local keys = {}
    -- for each running quest
    for i=1, hero:NumAttributes('running_quests') do
        local quest = hero:GetAttributeAt('running_quests', i)
        local objectives = quest:GetObjectives()
        for _,o in pairs(objectives) do
        	local locations = o:GetLocations()
            for l,_ in pairs(locations) do
            	if not keys[l] then
            		keys[l] = true
                	table_insert( t, l )
            	end
            end
        end
    end
    return t
end

--returns list of each location for each objective
--locations may do not appear more than once
function GetQuestIdsAndObjectiveLocations(hero)
    local t = {}
	--local keys = {}
    -- for each running quest
    for i=1, hero:NumAttributes('running_quests') do
        local quest = hero:GetAttributeAt('running_quests', i)
        local objectives = quest:GetObjectives()
        for _,o in pairs(objectives) do
        	local locations = o:GetLocations()
            for l,_ in pairs(locations) do
            	--if not keys[l] then
            		--keys[l] = true
                	table_insert( t, {quest:GetQuestID(),l} )
            	--end
            end
        end
    end
    return t
end


function LoadRunningText(hero)

	for i=1, hero:NumAttributes("running_quests") do
		local questID = hero:GetAttributeAt("running_quests",i):GetQuestID()	
		--LOG("Add Text file Quests/".. questID ..".xml")
		add_text_file(string_format("Quests/%s.xml",questID))
	end	
	
end



function StartQuest(hero, questID)
    -- assert(IsServer())

    if (CollectionFindIf(hero, "running_quests", 
        function(a)
            return a:GetQuest():GetQuestID() == questID
        end)
    ) then
        -- we are already on the quest
        return
    end

    -- if its in the available list remove it
    if CollectionContainsAttribute(hero, "available_quests", questID) then
        hero:EraseAttribute('available_quests', questID)
    end

	--LOG("Add Text file Quests/"..questID..".xml")
	add_text_file(string_format("Quests/%s.xml", questID))
		
    -- create new quest state for quest
    local state = GameObjectManager:Construct("QSTS")
    state:SetQuest(questID)

    -- add to running quests
    hero:PushAttribute("running_quests", state)
    -- add as child of hero
    hero:AddChild(state)

    -- run the quests start handler (TODO: event?)
    state:Start(hero)
	
	_G.UpdateQuestHero(hero)
end

-- completely cancels a running quest
-- does not run any events, only destroys quest
function RemoveRunningQuest(hero, questID)
    local q
    for i=1,hero:NumAttributes('running_quests') do
        q = hero:GetAttributeAt('running_quests', i)
        if (q:GetQuestID() == questID) then
            hero:EraseAttribute('running_quests', q)
            -- destroy the state.
			--LOG("Remove Text file Quests/"..questID..".xml")
			remove_text_file(string_format("Quests/%s.xml",questID))		
            GameObjectManager:Destroy(q)			
			_G.UpdateQuestHero(hero)
            break
        end
    end
end

-- cancels a quest and re-adds it to available list
function AbandonQuest(hero, questID)
	local quest = CollectionFindIf(hero, "running_quests", 
								function(a)
									return a:GetQuest():GetQuestID() == questID
								end)
	
	if quest then
		assert(quest:GetQuest():GetQuestID()==questID,"Abandon Quest - Inconsistency")
		-- we are already on the quest

		--LOG("Remove Text file Quests/"..questID..".xml")
		remove_text_file(string_format("Quests/%s.xml", questID))
		quest:Abandon(hero)
		_G.UpdateQuestHero(hero)
	end    
end


-- returns the dictionary of actions that can be performed at a location
--  this checks all running quests
function GetAvailableActions(hero, location)
    -- 
    local actions = {}
    for i=1,hero:NumAttributes('running_quests') do
        local quest = hero:GetAttributeAt('running_quests', i)
        local t = quest:GetAvailableActions(hero, location)
        for _,v in pairs(t) do
            table_insert(actions,v)
        end
    end 
    return actions
end

-- returns list of ObjectiveObjects Linked to location
--  this checks all running quests
function GetAvailableObjectives(hero, location)
    -- 
    local actions = {}
    for i=1,hero:NumAttributes('running_quests') do
        local quest = hero:GetAttributeAt('running_quests', i)
        local t = quest:GetAvailableObjectives(hero, location)
        for _,v in pairs(t) do
            table_insert(actions,v)
        end
    end 
    return actions
end



--Called when Quest action selected from menu
--action = [ACTION_TEXT_TAG]
function PerformQuestAction(hero, action)
    -- for each running quest
    for i=hero:NumAttributes('running_quests'),1,-1 do
        --  process the event
        local quest = hero:GetAttributeAt('running_quests', i)
        quest:PerformQuestAction(hero, action)        
    end
end


-- call this on any event that is relevant to quests
--Quest Events:
--			ArriveAtLocation
--			MonsterKilled
--			MonsterNotKilled
--			ItemReceived
-- 			ItemNotReceived
function ProcessQuestEvent(hero, event)
    -- for each running quest
	local eventReceived = false--acknowlegdment of event receipt
    for i=hero:NumAttributes('running_quests'),1,-1 do
        --  process the event
        local quest = hero:GetAttributeAt('running_quests', i)
        if quest:ProcessQuestEvent(hero, event) then
			eventReceived = true
		end
    end
	return eventReceived
end



function UpdateQuestHero(hero)
	--Send Event to hero to update any quest related displays
	local e = GameEventManager:Construct("UpdateQuestUI")
	GameEventManager:Send( e, hero)
end



--------------------------------------------------------------------------------








-- class for quests
--  this is intentionally not a game object as its meant to represent a "template"
--  ie no mutable variables.
--  the saveable/mutable component of this system is the QuestState class
class "Quest" 

function Quest:__init(questData)
    -- setup attributes needed by quest system
    self.id             = assert(questData.id)
    self.repeatable     = questData.repeatable or false
	self.can_abandon	= questData.can_abandon or false
    self.end_state      = questData.end_state

    self.level_min      = questData.level_min or 1
    self.level_max      = questData.level_max or 999
	
    -- details for quest log
    self.icon           = assert(questData.icon)
    self.log_text       = StringOrNil(questData.log_text)
    self.quest_type     = StringOrNil(questData.quest_type)

    self.start_message    	= StringOrNil(questData.start_message)
    self.incomplete_message = StringOrNil(questData.incomplete_message)
    self.start_convo    	= StringOrNil(questData.start_convo)
    self.incomplete_convo   = StringOrNil(questData.incomplete_convo)
    
	 --table with location ids as index
    self.start_locations	= assert(questData.start_locations)
    
    self.objectives     = assert(questData.objectives)
    self.preconditions  = assert(questData.preconditions)

    -- actions
    self.start_actions		= assert(questData.start_actions)
    self.abandon_actions	= assert(questData.abandon_actions)
    self.end_actions		= assert(questData.end_actions)
end

function Quest:GetQuestID()
    return self.id
end

function Quest:GetEndState()
    return self.end_state
end

function Quest:IsRepeatable()
    return self.repeatable
end

function Quest:GetStartLocation()
    return self.start_locations[1]
end

function Quest:GetStartLocations()
    return self.start_locations
end



-- TODO: more getters here
-- NO SETTERS. quests are immutable

function Quest:MeetsPreconditions(hero,state)
	local questID = self:GetQuestID()
	if not state then
		state = 1
	end
	
	
	if not self.preconditions[state] then--No preconditions
		return true
	end
	
	for _,p in pairs(self.preconditions[state]) do
		if not p:check(hero) then
			return false
		end
	end
	
	return true
end

function Quest:GetUnmetPreconditions(hero,state)
	local questID = self:GetQuestID()
	--local preconditions = {}
	if not state then
		state = 1
	end
	
	
	if not self.preconditions[state] then
		return true
	end

	local unmet_t = {}	
	for _,p in pairs(self.preconditions[state]) do
		if not p:check(hero) then
			table_insert(unmet_t,p.text)
		end
	end
	
	
    return unmet_t
end


