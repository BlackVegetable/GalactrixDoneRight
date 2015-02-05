-- P001
-- Psi Power 1

local Psi = import("Psi/Psi")

class "P001" (Psi)

P001.AttributeDescriptions = AttributeDescriptionList(Psi.AttributeDescriptions)
P001.AttributeDescriptions:AddAttribute('string', 'name', {default="Speedy Ship"} )
P001.AttributeDescriptions:AddAttribute('string', 'description', {default="Speeds up the ship while in-system. Lasts 3 days."} )
P001.AttributeDescriptions:AddAttribute('string', 'image', {default="img_psi_power1"} )

P001.AttributeDescriptions:AddAttribute('int', 'cost', {default=0} )

function P001:__init()
	super("P001")
	self:InitAttributes()
end

function P001:Activate(event)
	-- Speed up ship temporarily
end

return ExportClass("P001")