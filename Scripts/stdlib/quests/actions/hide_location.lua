
local action = import("quests/actions/action")

-- hide_location
--	hide_location {location="L001"},
class "hide_location" (action)
function hide_location:__init( arg )
	super(arg)
	self.location = arg.location
end

function hide_location:execute(hero)
	local e = GameEventManager:Construct("HideLocation")
	e:SetAttribute("location", self.location)
	GameEventManager:Send(e, hero);
end

return ExportClass("hide_location")