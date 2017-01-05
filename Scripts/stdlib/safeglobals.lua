--
-- Safe Globals
-- Prevent writing globals unless using _G
--
-- Author: Ben Kersten
-- Copyright 2007, Infinite Interactive Pty Ltd, all rights reserved.
--

function use_safeglobals()
	local level = 2

	local E = {} -- Empty function environment
	local mt = {} -- Empty metatable

	mt.__index = _G -- failed lookups passed on to global table

	mt.__newindex = function (t, n, v) -- implicit writes to nil globals throw error

		local info = debug.getinfo(2, "S")

		if info ~= nil then
		    local what = info.what
			if what ~= "C" then
			--if what ~= "main" and what ~= "C" then

				if rawget(_G, n) == nil then
					error("safeglobals.lua: assign to undeclared variable "..n, 2)
				end
			end
		end

		rawset(t, n, v)
	end

	setmetatable(E, mt) -- set the environments metatable
	setfenv(level, E) -- set the function environment
	
end
