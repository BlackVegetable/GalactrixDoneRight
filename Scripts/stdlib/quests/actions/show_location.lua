
local action = import("quests/actions/action")


-- show_location
--	show_location {location="L001"},
class "show_location" (action)
function show_location:__init( arg )
	super(arg)
	self.location = arg.location
end
function show_location:execute(hero)
	local e = GameEventManager:Construct("ShowLocation")
	e:SetAttribute("location", self.location)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);
end

return ExportClass("show_location")