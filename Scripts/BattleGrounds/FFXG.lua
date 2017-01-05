----------------------------------------------------------------------
-- FFXG - FX with Graphic asset
-- Used in the FXContainer system to represent graphic assets
----------------------------------------------------------------------


use_safeglobals()

class "FFXG" (GameObject)

FFXG.AttributeDescriptions = AttributeDescriptionList() 

----------------------------------------------------------------------
-- __init()
-- 
-- Sets up variables in this class
----------------------------------------------------------------------
function FFXG:__init()
    super("FFXG")
end


----------------------------------------------------------------------
-- SetDetails(msg, font)
-- 
-- The actual function that adds the data
----------------------------------------------------------------------
function FFXG:SetDetails(image_tag, sort, flip)
	
	if not sort then
		sort = -5
	end	
		
	if not flip then
		flip = false
	end	
	
    local view = GameObjectViewManager:Construct("GraphicAsset", image_tag)
    self:SetView(view)
	view:SetSortingValue(sort)
	view:SetFlip(flip)
	
end



return ExportClass("FFXG")