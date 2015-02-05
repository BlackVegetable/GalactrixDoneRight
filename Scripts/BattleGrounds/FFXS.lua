----------------------------------------------------------------------
-- FFXS - FX with Sprite
-- Used in the FXContainer system to represent sprite effects
----------------------------------------------------------------------


use_safeglobals()

class "FFXS" (GameObject)

FFXS.AttributeDescriptions = AttributeDescriptionList() 

----------------------------------------------------------------------
-- __init()
-- 
-- Sets up variables in this class
----------------------------------------------------------------------
function FFXS:__init()
    super("FFXS")
end


----------------------------------------------------------------------
-- SetDetails(msg, font)
-- 
-- The actual function that adds the data
----------------------------------------------------------------------
function FFXS:SetDetails(sprite_tag, sort, flip)
	
	if not sort then
		sort = -5
	end	
		
	if not flip then
		flip = false
	end	
	
    local view =  GameObjectViewManager:Construct("Sprite", sprite_tag)
    self:SetView(view)
	view:SetSortingValue(sort)
	view:SetFlip(flip)
	
end



return ExportClass("FFXS")