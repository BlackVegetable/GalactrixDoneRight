-- P003
-- Psi Power 3

local Psi = import("Psi/Psi")

class "P003" (Psi)

P003.AttributeDescriptions = AttributeDescriptionList(Psi.AttributeDescriptions)
P003.AttributeDescriptions:AddAttribute('string', 'name', {default="Crazy Crafting"} )
P003.AttributeDescriptions:AddAttribute('string', 'description', {default="Cogs appear more frequently in your next crafting attempt."} )
P003.AttributeDescriptions:AddAttribute('string', 'image', {default="img_psi_power3"} )

P003.AttributeDescriptions:AddAttribute('int', 'cost', {default=10} )

function P003:__init()
	super("P003")
end

function P003:Activate(event)
	-- Increase spawn rate of cogs in next crafting attempt
end

return ExportClass("P003")
