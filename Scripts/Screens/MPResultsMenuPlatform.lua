function MPResultsMenu:LoadGraphics()
   -- Not needed on PC
end

function MPResultsMenu:UnloadGraphics()
   -- Not needed on PC
end

function MPResultsMenu:Open(victory,callback, statHero,factionChange, planList, cargoList)
	LOG("MPResultsMenu Open")
	self.victory  = victory
	self.callback = callback
	self.faction  = factionChange
	self.plans    = planList
	self.cargo    = cargoList
	self.statHero = statHero
	
	return Menu.Open(self)
end

function MPResultsMenu:Defeat()
	self:set_text_raw("str_heading",translate_text("[DEFEAT]"))
	self:set_text_raw("str_message",translate_text("[BATTLE_DEFEAT]"))
end


function MPResultsMenu:Victory()	
	self:set_text_raw("str_heading",translate_text("[VICTORY]"))
	self:set_text_raw("str_message",translate_text("[BATTLE_VICTORY]"))
end
