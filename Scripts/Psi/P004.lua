-- P004
-- Psi Power 4

local Psi = import("Psi/Psi")

class "P004" (Psi)

P004.AttributeDescriptions = AttributeDescriptionList(Psi.AttributeDescriptions)
P004.AttributeDescriptions:AddAttribute('string', 'name', {default="Happy Hacking"} )
P004.AttributeDescriptions:AddAttribute('string', 'description', {default="Something AWEOSME happens in your next hacking attempt"} )
P004.AttributeDescriptions:AddAttribute('string', 'image', {default="img_psi_power4"} )

P004.AttributeDescriptions:AddAttribute('int', 'cost', {default=15} )

function P004:__init()
	super("P004")
end

function P004:Activate(event)
	-- Do something?
end

return ExportClass("P004")
