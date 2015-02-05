
local action = import("quests/actions/action")

-- remove_resource
-- remove_resource {resource="<RESOURCE_TAG/RESOURCE_NUM>",amount=n}
class "remove_resource" (action)
function remove_resource:__init( arg )
	super(arg)
	self.resource = arg.resource -- 4CC/numerical code of int_type
	self.amount = arg.amount -- Qty to add
end
function remove_resource:execute(hero)
	local e = GameEventManager:Construct("RemoveResource")
	e:SetAttribute("resource", tostring(self.resource))
	e:SetAttribute("amount", self.amount)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);
end

return ExportClass("remove_resource")