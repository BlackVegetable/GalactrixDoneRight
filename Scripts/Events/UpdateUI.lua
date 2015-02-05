-- GameStart
--  this event is sent from the GameMenu to its battleground
--  its responsible for

use_safeglobals()




class "UpdateUI" (GameEvent)

UpdateUI.AttributeDescriptions = AttributeDescriptionList()


function UpdateUI:__init()
    super("UpdateUI")
end

return ExportClass("UpdateUI")
