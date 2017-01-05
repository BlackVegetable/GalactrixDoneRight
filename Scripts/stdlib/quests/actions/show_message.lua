
local action = import("quests/actions/action")

-- show_message
-- show_message {msg="<MSG_TAG>"}
class "show_message" (action)
function show_message:__init( arg )
	super(arg)
	self.message = arg.message -- 4CC/numerical code of int_type
end
function show_message:execute(hero)
	local e = GameEventManager:Construct("ShowMessage")
	e:SetAttribute("message", tostring(self.message))
	e:SetAttribute("show", 1)
	GameEventManager:Send(e, hero);
end

return ExportClass("show_message")