
function CreateHeroMenu:PlatformVars()
	self.baseHeroAvatar = "img_HERO1_"

    self.heroSelect = math.random(1,4)	
end

function CreateHeroMenu:FirstSaveHero(callback)

	_G.SCREENS.CreateHeroMenu:Close()	
	local function firstSaveCallback(confirm)
		--if confirm then--Continue without saving?
			_G.GLOBAL_FUNCTIONS.EnumerateSaves(1, true) -- just force a re-enumeration of saves
			_G.CallScreenSequencer("CreateHeroMenu", "SinglePlayerMenu")
		--end
	end	
	
	_G.GLOBAL_FUNCTIONS.AutoSaveHero(_G.Hero, firstSaveCallback)				
end

function CreateHeroMenu:DisplayHero()
	local gender = "M"
	--self:set_widget_value("radial_male", 1);
	if math.mod(self.heroSelect,2) == 0 then
		gender = "F"
		--self:set_widget_value("radial_female", 1);
	end
	if math.ceil(self.heroSelect / 2) <= 1 then
		self.baseHeroAvatar = "img_HERO1_"
	else
		self.baseHeroAvatar = "img_HERO2_"
	end
	self:set_image("icon_portrait",self.baseHeroAvatar..gender)
	
	local name
	if gender == "M" then
		name = Names.GetNameFromSet(0)
	else
		name = Names.GetNameFromSet(1)
	end
	self:set_text_raw("edit_name", name)
	
	self:activate_editor("edit_name")
end

