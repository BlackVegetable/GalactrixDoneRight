
local function OpenItemPopup(itemId, x, y, menuName, popupId)
  	local recharge = translate_text("[NO_RECHARGE]")
  	if ITEMS[itemId].recharge > 0 then
	  	recharge = substitute(translate_text("[RECHARGE_X]"),ITEMS[itemId].recharge)
  	end
	
	local stringTable = { }
	if ITEMS[itemId].weapon_requirement > 0 then
		stringTable.weapon = { def  = "//TEXTBLOCK/129/75/35/26/font_info_white/center/vcenter//ICON/129/75/35/26",
		                       data = string.format("//%d//%s", ITEMS[itemId].weapon_requirement, "img_weapsquare_lit") }
	else
		stringTable.weapon = { def = "", data = "" }
	end
	
	if ITEMS[itemId].engine_requirement > 0 then
		stringTable.engine = { def  = "//TEXTBLOCK/169/75/35/26/font_info_white/center/vcenter//ICON/169/75/35/26",
		                       data = string.format("//%d//%s", ITEMS[itemId].engine_requirement, "img_engsquare_lit") }
	else
		stringTable.engine = { def = "", data = "" }
	end
	
	if ITEMS[itemId].cpu_requirement > 0 then
		stringTable.cpu = { def  = "//TEXTBLOCK/209/75/35/26/font_info_white/center/vcenter//ICON/209/75/35/26",
		                    data = string.format("//%d//%s", ITEMS[itemId].cpu_requirement, "img_cpusquare_lit") }
	else
		stringTable.cpu = { def = "", data = "" }
	end
	
	if not menuName or not popupId then
	open_custompopup_menu(string.format("//ICON/16/16/92/92//TEXT/126/21/font_info_white//TEXT/126/44/font_info_gray%s%s%s//HELP/20/110/font_info_gray//BORDER/74/113/170/255//", stringTable.weapon.def, stringTable.engine.def, stringTable.cpu.def),
		string.format("//%s//%s//%s%s%s%s//%s//",ITEMS[itemId].icon,translate_text(string.format("[%s_NAME]", itemId)),recharge,stringTable.weapon.data, stringTable.engine.data, stringTable.cpu.data, translate_text(string.format("[%s_DESC]", itemId))),
									  x, y, 1, 260)
	else
	open_custompopup_menu(string.format("//ICON/16/16/92/92//TEXT/126/21/font_info_white//TEXT/126/44/font_info_gray%s%s%s//HELP/20/110/font_info_gray//BORDER/74/113/170/255//", stringTable.weapon.def, stringTable.engine.def, stringTable.cpu.def),
		string.format("//%s//%s//%s%s%s%s//%s//",ITEMS[itemId].icon,translate_text(string.format("[%s_NAME]", itemId)),recharge,stringTable.weapon.data, stringTable.engine.data, stringTable.cpu.data, translate_text(string.format("[%s_DESC]", itemId))),
									  x, y, 1, 260, menuName, popupId)
	end
end

return OpenItemPopup