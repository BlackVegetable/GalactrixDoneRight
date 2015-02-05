--Ship Damage - deals damage first to ships shield, then to ship once shield is depleted.

use_safeglobals()






class "ShipDamage" (GameEvent)

ShipDamage.AttributeDescriptions = AttributeDescriptionList()
ShipDamage.AttributeDescriptions:AddAttribute('int','amount',{default=3})
ShipDamage.AttributeDescriptions:AddAttribute('string','type',{default="mine"})
ShipDamage.AttributeDescriptions:AddAttribute('GameObject','source',{})
ShipDamage.AttributeDescriptions:AddAttribute('GameObject','BattleGround',{})
ShipDamage.AttributeDescriptions:AddAttribute('GameObject','target',{})
ShipDamage.AttributeDescriptions:AddAttribute('int','direct',{default=0})


function ShipDamage:__init()
    super("ShipDamage")
end

return ExportClass("ShipDamage")
