
local objective = import("quests/objectives/objective")


-- not_kill_monster
--	ActionCallback sends a StartBattle event
--	listens for MonsterKilled events
class "not_kill_monster" (objective)
function not_kill_monster:__init( arg )
	super(arg)
	self.battleground	= arg.battleground
	self.monster		= arg.monster
	self.alt_obj_id		= arg.alt_obj_id -- Should be the objective ID of kill_monster objective
	self.action= nil--no visible action for this action
end

function not_kill_monster:ActionCallback(hero, questState, objectiveIndex)
	LOG("not_kill_monster Action Callback ")
	
end

function not_kill_monster:ProcessQuestEvent(event, hero, questState, objectiveIndex)
	if event:GetName() == "MonsterNotKilled" 
		and event:GetAttribute('monster')		== self.monster
		and event:GetAttribute('battleground')	== self.battleground
		and event:GetAttribute("questID") == questState:GetAttribute("questID") --verify questId and objective match
		and event:GetAttribute("objectiveID") == self.alt_obj_id
	then
		LOG("MonsterNotKilled")
				
		self:Complete(hero, questState, objectiveIndex)
	end
	
end

function not_kill_monster:ValidQuestEvent(event, hero, questState, objectiveIndex)
	if event:GetName() == "MonsterNotKilled" 
		and event:GetAttribute('monster')		== self.monster
		and event:GetAttribute('battleground')	== self.battleground
		and event:GetAttribute("questID") == questState:GetAttribute("questID") --verify questId and objective match
		and event:GetAttribute("objectiveID") == self.alt_obj_id
	then
		return true --?? return anything for this objective - probably not necessary
	end
	
end


return ExportClass("not_kill_monster")
