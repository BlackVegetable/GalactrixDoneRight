function InvHero:PsiPowerPopup(id,x,y)
   open_custompopup_menu("//HELP/5/3/font_info_gray//BORDER/50/150/255/255//", string.format("//[PSI_POWER%d_DESC]//", id-110), 239+((id-111)*109), 497,1,250)
end

function InvHero:HideWidgets()
	-- not needed for pc
end

function InvHero:ShowWidgets()
	-- not needed for pc
end

function InvHero:PlatformButtons(id, x, y)
	return Menu.MESSAGE_NOT_HANDLED
end

function InvHero:OnButtonAvailable(id, x, y, on)
	LOG("InvHero:OnButtonAvailable()")
	close_custompopup_menu()
	if id == 11 then
		if on and (self:ButtonHoverCheck() == true) then
			open_custompopup_menu("//HELP/5/3/font_info_gray//BORDER/50/150/255/255//", "//[TRAIN_INSTRUCTIONS]//", x,y,1,250)
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 12 then
		if on and (self:ButtonHoverCheck() == true) then
			open_custompopup_menu("//HELP/5/3/font_info_gray//BORDER/50/150/255/255//", "//[REVIEW_PLANS_INSTRUCTIONS]//", x, y, 1, 250)
		end
		return Menu.MESSAGE_HANDLED
	elseif id == 10 then
		if on and (self:ButtonHoverCheck() == true) then
			open_custompopup_menu("//HELP/5/3/font_info_gray//BORDER/50/150/255/255//", "//[REVIEW_RUMORS_INSTRUCTIONS]//", x, y, 1, 250)
		end
		return Menu.MESSAGE_HANDLED
	elseif id > 110 and id < 120 then
		if ((id - 110) <= SCREENS.InventoryFrame.hero:GetAttribute("psi_powers")) then
			if on and (self:ButtonHoverCheck() == true) then
				self:PsiPowerPopup(id,x,y)
				return Menu.MESSAGE_HANDLED
			end
		end		
	end
	return Menu.MESSAGE_NOT_HANDLED
end

function InvHero:ButtonClickCheck()
	return true
end

function InvHero:ButtonHoverCheck()
	return true
end