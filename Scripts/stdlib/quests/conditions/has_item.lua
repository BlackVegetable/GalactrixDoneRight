
local precondition = import("quests/conditions/precondition")

class "has_item" (precondition)
function has_item:__init( arg )
	super(arg)
	self.item = arg.item 
end
function has_item:check(hero)
	if hero.HasItem then
		return hero:HasItem(self.item)
	else
		LOG("HERO:HasItem([itemCode]) Not defined")
		return true
	end
end

return ExportClass("has_item")