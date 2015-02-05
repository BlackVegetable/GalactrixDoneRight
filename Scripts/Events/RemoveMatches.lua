-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "EndSwap" (GameEvent)

EndSwap.AttributeDescriptions = AttributeDescriptionList()


function EndSwap:__init()
    super("EndSwap")
end

return ExportClass("EndSwap")
