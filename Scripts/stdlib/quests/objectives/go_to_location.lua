
local objective = import("quests/objectives/objective")

-- go_to_location
--display menu option at location
--display popup message after menu select
class "go_to_location" (objective)
function go_to_location:__init( arg )
	super(arg)
	-- we use the location attribute
end
function go_to_location:ActionCallback(hero, questState, objectiveIndex)
	LOG("in ActionCallback. completing")
	-- Show popup message before action is complete	
	self:Complete(hero, questState, objectiveIndex)
end

return ExportClass("go_to_location")
