
--[[ _G.GLOBAL_FUNCTIONS.Multiplayer ]]

-- for calling mp functions that take no arguments
local function GetResult(func)
	local result
	
	local function f(valid, value)
		if valid == 0 then
			result = value
		end
	end
	
	func(f)
	
	return result
end


-- for calling mp_get_player_ID_from_index with player index
local function GetPlayerID(player)
	local id
	
	local function f(valid, value)
		if valid == 0 then
			id = value
		end
	end
	
	mp_get_player_ID_from_index(f, player)
	
	return id
end

local function GetResultParams(func, arg1)
	local result
	
	local function f(valid, value)
		if valid == 0 then
			result = value
		end
	end
	
	func(f, arg1)
	
	return result
end

return {
	["GetPlayerID"] = GetPlayerID;
	["GetResult"] = GetResult;
	["GetResultParams"] = GetResultParams;
}
