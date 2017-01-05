

local function fakeOpen(baseObj,param1,func)
	if type(func)=="function" then
		func()
	end
	
end

local function fakeIsOpen()
	return false
end

return {["Open"]=fakeOpen;
		["IsOpen"]=fakeIsOpen;
}