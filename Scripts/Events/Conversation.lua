-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()

class "Conversation" (GameEvent)

Conversation.AttributeDescriptions = AttributeDescriptionList()


function Conversation:__init()
    super("Conversation")
end

return ExportClass("Conversation")
