
local precondition = import("quests/conditions/precondition")

class "max_resource" (precondition)
function max_resource:__init( arg )
	super(arg)
	self.resource = tonumber(arg.resource)
	self.amount = arg.amount 
end
function max_resource:check(hero)
	if hero.GetResource then
		if hero:GetResource(self.resource) <= self.amount then
			return true
		else
			return false
		end
	else
		LOG("HERO:GetResource([ResourceCode]) Not defined")
		return true
	end
end

return ExportClass("max_resource")