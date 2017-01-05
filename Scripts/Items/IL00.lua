-- IL00
-- Player's initial loadout

--local ItemLoadout = import("Items/ItemLoadout")

class "IL00" (GameObject)

IL00.AttributeDescriptions = AttributeDescriptionList()
IL00.AttributeDescriptions:AddAttribute('string', 'ship', {default="SMBL", serialize=1, fixed=4})
IL00.AttributeDescriptions:AddAttributeCollection('string', 'items', {serialize=1, fixed=4})

function IL00:__init()
	super("IL00")
	self:InitAttributes()
	
	
end

return ExportClass("IL00")
