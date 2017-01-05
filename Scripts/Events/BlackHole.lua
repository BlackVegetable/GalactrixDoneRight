-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "BlackHole" (GameEvent)

BlackHole.AttributeDescriptions = AttributeDescriptionList()




function BlackHole:__init()
    super("BlackHole")
end

return ExportClass("BlackHole")
