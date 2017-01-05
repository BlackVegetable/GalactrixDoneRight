
local action = import("quests/actions/action")

-- cancel_quest
--	cancel_quest {quest="Q000"},
class "cancel_quest" (action)
function cancel_quest:__init( arg )
	super(arg)
	self.quest = arg.quest
end
function cancel_quest:execute(hero)
	RemoveRunningQuest(hero, self.quest)
end

return ExportClass("cancel_quest")