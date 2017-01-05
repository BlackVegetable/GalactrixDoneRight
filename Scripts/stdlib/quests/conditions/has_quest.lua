
local precondition = import("quests/conditions/precondition")

class "has_quest" (precondition)
function has_quest:__init( arg )
	super(arg)
	self.quest = arg.quest
	self.amount = arg.amount 
end

function has_quest:check(hero)
	return CollectionContainsAttribute(hero,"running_quests",self.quest)
end

return ExportClass("has_quest")