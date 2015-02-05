

local function OpenShipPopup(shipId, x, y, hero)
	local function GetSpeedInfo(speed)
		local data = { }
		LOG("Speed = " .. tostring(speed))
		--data.greenBar = "//  157,55
		if speed == 1 then
			data.greenBar  = "//ICON/157/65/26/32"
			data.redBar    = "//ICON/183/65/98/32"
			data.greenIcon = "//img_speed_green_1"
			data.redIcon   = "//img_speed_red_1"
		elseif speed == 2 then
			data.greenBar  = "//ICON/157/65/50/32"
			data.redBar    = "//ICON/207/65/73/32"
			data.greenIcon = "//img_speed_green_2"
			data.redIcon   = "//img_speed_red_2"
		elseif speed == 3 then
			data.greenBar  = "//ICON/157/65/74/32"
			data.redBar    = "//ICON/231/65/49/32"
			data.greenIcon = "//img_speed_green_3"
			data.redIcon   = "//img_speed_red_3"
		elseif speed == 4 then
			data.greenBar  = "//ICON/157/65/98/32"
			data.redBar    = "//ICON/255/65/25/32"
			data.greenIcon = "//img_speed_green_4"
			data.redIcon   = "//img_speed_red_4"
		else
			data.greenBar  = "//ICON/157/65/123/32"
			data.redBar    = ""
			data.greenIcon = "//img_speedbar_green"
			data.redIcon   = ""
		end
		return data
	end
	local speedData = GetSpeedInfo(math.max(1, math.min(5, math.ceil(SHIPS[shipId].max_speed / 50))))
	
	local hull = SHIPS[shipId].hull
	local shield = SHIPS[shipId].shield
	if(hero ~= nil)then
		hull = hull + (hero:GetLevel()-1)
		shield = shield + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(hero:GetCombatStat("pilot"),1.0))
	end	
	
	--local shipType = translate_text(_G.GLOBAL_FUNCTIONS.GetShipClass(SHIPS[shipId].max_items)).." ("..substitute(translate_text("[_SLOTS]"), SHIPS[shipId].max_items)..")"
	LOG("SHIPPOPUP " .. string.format("img_%s", shipId))
	local str = { 	name = string.format("[%s_NAME]", shipId), 
					portrait = string.format("img_%s", shipId), 
	              	class = string.format("%s (%s)", translate_text(_G.GLOBAL_FUNCTIONS.GetShipClass(SHIPS[shipId].max_items)), substitute(translate_text("[_SLOTS]"), SHIPS[shipId].max_items)),
					hull = substitute(translate_text("[_HULL_POINTS]"), hull),
					weap = tostring(SHIPS[shipId].weapons_rating), 
					eng = tostring(SHIPS[shipId].engine_rating), 
					cpu = tostring(SHIPS[shipId].cpu_rating), 
					shield = tostring(shield),
					cargo = substitute(translate_text("[_CARGO_CAPACITY]"), tostring(SHIPS[shipId].cargo_capacity)) }

	open_custompopup_menu(string.format("%s%s%s%s", "//TITLE/13/font_button//ICON/20/60/128/128//TEXT/157/50/font_info_white",speedData.greenBar,speedData.redBar,"//TEXT/158/108/font_info_white//TEXT/159/149/font_info_white//TEXT/38/195/font_info_white//TEXT/175/195/font_info_white//TEXT/38/273/font_info_white//TEXT/171/273/font_info_white//ICON/39/226/37/34//ICON/174/226/37/34//ICON/39/304/37/34//ICON/174/304/37/34//TEXT/83/224/font_button//TEXT/213/224/font_button//TEXT/83/303/font_button//TEXT/213/303/font_button//TITLE/344/font_info_gray//BORDER/74/113/170/255//"),
	                      string.format("%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s", str.name, "//", str.portrait, "//[SPEED]//", speedData.greenIcon, speedData.redIcon, "//", str.class, "//", str.hull, "//[SHIELDS]//[WEAPONS]//[ENGINE]//[CPU]//img_blue_gem//img_red_gem//img_yellow_gem//img_green_gem//", str.shield, "//", str.weap, "//", str.eng, "//", str.cpu, "//", str.cargo, "//"),
								 x, y, 0,300)
end

return OpenShipPopup