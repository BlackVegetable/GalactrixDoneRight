--------------------------------------------------------------------
-- END SPECIAL EFFECT
-- Generic Event, fired after a delay whenever some kind of special-effect
-- finishes (so that objects can be destroyed, or anything else can
-- be cleaned up)
----------------------------------------------------------------------

use_safeglobals()




class "EndSpecialEffect" (GameEvent)

EndSpecialEffect.AttributeDescriptions = AttributeDescriptionList()
EndSpecialEffect.AttributeDescriptions:AddAttribute('int', 'effect_num', {default=0})


----------------------------------------------------------------------
-- __init()
--
-- Initialises this event
----------------------------------------------------------------------
function EndSpecialEffect:__init()
	super("EndSpecialEffect")
end

return ExportClass("EndSpecialEffect")