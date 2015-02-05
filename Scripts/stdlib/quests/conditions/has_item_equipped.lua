
local precondition = import("quests/conditions/precondition")

class "has_item_equipped" (precondition)
function has_item_equipped:__init( arg )
	super(arg)
	self.item = arg.item 
end
function has_item_equipped:check(hero)
	if hero.HasItemEquip then
		return hero:HasItemEquip(self.item)
	else
		LOG("HERO:HasItemEquip([itemCode]) Not defined")
		return true
	end
end

return ExportClass("has_item_equipped")