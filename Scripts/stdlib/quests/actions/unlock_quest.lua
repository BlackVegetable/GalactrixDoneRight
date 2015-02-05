-- unlock_quest
--	unlock_quest {quest="Q000"},
local action = import("quests/actions/action")

class "unlock_quest" (action)
function unlock_quest:__init( arg )
	super(arg)
	self.quest = arg.quest
end
function unlock_quest:execute(hero)
	_G.AddAvailableQuest(hero, self.quest)
	-- TODO: send notification event?
end

return ExportClass("unlock_quest")