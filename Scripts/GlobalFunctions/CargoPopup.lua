
local function OpenCargoPopup(cargoType, x, y, currentPrice)
	local font
	if currentPrice == _G.DATA.Cargo[cargoType].cost or currentPrice == 0 then
		font = "font_info_gray"
	elseif currentPrice > _G.DATA.Cargo[cargoType].cost then
		font = "font_info_green"
	else 
		font = "font_info_red"
	end
	open_custompopup_menu(string.format("//ICON/14/11/41/34//TEXT/62/20/font_info_white//TEXT/10/60/font_info_white//TEXT/14/83/%s//TEXT/8/118/font_info_white//TEXT/14/141/font_info_gray//BORDER/0/121/192/255//",font),
		string.format("//img_cargo%d//[%s_NAME]//[CURRENT_PRICE]//%s//[AVERAGE_PRICE]//%s//",cargoType,string.upper(_G.DATA.Cargo[cargoType].effect),substitute(translate_text("[_CR_PER_UNIT]"), currentPrice),substitute(translate_text("[_CR_PER_UNIT]"), _G.DATA.Cargo[cargoType].cost)), x, y, -1, 160)

end

return OpenCargoPopup