
local precondition = import("quests/conditions/precondition")

class "location_available" (precondition)
function location_available:__init( arg )
	super(arg)
	self.location = arg.location 
end
function location_available:check(hero)
	if hero.HasLocation then
		return hero:HasLocation(self.location)
	else
		LOG("HERO:HasLocation([locationID]) Not defined")
		return true
	end
end

return ExportClass("location_available")