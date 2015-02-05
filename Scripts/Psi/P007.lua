-- P007
-- Psi Power 7

local Psi = import("Psi/Psi")

class "P007" (Psi)

P007.AttributeDescriptions = AttributeDescriptionList(Psi.AttributeDescriptions)
P007.AttributeDescriptions:AddAttribute('string', 'name', {default="Brilliant Battle"} )
P007.AttributeDescriptions:AddAttribute('string', 'description', {default="Enemy's shields are drained by half at the start of your next battle."} )
P007.AttributeDescriptions:AddAttribute('string', 'image', {default="img_psi_power7"} )

P007.AttributeDescriptions:AddAttribute('int', 'cost', {default=30} )

function P007:__init()
	super("P007")
end

function P007:Activate(event)
	-- Drain shields by half in next battle
end

return ExportClass("P007")
