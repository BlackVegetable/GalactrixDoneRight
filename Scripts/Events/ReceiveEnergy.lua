-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "ReceiveEnergy" (GameEvent)

ReceiveEnergy.AttributeDescriptions = AttributeDescriptionList()
ReceiveEnergy.AttributeDescriptions:AddAttribute('string', 'effect', {default="intel"})
ReceiveEnergy.AttributeDescriptions:AddAttribute('int',    'amount', {default=3})
ReceiveEnergy.AttributeDescriptions:AddAttribute('int',    'mutate', {default=1})

ReceiveEnergy.name = "ReceiveEnergy"

function ReceiveEnergy:__init()
    super("ReceiveEnergy")
end

return ExportClass("ReceiveEnergy")
