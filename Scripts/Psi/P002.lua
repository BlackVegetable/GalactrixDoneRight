-- P002
-- Psi Power 2

local Psi = import("Psi/Psi")

class "P002" (Psi)

P002.AttributeDescriptions = AttributeDescriptionList(Psi.AttributeDescriptions)
P002.AttributeDescriptions:AddAttribute('string', 'name', {default="Magic Mining"} )
P002.AttributeDescriptions:AddAttribute('string', 'description', {default="Doubles all cargo acquired from your next mining attempt."} )
P002.AttributeDescriptions:AddAttribute('string', 'image', {default="img_psi_power2"} )

P002.AttributeDescriptions:AddAttribute('int', 'cost', {default=5} )

function P002:__init()
	super("P002")
end

function P002:Activate(event)
	-- Increase cargo gained in next mining attempt
end

return ExportClass("P002")
