-- Ship Loadout
-- Defines a ship code and associated items

class 'ItemLoadout' (GameObject)

ItemLoadout.AttributeDescriptions = AttributeDescriptionList()
ItemLoadout.AttributeDescriptions:AddAttribute('string', 'ship', {serialize=1})
ItemLoadout.AttributeDescriptions:AddAttributeCollection('string', 'items', {serialize=1})

function ItemLoadout:__init(clid)
	super(clid)
	self:InitAttributes()
end

return ExportClass("ItemLoadout")