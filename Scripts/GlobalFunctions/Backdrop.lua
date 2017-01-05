
local function Close()
	SCREENS.BackdropMenu:Close()
end

local function Open()
	
	SCREENS.BackdropMenu:Open()
end

return {["Open"]=Open;
	["Close"]=Close;
}