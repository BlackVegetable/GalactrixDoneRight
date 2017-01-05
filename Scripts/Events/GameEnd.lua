-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for 

use_safeglobals()




class "GameEnd" (GameEvent)

GameEnd.AttributeDescriptions = AttributeDescriptionList()
GameEnd.AttributeDescriptions:AddAttribute('int','result',{default=0})


-- attribute collection for members of side 1
-- attribute collection for members of side 2

function GameEnd:__init()
    super("GameEnd")
end

return ExportClass("GameEnd")
