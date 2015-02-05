

local function Open(sourceMenu, heading_tag, message_tag, callback, yes_tag, no_tag)
	open_yesno_menu(heading_tag, message_tag, callback, yes_tag, no_tag)
end


local function Close(doCallback, confirm)
	
	close_yesno_menu(doCallback, confirm)
end


return {Open=Open;
		Close=Close}
