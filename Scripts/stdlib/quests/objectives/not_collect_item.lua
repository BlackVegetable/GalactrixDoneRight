
local objective = import("quests/objectives/objective")


-- not_collect_item
-- not_collect_item cannot have an action associated with it, so needs no action callback
-- listens for the ItemNotReceived event
class "not_collect_item" (objective)
function not_collect_item:__init( arg )
	super(arg)
	self.item	= arg.item
	assert(self:GetAction() == nil)
end
function not_collect_item:ProcessQuestEvent(event, hero, questState, objectiveIndex)
	if event:GetName() == "ItemNotReceived" and event:GetAttribute('item') == self.item then
		-- we got the item we were after
		self:Complete(hero, questState, objectiveIndex)
	end
end

function not_collect_item:ValidQuestEvent(event, hero, questState, objectiveIndex)
	if event:GetName() == "ItemNotReceived" and event:GetAttribute('item') == self.item then		
			return true			
	end
end

return ExportClass("not_collect_item")
