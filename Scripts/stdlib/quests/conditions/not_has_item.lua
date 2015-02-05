
local precondition = import("quests/conditions/precondition")

class "not_has_item" (precondition)
function not_has_item:__init( arg )
	super(arg)
	self.item = arg.item 
end
function not_has_item:check(hero)
	if hero.HasItem then
		return not hero:HasItem(self.item)
	else
		LOG("HERO:HasItem([itemCode]) Not defined")
		return true
	end
end

return ExportClass("not_has_item")