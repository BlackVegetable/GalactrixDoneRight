-- SpawnGems
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()

class "ChatEvent" (GameEvent)

ChatEvent.AttributeDescriptions = AttributeDescriptionList()
ChatEvent.AttributeDescriptions:AddAttribute('string', 'chatmessage', 
	{
		default			= "chat message",
		serialize		= 1
	})
ChatEvent.AttributeDescriptions:AddAttribute('int', 'senderID', 
	{
		default			= 0,
		serialize		= 1
	})
ChatEvent.AttributeDescriptions:AddAttribute('int', 'chattype', 
	{
		default			= 0,
		serialize		= 1
	})

function ChatEvent:__init()
	super("ChatEvent")
	self:SetSendToSelf(true)
end

--the host has received the destroy star request
function ChatEvent:do_OnReceive()
	
	--get the sending player's name
	local logString = GetPlayerNameFromID(self:GetAttribute('senderID'))
	
	--private / group / public chat type
	if (self:GetAttribute('chattype') == 0) then
		logString = logString .. ' (Public) : '
	elseif (self:GetAttribute('chattype') == 1) then
		logString = logString .. ' (Group) : '
	elseif (self:GetAttribute('chattype') == 2) then
		logString = logString .. ' (Private) : '
	end
	logString = logString .. self:GetAttribute('chatmessage')
	
	--and add an entry to the log
	SCREENS.MultiplayerGame:set_list_option("list_log", logString)
	

end

return ExportClass("ChatEvent")