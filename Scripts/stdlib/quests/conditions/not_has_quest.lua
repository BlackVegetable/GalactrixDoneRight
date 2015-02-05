
local precondition = import("quests/conditions/precondition")

class "not_has_quest" (precondition)
function not_has_quest:__init( arg )
	super(arg)
	self.quest = arg.quest
end

function not_has_quest:check(hero)
	return not CollectionContainsAttribute(hero,"running_quests",self.quest)
end

return ExportClass("not_has_quest")