
local action = import("quests/actions/action")


-- remove_friend
--	remove_friend {friend="Q000"}
class "remove_friend" (action)
function remove_friend:__init( arg )
	super(arg)
	self.friend = arg.friend
end
function remove_friend:execute(hero)
	local e = GameEventManager:Construct("RemoveFriend")
	e:SetAttribute("friend", self.friend)
	e:SetAttribute("show", self.show)
	GameEventManager:Send(e, hero);	
end

return ExportClass("remove_friend")