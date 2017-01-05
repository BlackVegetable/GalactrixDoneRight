
local precondition = import("quests/conditions/precondition")

class "min_resource" (precondition)
function min_resource:__init( arg )
	super(arg)
	self.resource = tonumber(arg.resource)
	self.amount = arg.amount 
end
function min_resource:check(hero)
	if hero.GetResource then
		if hero:GetResource(self.resource) >= self.amount then
			return true
		else
			return false
		end
	else
		LOG("HERO:GetResource([ResourceCode]) Not defined")
		return true
	end
end

return ExportClass("min_resource")