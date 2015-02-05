
use_safeglobals()

--[[
Helper functions for adding an option to the option manager

--]]

local assert = assert
local type = type
local pairs = pairs

function _G.AddOption(name, validate, select, options, default)

    assert(type(name) == "string")
    assert(type(validate) == "function")
    assert(type(select) == "function")
    assert(type(options) == "table")
    assert((type(default) == "string" or type(default) == "number"))
	
	local OptionsManager = OptionsManager

    local opt = OptionsManager:CreateOption(name)
    OptionsManager:SetSelectCallback(opt,
		function(value, confirm)
			return select(value)
		end
	)
    OptionsManager:SetValidCallback(opt, validate)
	
	local sorted = {}
	for k,v in pairs(options) do
		local insertIdx = 1		
		for i,x in pairs(sorted) do
			if v <= options[x] then	
				break
			end
			insertIdx = insertIdx + 1
		end
		table.insert(sorted,insertIdx,k)
	end
	
    for k,v in pairs(sorted) do
        if
            type(v) == "string" and
            ( type(options[v]) == "string" or
              type(options[v]) == "number" )
        then
            OptionsManager:AddItem(opt, v, options[v])
        end
    end

    OptionsManager:SetDefault(opt, default)
end

