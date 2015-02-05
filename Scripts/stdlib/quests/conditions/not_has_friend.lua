
local precondition = import("quests/conditions/precondition")

class "not_has_friend" (precondition)
function not_has_friend:__init( arg )
	super(arg)
	self.friend = arg.friend 
end
function not_has_friend:check(hero)
	if hero.HasFriend then
		return not hero:HasFriend(self.friend)
	else
		LOG("HERO:HasFriend([friendCode]) Not defined")
		return true
	end
end

return ExportClass("not_has_friend")