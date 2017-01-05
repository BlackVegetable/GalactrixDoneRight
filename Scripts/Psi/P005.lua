-- P005
-- Psi Power 5

local Psi = import("Psi/Psi")

class "P005" (Psi)

P005.AttributeDescriptions = AttributeDescriptionList(Psi.AttributeDescriptions)
P005.AttributeDescriptions:AddAttribute('string', 'name', {default="Terrific Teleport"} )
P005.AttributeDescriptions:AddAttribute('string', 'description', {default="Teleport instantly to another system you have already visited."} )
P005.AttributeDescriptions:AddAttribute('string', 'image', {default="img_psi_power5"} )

P005.AttributeDescriptions:AddAttribute('int', 'cost', {default=20} )

function P005:__init()
	super("P005")
end

function P005:Activate(event)
	-- Open a dialog asking player to select a system, and teleport there instantly
end

return ExportClass("P005")
