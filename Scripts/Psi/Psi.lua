-- Psi
-- This class is the base class for all psi powers

class 'Psi' (GameObject)

Psi.AttributeDescriptions = AttributeDescriptionList()

Psi.AttributeDescriptions:AddAttribute('string', 'name', {default="Time Crease"} )
Psi.AttributeDescriptions:AddAttribute('string', 'description', {default=""} )
Psi.AttributeDescriptions:AddAttribute('string', 'image', {default=""} )

Psi.AttributeDescriptions:AddAttribute('int', 'cost', {default=0} )


function Psi:__init(clid)
	super(clid)
	self:InitAttributes()
end



function Psi:Activate(event)
	-- subclass function
end

return ExportClass('Psi')
