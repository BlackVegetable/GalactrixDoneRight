-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "OpenPopup" (GameEvent)

OpenPopup.AttributeDescriptions = AttributeDescriptionList()
OpenPopup.AttributeDescriptions:AddAttribute('GameObject', "object", {})
OpenPopup.AttributeDescriptions:AddAttribute('int', "x", {})
OpenPopup.AttributeDescriptions:AddAttribute('int', "y", {})

function OpenPopup:__init()
    super("OpenPopup")
end

return ExportClass("OpenPopup")
