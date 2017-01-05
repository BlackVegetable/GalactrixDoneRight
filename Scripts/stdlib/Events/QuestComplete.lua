--  QuestComplete

use_safeglobals()



class "QuestComplete" (GameEvent)

QuestComplete.AttributeDescriptions = AttributeDescriptionList()
QuestComplete.AttributeDescriptions:AddAttribute("string","quest_id",{})



function QuestComplete:__init()
    super("QuestComplete")
end

return ExportClass("QuestComplete")