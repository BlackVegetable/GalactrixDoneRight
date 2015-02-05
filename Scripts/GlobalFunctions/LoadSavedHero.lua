
local function LoadSavedHero(heroSave, slot)
	local newHero
	--[[]]
	local save = SaveGameManager:Create(heroSave, 1)
	LOG("SaveCreated for "..tostring(save))
	
	local objs = save:Load() -- table of loaded objects
	
	if type(objs) == "table" then
		newHero = objs[1]
	end
	--]]
	if newHero then
		newHero.savegame = save
		local loadout = newHero:GetAttributeAt("ship_list",newHero:GetAttribute("ship_loadout"))
		local ship = _G.GLOBAL_FUNCTIONS.LoadShip(loadout:GetAttribute("ship"))
		newHero:SetAttribute("curr_ship", ship)
		ship.pilot = newHero
	else
		LOG("Load Hero Save Failed - load generic hero")
		newHero = LoadHero("H001")
	end
	_G.LoadRunningText(newHero)
	
	_G.HeroLoadTutorialSystem(newHero)
	return newHero
end

return LoadSavedHero