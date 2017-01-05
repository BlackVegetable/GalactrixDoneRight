
local objective = import("quests/objectives/objective")


-- collect_item
-- collect_item cannot have an action associated with it, so needs no action callback
-- listens for the ItemReceived event
class "collect_item" (objective)
function collect_item:__init( arg )
	super(arg)
	self.item	= arg.item
	assert(self:GetAction() == nil)
end
function collect_item:ProcessQuestEvent(event, hero, questState, objectiveIndex)
	if event:GetName() == "ItemReceived" and event:GetAttribute('item') == self.item then
		-- we got the item we were after
		self:Complete(hero, questState, objectiveIndex)
	end
end

function collect_item:ValidQuestEvent(event, hero, questState, objectiveIndex)
	if event:GetName() == "ItemReceived" and event:GetAttribute('item') == self.item then		
			return true			
	end
end

return ExportClass("collect_item")
