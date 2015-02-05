-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "FadeFromBlack" (GameEvent)

FadeFromBlack.AttributeDescriptions = AttributeDescriptionList()


function FadeFromBlack:__init()
    super("FadeFromBlack")
end

return ExportClass("FadeFromBlack")
