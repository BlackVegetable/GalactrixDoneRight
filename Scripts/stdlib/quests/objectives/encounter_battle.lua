
local objective = import("quests/objectives/objective")

-- encounter_battle
--	ActionCallback sends a StartBattle event
--	listens for MonsterKilled events
class "encounter_battle" (objective)
function encounter_battle:__init( arg )
	super(arg)
	self.battleground	= arg.battleground
	self.monster		= arg.monster
end

function encounter_battle:ActionCallback(hero, questState, objectiveIndex)
	LOG("encounter_battle Action Callback ")
	-- send a StartBattle event
	local e = GameEventManager:Construct("SetEncounter")
	e:SetAttribute('battleground', self.battleground)
	e:SetAttribute('monster', self.monster)
	GameEventManager:Send( e, hero)				
end

function encounter_battle:ProcessQuestEvent(event, hero, questState, objectiveIndex)
	if event:GetName() == "MonsterKilled" 
		and event:GetAttribute('monster')		== self.monster
		and event:GetAttribute('battleground')	== self.battleground
	then
			
		self:Complete(hero, questState, objectiveIndex)
	end

	
end


function encounter_battle:ValidQuestEvent(event, hero, questState, objectiveIndex)
	if event:GetName() == "MonsterKilled" 
		and event:GetAttribute('monster')		== self.monster
		and event:GetAttribute('battleground')	== self.battleground
	then
			
		return true
	end

	
end

return ExportClass("encounter_battle")
