
-- autoload
-- creates tables that load content on demand
require "import"


-- creates a new autoload table
function autoload(path)
	local m = {}
	local t = {}
	setmetatable(t,m);
	assert(type(path) == "string")
	m.__index = function(t, name)
		local file = path .. name
		local ret = import(file)

		if (ret ~= nil) then
			rawset(t, name, ret);
		else
			--print("autoload warning: "..file.." didnt return a value.\n");
		end
		
		return rawget(t,name)
	end
	
	return t;
end


return autoload



