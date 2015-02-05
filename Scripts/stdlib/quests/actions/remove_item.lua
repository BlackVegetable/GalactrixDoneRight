
local action = import("quests/actions/action")

-- remove_item
--	remove_item {item="Q000"}
class "remove_item" (action)
function remove_item:__init( arg )
	super(arg)
	self.item = arg.item
end
function remove_item:execute(hero)
	local e = GameEventManager:Construct("RemoveItem")
	e:SetAttribute("item", self.item)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);	
end

return ExportClass("remove_item")