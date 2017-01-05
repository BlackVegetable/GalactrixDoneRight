-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "GameTimer" (GameEvent)

GameTimer.AttributeDescriptions = AttributeDescriptionList()




function GameTimer:__init()
    super("GameTimer")
end

return ExportClass("GameTimer")
