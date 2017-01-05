

use_safeglobals()




class "HintArrow" (GameEvent)

HintArrow.AttributeDescriptions = AttributeDescriptionList()
HintArrow.AttributeDescriptions:AddAttribute("int","turn",{default=1})


function HintArrow:__init()
    super("HintArrow")
	
	LOG("HintArrow Event Created")
end


function HintArrow:do_OnReceive()
	LOG("HintArrow received")
end

return ExportClass("HintArrow")
