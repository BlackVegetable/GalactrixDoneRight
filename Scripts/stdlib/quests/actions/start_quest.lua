
local action = import("quests/actions/action")


-- start_quest
--	start_quest {quest="Q000"},
class "start_quest" (action)
function start_quest:__init( arg )
	super(arg)
	self.quest = arg.quest
end
function start_quest:execute(hero)
	StartQuest(hero, self.quest)
end

return ExportClass("start_quest")