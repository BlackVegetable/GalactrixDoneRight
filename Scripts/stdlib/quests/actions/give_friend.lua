
local action = import("quests/actions/action")

-- give_friend
--	when executed sends the GiveItem event to the hero
--	it is assumed that the hero will be able to process this event
class "give_friend" (action)
function give_friend:__init( arg )
	super(arg)
	self.friend = arg.friend
end
function give_friend:execute(hero)
	-- send event to hero
	local e = GameEventManager:Construct("GiveFriend")
	e:SetAttribute("friend", self.friend)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);
end

return ExportClass("give_friend")