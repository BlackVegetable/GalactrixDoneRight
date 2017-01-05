----------------------------------------------------------------------
-- FFXT - FX with Text
-- Used in the FXContainer system to represent text effects
----------------------------------------------------------------------


use_safeglobals()

class "FFXT" (GameObject)

FFXT.AttributeDescriptions = AttributeDescriptionList() 

----------------------------------------------------------------------
-- __init()
-- 
-- Sets up variables in this class
----------------------------------------------------------------------
function FFXT:__init()
    super("FFXT")
end


----------------------------------------------------------------------
-- SetDetails(msg, font)
-- 
-- The actual function that adds the data
----------------------------------------------------------------------
function FFXT:SetDetails(msg, font)
	
    local view = GameObjectViewManager:Construct("Text")	
    local textView = CastToTextView(view)
    textView:SetString(msg)
    textView:SetFont(font)
    self:SetView(view)
    view:SetSortingValue(-5)
		
end



return ExportClass("FFXT")