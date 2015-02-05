
local function AutoSaveHero(hero, continue)
	--[[]]	
	
	local saveResult

	--hero:SetToSave()
	
	
	if hero.auto_save and not _G.GLOBAL_FUNCTIONS.DemoMode() then	
				
		local savegame
		if hero ~= nil then
			--Temp code to clean current game saves of old ship references.
			local num_children = hero:GetNumChildren()		
			for i=0,num_children-1 do
				local child = hero:GetChild(0)
				hero:RemoveChild(child)
			end
			local save_name = hero:GetAttribute("name")
			save_name = string.gsub (save_name, " ", "_")
			LOG("SaveGameManager:Create() "..save_name)

			savegame = hero.savegame
			if not savegame then
				savegame = SaveGameManager:Create(save_name, 1)
				hero.savegame = savegame
			end
			LOG("SaveGame Created")
			saveResult = savegame:Save({hero})
			Settings:Write("last_save", save_name)
			Settings:Save() -- saves the values to the registry		
			LOG("Hero saved")	
		end    	
		
		if saveResult then
			SCREENS.BlockingMessageMenu:CloseASAP()
			hero.auto_save = false
		else
			SCREENS.BlockingMessageMenu:ShowMessage("[ERROR]","[SAVE_FAILURE]")
		end		
		
	
		SCREENS.BlockingMessageMenu:Open("[SAVING]","[PC_SAVE_WARNING]",nil, continue)		
		--]]
	elseif continue then
			continue()			
	end
	
end

return AutoSaveHero