


function InvCrew:ShowCrew(crew,strings,x_offset,y_offset)
	open_custompopup_menu("//TEXT/140/1/font_heading//ICON/9/39/120/120//ICON/5/35/128/128//TEXT/140/45/font_info_white//TEXT/140/65/font_info_white//TEXT/140/85/font_info_white//HELP/140/110/font_info_blue//BACKGROUND/img_black//BORDER/0/150/255/255//",
		string.format("//%s//%s//img_dlg//%s//%s//%s//%s//", translate_text(CREW[crew].name), CREW[crew].portrait, strings.race, strings.gender, strings.age, strings.desc),
			x_offset,y_offset,1,400)

end

function InvCrew:OnMouseLeave(id, x, y)
	if not _G.is_open("TutorialMenu") then
		close_custompopup_menu()
	end
	--return Menu.MESSAGE_HANDLED
	return Menu.OnMouseLeave(self, id, x, y)
end



function InvCrew:OnMouseEnter(id, x, y)
	LOG("InvCrew OnMouseEnter " .. id)
	
	self:MouseOverCrew(id, x, y)
	
	return Menu.OnMouseEnter(self, id, x, y)	
end