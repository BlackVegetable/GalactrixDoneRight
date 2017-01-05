



-- ExportClass
--	This is meant to be used at the end of files which use the luabind class system
--		return ExportClass(MyNewClass)
--	We do this so that the reference to the class isnt held in the global table
--	This is useful with import and autoload tables, because the class can still be GCed 
--	when its no longer in use
function ExportClass(name)
	-- the luabind class system stores the class by name in the global table
	-- this is where we get the class from
	local class	= _G[name];
	assert(class);
	-- but we dont want to hold ref to class in globals table
	-- it prevents the class from being unloaded
	-- so release the global reference
	_G[name]	= nil;
	return class;
end


-- ExportSingleInstance
--	This is a utility function
--	It is meant to be used when using lua classes where we only want one instance of the class
--		Eg with screens by default we have only one instance per screen
--		so at the bottom of our screen files we export the single instance.
--		this causes the screen to be constructed and returned
function ExportSingleInstance(name)
	-- the luabind class system stores the class by name in the global table
	-- this is where we get the class from
	local class	= _G[name];
	assert(class);
	-- but we dont want to hold ref to class in globals table
	-- it prevents the class from being unloaded
	-- so release the global reference
	_G[name]	= nil;
	return class();
end



function ForceRange(v, minVal, maxVal)
	assert(maxVal > minVal)
	local v = v;
	v = math.max(v, minVal)
	v = math.min(v, maxVal)
	return v
end



-- Round(num)
-- 	A number-rounding function, since Lua doesn't have one
--  params: - number - the number to round up or down
--  return: - An integer, which is the rounded result of the number
function Round(number)

	if (number < 0) then
		return math.ceil(number - 0.5)
	end
	
	return math.floor(number + 0.5)
	
end