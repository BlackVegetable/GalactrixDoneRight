
local action = import("quests/actions/action")


-- show_location
--	show_location {location="L001"},
class "destroy_location" (action)
function destroy_location:__init( arg )
	super(arg)
	self.location = arg.location
end
function destroy_location:execute(hero)
	local e = GameEventManager:Construct("DestroyLocation")
	e:SetAttribute("location", self.location)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);
end

return ExportClass("destroy_location")