

--used as world object for GemSelectMenu

class "GSEL" (GameObject)

GSEL.AttributeDescriptions = AttributeDescriptionList()

function GSEL:__init()
	super("GSEL")
end


function GSEL:OnEventCursorAction(event)
	
	local obj = event:GetAttribute("object")
	local up = event:GetAttribute("up")
	
	if up and obj and obj:HasAttribute("isGem") then
	
		assert(obj,"no object")
		assert(obj:HasAttribute("isGem"))
		if _G.is_open("GameMenu") then
			--SCREENS.GameMenu.world:SwitchGems(SCREENS.GemSelectMenu.grid,obj.classIDStr)
			local switchEvent = GameEventManager:Construct("SwitchGems")
			switchEvent:SetAttribute("new_gem_id",obj.classIDStr)	
			LOG("PushAttribute "..tostring(SCREENS.GemSelectMenu.grid))
			switchEvent:PushAttribute("grid_id",SCREENS.GemSelectMenu.grid)
			switchEvent:SetAttribute("force_update", 1)
			switchEvent:SetAttribute("cheat", 1)
			GameEventManager:Send(switchEvent,SCREENS.GameMenu.world.host_id)			
		else
			SCREENS.EditPuzzleMenu:GetWorld():SetNewGem(obj.classIDStr)
		end
		
		SCREENS.GemSelectMenu:Close()
	end
	
end


return ExportClass("GSEL")