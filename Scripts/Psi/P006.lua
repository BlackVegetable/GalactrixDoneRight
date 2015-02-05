-- P006
-- Psi Power 6

local Psi = import("Psi/Psi")

class "P006" (Psi)

P006.AttributeDescriptions = AttributeDescriptionList(Psi.AttributeDescriptions)
P006.AttributeDescriptions:AddAttribute('string', 'name', {default="Deft Dealings"} )
P006.AttributeDescriptions:AddAttribute('string', 'description', {default="The next trader you visit will offer you better deals."} )
P006.AttributeDescriptions:AddAttribute('string', 'image', {default="img_psi_power6"} )

P006.AttributeDescriptions:AddAttribute('int', 'cost', {default=25} )

function P006:__init()
	super("P006")
end

function P006:Activate(event)
	-- Offer 10% more gold on sales and 10% lower price on purchases on your next trading attempt
end

return ExportClass("P006")
