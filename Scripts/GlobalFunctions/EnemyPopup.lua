

local function OpenEnemyPopup(enemy, x, y, hero, id)
	local shipId = enemy:GetAttribute("curr_ship").classIDStr
	local level_val = enemy:GetLevel()
	
	local function GetSpeedInfo(speed)
		local data = { }
		LOG("Speed = " .. tostring(speed))
		--data.greenBar = "//  157,55
		if speed == 1 then
			data.greenBar  = "//ICON/157/155/26/32"
			data.redBar    = "//ICON/183/155/98/32"
			data.greenIcon = "//img_speed_green_1"
			data.redIcon   = "//img_speed_red_1"
		elseif speed == 2 then
			data.greenBar  = "//ICON/157/155/50/32"
			data.redBar    = "//ICON/207/155/73/32"
			data.greenIcon = "//img_speed_green_2"
			data.redIcon   = "//img_speed_red_2"
		elseif speed == 3 then
			data.greenBar  = "//ICON/157/155/74/32"
			data.redBar    = "//ICON/231/155/49/32"
			data.greenIcon = "//img_speed_green_3"
			data.redIcon   = "//img_speed_red_3"
		elseif speed == 4 then
			data.greenBar  = "//ICON/157/155/98/32"
			data.redBar    = "//ICON/255/155/25/32"
			data.greenIcon = "//img_speed_green_4"
			data.redIcon   = "//img_speed_red_4"
		else
			data.greenBar  = "//ICON/157/155/123/32"
			data.redBar    = ""
			data.greenIcon = "//img_speedbar_green"
			data.redIcon   = ""
		end
		return data
	end
	local speedData = GetSpeedInfo(math.max(1, math.min(5, math.ceil(SHIPS[shipId].max_speed / 50))))
	
	local hull_val = SHIPS[shipId].hull + (enemy:GetLevel()-1)
	local shield_val = SHIPS[shipId].shield + math.floor(_G.GLOBAL_FUNCTIONS.DiminishingReturns(enemy:GetCombatStat("pilot"),1.0))
	
	--local shipType = translate_text(_G.GLOBAL_FUNCTIONS.GetShipClass(SHIPS[shipId].max_items)).." ("..substitute(translate_text("[_SLOTS]"), SHIPS[shipId].max_items)..")"
	LOG("ENEMYPOPUP " .. string.format("img_%s", shipId))
	local str = { 	--name = string.format("[%s_NAME]", shipId), 
				    name = enemy:GetAttribute("name"),
	              	class = string.format("%s (%s)", translate_text(_G.GLOBAL_FUNCTIONS.GetShipClass(SHIPS[shipId].max_items)), substitute(translate_text("[_SLOTS]"), SHIPS[shipId].max_items)),
					level = string.format("%s %d", translate_text("[LEVEL_]"), level_val),
						damage = string.format("%s +%d", translate_text("[DAMAGE_DONE]"), math.floor(level_val/5)),
					hull = substitute(translate_text("[_HULL_POINTS]"), hull_val),
					shield = string.format("%s %d", translate_text("[SHIELDS]"), shield_val) }
					
	local invFormat = "TITLE/200/font_info_white"
	local invData = string.upper(translate_text("[INVENTORY]"))
	
	local loadout = enemy:GetCurrLoadout()
	local numItems = loadout:NumAttributes('items')

	if numItems == 0 then
		invData = " "
	else
		local yValue = 230
		
		local ship = loadout:GetAttribute("ship")
		local energy = { weapon = SHIPS[ship].weapons_rating, engine = SHIPS[ship].engine_rating, cpu = SHIPS[ship].cpu_rating }
		
		local function showItemData(item) -- could have been doMagicStuff()
			--local item = loadout:GetAttributeAt('items',i)
			local iconFormat = string.format("ICON/20/%d/48/48", yValue) 
			local textFormat = string.format("TEXT/72/%d/font_info_white", yValue+12)
			invFormat = string.format("%s//%s//%s", invFormat, iconFormat, textFormat)
			invData = string.format("%s//%s//%s", invData, ITEMS[item].icon, translate_text(string.format("[%s_NAME]",item)))
			
			yValue = yValue + 50
			energy.weapon = energy.weapon - ITEMS[item].weapon_requirement
			energy.engine = energy.engine - ITEMS[item].engine_requirement
			energy.cpu    = energy.cpu    - ITEMS[item].cpu_requirement
		end

		for i=1, math.min(numItems, SHIPS[ship].max_items) do
			local item = loadout:GetAttributeAt("items", i)
			if not((energy.weapon - ITEMS[item].weapon_requirement) < 0) and not((energy.engine - ITEMS[item].engine_requirement) < 0) and not((energy.cpu - ITEMS[item].cpu_requirement) < 0) then
				if enemy.classIDStr == "Hero" then
					showItemData(item)
				elseif HEROES[enemy.classIDStr][string.format("item_%d_min", i)] then
					if hero and HEROES[enemy.classIDStr][string.format("item_%d_min", i)] <= hero:GetLevel() then
						showItemData(item)
					end
					-- The only case where the item isn't shown: the enemy is not a Player, the item does have a minimum and that minimum is less than the heros level
				else
					showItemData(item)
				end
			end
		end
	end

	LOG(string.format("InvFormat: %s", invFormat))
	LOG(string.format("InvData: %s", invData))
	if id then
		open_custompopup_menu(string.format("//%s//%s//%s//%s//%s//%s//%s//%s%s//%s//%s//", "TITLE/13/font_button", "TITLE/45/font_info_gray", "TITLE/70/font_info_white", "TITLE/95/font_info_white", "TEXT/7/120/font_info_white", "TEXT/175/120/font_info_white", "TEXT/7/160/font_info_white", speedData.greenBar, speedData.redBar, invFormat, "BORDER/74/113/170/255"),
							  string.format("//%s//%s//%s//%s//%s//%s//%s//%s%s//%s//",str.name, str.class, str.level, str.damage, str.shield, str.hull, "[SPEED]", speedData.greenIcon, speedData.redIcon, invData),
							  x, y, 4, 300, str.name, id)
	else
		open_custompopup_menu(string.format("//%s//%s//%s//%s//%s//%s//%s//%s%s//%s//%s//", "TITLE/13/font_button", "TITLE/45/font_info_gray", "TITLE/70/font_info_white", "TITLE/95/font_info_white", "TEXT/7/120/font_info_white", "TEXT/175/120/font_info_white", "TEXT/7/160/font_info_white", speedData.greenBar, speedData.redBar, invFormat, "BORDER/74/113/170/255"),
							  string.format("//%s//%s//%s//%s//%s//%s//%s//%s%s//%s//",str.name, str.class, str.level, str.damage, str.shield, str.hull, "[SPEED]", speedData.greenIcon, speedData.redIcon, invData),
							  x, y, 4, 300)
	end
	
	--[[
	open_custompopup_menu(string.format("//%s//%s//%s//%s%s//%s//%s//%s//%s//%s//%s//","TITLE/13/font_button", "ICON/20/60/128/128", "TEXT/157/50/font_info_white", speedData.greenBar, speedData.redBar, "TEXT/158/108/font_info_white", "TEXT/159/149/font_info_white", "TEXT/38/195/font_info_white", "ICON/39/226/37/34", "TEXT/83/224/font_button", "BORDER/74/113/170/255"),
						  string.format("//%s//%s//%s//%s%s//%s//%s//%s//%s//%s//",str.name, str.portrait, "[SPEED]", speedData.greenIcon, speedData.redIcon, str.class, str.hull, "[SHIELDS]", "img_blue_gem", str.shield),
						  x, y, 0, 300)
	open_custompopup_menu(string.format("//%s//%s//%s//%s//", "TITLE/13/font_button", "ICON/20/60/128/128", "TEXT/157/50/font_info_white",speedData.greenBar,speedData.redBar,"//TEXT/158/108/font_info_white//TEXT/159/149/font_info_white//TEXT/38/195/font_info_white//TEXT/175/195/font_info_white//TEXT/38/273/font_info_white//TEXT/171/273/font_info_white//ICON/39/226/37/34//ICON/174/226/37/34//ICON/39/304/37/34//ICON/174/304/37/34//TEXT/83/224/font_button//TEXT/213/224/font_button//TEXT/83/303/font_button//TEXT/213/303/font_button//BORDER/74/113/170/255//"),
	                      string.format("%s//%s//%s//%s%s//%s//%s//%s%s%s%s%s%s", str.name, str.portrait, "[SPEED]", speedData.greenIcon, speedData.redIcon, str.class, str.hull, "[SHIELDS]//[WEAPONS]//[ENGINE]//[CPU]//img_blue_gem//img_red_gem//img_yellow_gem//img_green_gem//", str.shield, "//", str.weap, "//", str.eng, "//", str.cpu, "//"),
								 x, y, 0,300)
	]]
end

return OpenEnemyPopup