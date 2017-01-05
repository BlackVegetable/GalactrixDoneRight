-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "EndTurn" (GameEvent)

EndTurn.AttributeDescriptions = AttributeDescriptionList()


function EndTurn:__init()
    super("EndTurn")
end

return ExportClass("EndTurn")
