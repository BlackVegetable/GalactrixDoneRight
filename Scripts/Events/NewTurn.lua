--  New Turn
--  this event is sent from battleground to player at start of their turn

use_safeglobals()



class "NewTurn" (GameEvent)

NewTurn.AttributeDescriptions = AttributeDescriptionList()
NewTurn.AttributeDescriptions:AddAttribute("GameObject","BattleGround",{})
NewTurn.AttributeDescriptions:AddAttribute("int", "item_newturn", {default=0})



function NewTurn:__init()
    super("NewTurn")
end

return ExportClass("NewTurn")