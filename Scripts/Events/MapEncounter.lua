


use_safeglobals()



class "MapEncounter" (GameEvent)

MapEncounter.AttributeDescriptions = AttributeDescriptionList()
MapEncounter.AttributeDescriptions:AddAttribute("GameObject","system",{})

function MapEncounter:__init()
	super("MapEncounter")
end

return ExportClass("MapEncounter")