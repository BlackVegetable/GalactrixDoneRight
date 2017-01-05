
local action = import("quests/actions/action")

-- give_resource
-- give_resource {resource="<RESOURCE_TAG/RESOURCE_NUM>",amount=n}
class "give_resource" (action)
function give_resource:__init( arg )
	super(arg)
	self.resource = arg.resource -- 4CC/numerical code of int_type
	self.amount = arg.amount -- Qty to add	
end
function give_resource:execute(hero)
	local e = GameEventManager:Construct("GiveResource")
	e:SetAttribute("resource", tostring(self.resource))
	e:SetAttribute("amount", self.amount)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);
end

return ExportClass("give_resource")