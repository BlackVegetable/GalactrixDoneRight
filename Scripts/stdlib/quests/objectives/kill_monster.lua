
local objective = import("quests/objectives/objective")


-- kill_monster
--	ActionCallback sends a StartBattle event
--	listens for MonsterKilled events
class "kill_monster" (objective)
function kill_monster:__init( arg )
	super(arg)
	self.battleground	= arg.battleground
	self.monster		= arg.monster
end

function kill_monster:ActionCallback(hero, questState, objectiveIndex)
	LOG("kill_monster Action Callback ")
	-- send a StartBattle event
	local e = GameEventManager:Construct('StartBattle')
	e:SetAttribute('battleground', self.battleground)
	e:SetAttribute('monster', self.monster)
	e:SetAttribute('questID', questState:GetAttribute("questID"))
	e:SetAttribute('objectiveID', objectiveIndex)
	if self.params then
		for i,v in pairs(self.params) do
			e:PushAttribute("params",v)
		end
	end
	GameEventManager:Send(e,hero)
end

function kill_monster:ProcessQuestEvent(event, hero, questState, objectiveIndex)
	if event:GetName() == "MonsterKilled" 
		and event:GetAttribute('monster')		== self.monster
		and event:GetAttribute('battleground')	== self.battleground
		and event:GetAttribute("questID") == questState:GetAttribute("questID") --verify questId and objective match
		and event:GetAttribute("objectiveID") == objectiveIndex 
	then
		self:Complete(hero, questState, objectiveIndex)

	end
end

function kill_monster:ValidQuestEvent(event, hero, questState, objectiveIndex)
	
	if event:GetName() == "MonsterKilled" 
		and event:GetAttribute('monster')		== self.monster
		and event:GetAttribute('battleground')	== self.battleground
		and event:GetAttribute("questID") == questState:GetAttribute("questID") --verify questId and objective match
		and event:GetAttribute("objectiveID") == objectiveIndex 
	then
		return true

	end
end

return ExportClass("kill_monster")
