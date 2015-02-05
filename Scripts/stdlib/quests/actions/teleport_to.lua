
local action = import("quests/actions/action")

-- teleport_to
--	teleport_to {location="L001"},
class "teleport_to" (action)
function teleport_to:__init( arg )
	super(arg)
	self.location = arg.location
end
function teleport_to:execute(hero)
	local e = GameEventManager:Construct("TeleportTo")
	e:SetAttribute("location", self.location)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);
end

return ExportClass("teleport_to")