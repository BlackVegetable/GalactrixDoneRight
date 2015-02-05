
--[[ _G.XBOXLive ]]

require "xlast"

_G.xbox_live_settings_t = { 
	hosting = false,
	game_type = NetworkGameType.STANDARD,
	query = _G.XLAST.SESSION_MATCH_QUERY_FINDMATCH,
	heroes_allowed = 1,
	enemies_allowed = 1,
	level_min = 1,
	level_max = 50,
	class_max = 8,
	game_timer = 15,
	private = 0,
	opponent_xuid = nil
	}
	
_G.xbox_live_msg_handler = nil


local function SetProperties(properties_t)
	LOG("XBOXLive.SetProperties")
	assert(type(properties_t) == "table")
	
	for k,v in pairs(properties_t) do
		--[[ DEBUG ]]
		if xbox_live_settings_t[k] ~= nil then
			LOG("XBOXLive Setting : " .. tostring(k) .. " -> " .. tostring(v))
		else
			LOG("XBOXLive New Setting : " .. tostring(k) .. " -> " .. tostring(v))
		end
		--[[ END DEBUG ]]
		
		xbox_live_settings_t[k] = v
	end
end


local function GetProperty(key)
	LOG("XBOXLive.GetProperty " .. tostring(key))
	return xbox_live_settings_t[key]
end


local function SetMessageHandler(message_func)
	LOG("XBOXLive.SetMessageHandler " .. tostring(message_func))
	assert(message_func ~= nil, "cannot set message handler to nil ever!")
	assert(type(message_func) == "function")
	xbox_live_msg_handler = message_func
end


local function MessageHandler(senderID, messageType, strMessageData)
	LOG("XBOXLive.MPMessage: SenderID : " .. tostring(senderID) .. " Message Type : " .. tostring(messageType) .. " Message Data : " .. tostring(strMessageData))

	if type(xbox_live_msg_handler) == "function" then
		xbox_live_msg_handler(senderID, messageType, strMessageData)
	else
		LOG("XBOXLive.MessageHandler: No message handler")
	end
end


local function StopSearch(stop_func)
	LOG("XBOXLive.StopSearch " .. tostring(stop_func))
	assert(type(stop_func) == "function")
	
	mp_stop_finding_games(stop_func)
end


local function Search(begin_func, enum_func, retry_func)
	LOG("XBOXLive.Search - begin " .. tostring(begin_func) .. ", enum " .. tostring(enum_func) .. ", clear " .. tostring(retry_func))
	assert(type(begin_func) == "function")
	assert(type(enum_func) == "function")
	assert(type(retry_func) == "function")
	
	mp_set_retrysearch_callback(retry_func)
	
	-- matchmaking query
	
	local query = _G.XLAST.SESSION_MATCH_QUERY_FINDMATCH
	
	if xbox_live_settings_t["query"] then
		query = xbox_live_settings_t["query"]
	end
	
	mp_set_query(query)
	
	-- contexts
	
	local xbox_live_contexts_t = {}
	local game_type = NetworkGameType.STANDARD
	
	-- ranked or standard
	if xbox_live_settings_t["game_type"] then
		game_type = xbox_live_settings_t["game_type"]
	end
	
	mp_set_game_type(game_type)
	xbox_live_contexts_t[XboxContext.X_CONTEXT_GAME_TYPE] = game_type
	xbox_live_contexts_t[XboxContext.X_CONTEXT_GAME_MODE] = _G.XLAST.CONTEXT_GAME_MODE_VERSUS
	
	-- properties
	
	local xbox_live_properties_t = {}
	
	if query ~= _G.XLAST.SESSION_MATCH_QUERY_FINDMATCH then
		--[[ push properties onto table for our search ]]
		if xbox_live_settings_t["heroes_allowed"] then
			xbox_live_properties_t[#xbox_live_properties_t+1] = {
				["id"] = _G.XLAST.PROPERTY_GAMEATTRIB_HEROESALLOWED,
				["type"] = XboxDataType.XUSER_DATA_TYPE_INT32,
				["value"] = xbox_live_settings_t["heroes_allowed"]
				}
		end

		if xbox_live_settings_t["enemies_allowed"] then
			xbox_live_properties_t[#xbox_live_properties_t+1] = {
				["id"] = _G.XLAST.PROPERTY_GAMEATTRIB_ENEMIESALLOWED,
				["type"] = XboxDataType.XUSER_DATA_TYPE_INT32,
				["value"] = xbox_live_settings_t["enemies_allowed"]
				}
		end

		if xbox_live_settings_t["level_min"] then
			xbox_live_properties_t[#xbox_live_properties_t+1] = {
				["id"] = _G.XLAST.PROPERTY_GAMEATTRIB_LEVELMIN,
				["type"] = XboxDataType.XUSER_DATA_TYPE_INT32,
				["value"] = xbox_live_settings_t["level_min"]
				}
		end
		
		if xbox_live_settings_t["level_max"] then
			xbox_live_properties_t[#xbox_live_properties_t+1] = {
				["id"] = _G.XLAST.PROPERTY_GAMEATTRIB_LEVELMAX,
				["type"] = XboxDataType.XUSER_DATA_TYPE_INT32,
				["value"] = xbox_live_settings_t["level_max"]
				}
		end
		
		if xbox_live_settings_t["class_max"] then
			xbox_live_properties_t[#xbox_live_properties_t+1] = {
				["id"] = _G.XLAST.PROPERTY_GAMEATTRIB_CLASSMAX,
				["type"] = XboxDataType.XUSER_DATA_TYPE_INT32,
				["value"] = xbox_live_settings_t["class_max"]
				}
		end
		
		if xbox_live_settings_t["game_timer"] then
			xbox_live_properties_t[#xbox_live_properties_t+1] = {
				["id"] = _G.XLAST.PROPERTY_GAMEATTRIB_TIMELIMIT,
				["type"] = XboxDataType.XUSER_DATA_TYPE_INT32,
				["value"] = xbox_live_settings_t["game_timer"]
				}
		end
		--]]
	end
	
	mp_set_search_parameters(xbox_live_contexts_t, xbox_live_properties_t)
	
	-- for emulation on the pc
	local unused_ipaddress = "255.255.255.255"
	local unused_username = "NOT_NEEDED_FOR_XBOX"
	local unused_identity = "NOT_NEEDED_FOR_XBOX"
	
	mp_find_games(NetworkConnectionType.TCPIP, unused_ipaddress, unused_username, unused_identity, begin_func, enum_func)
end


local function JoinGame(join_func, game_id)
	LOG("XBOXLive.Join " .. tostring(join_func) .. " " .. tostring(game_id))
	assert(type(join_func) == "function")
	
	for i=2,4 do
		--assert(PlayerToUser(i) == -1)
		UnregisterPlayer(i)
	end
	
	local player = 1 -- player 1 does the game creation
	
	-- ranked or standard
	local game_type = NetworkGameType.STANDARD
	
	if xbox_live_settings_t["game_type"] then
		game_type = xbox_live_settings_t["game_type"]
	end
	
	SetXboxContext(player, XboxContext.X_CONTEXT_GAME_TYPE, game_type)
	SetXboxContext(player, XboxContext.X_CONTEXT_GAME_MODE, _G.XLAST.CONTEXT_GAME_MODE_VERSUS)
	
	mp_join_game(game_id, "NOT_NEEDED_FOR_XBOX", "NOT_NEEDED_FOR_XBOX", join_func)
end


local function Initialize(init_func)
	LOG("XBOXLive.Initialize " .. tostring(init_func))
	assert(type(init_func) == "function")
	
	mp_init(init_func, MessageHandler)
end


local function CreateGame(create_func)
	assert(type(create_func) == "function")
	if mp_in_game() then
		LOG("WARNING: still in mp game")
	end
	
	local player = 1 -- player 1 does the game creation
	local user = PlayerToUser(player)
	
	if not IsUserOnline(user) then
		create_func(false)
		return
	end
	
	-- ranked or standard
	local game_type = NetworkGameType.STANDARD
	
	if xbox_live_settings_t["game_type"] then
		game_type = xbox_live_settings_t["game_type"]
	end
	
	mp_set_game_type(game_type)
	
	if game_type == NetworkGameType.STANDARD and xbox_live_settings_t["private"] == 1 then
		mp_set_private(true)
	else
		mp_set_private(false)
	end
	
	SetXboxContext(player, XboxContext.X_CONTEXT_GAME_TYPE, game_type)
	SetXboxContext(player, XboxContext.X_CONTEXT_GAME_MODE, _G.XLAST.CONTEXT_GAME_MODE_VERSUS)
		
	local created = true
	local function create_f(ret)
		if ret ~= NetworkError.Success then
			created = false
		end
	end
		
	-- for emulation on the pc
	local game_name = string.rep("x", math.random(1,15))
	if Settings:ValueExists("mp_name") then
		game_name = Settings:Read("mp_name","")
	end	
	local unused_gamename = game_name .. "'s Game"
	local unused_username = "NOT_NEEDED_FOR_XBOX"
	local unused_identity = "NOT_NEEDED_FOR_XBOX"
	
	mp_create_game(NetworkConnectionType.TCPIP, unused_gamename, unused_username, unused_identity, 2, create_f)
	
	if not created then
		create_func(false)
		return
	end
	
	local result = true
	
	if result and xbox_live_settings_t["heroes_allowed"] then
		result = SetXboxProperty(player, _G.XLAST.PROPERTY_GAMEATTRIB_HEROESALLOWED, xbox_live_settings_t["heroes_allowed"])
	end
	
	if result and xbox_live_settings_t["enemies_allowed"] then
		result = SetXboxProperty(player, _G.XLAST.PROPERTY_GAMEATTRIB_ENEMIESALLOWED, xbox_live_settings_t["enemies_allowed"])
	end
	
	if result and xbox_live_settings_t["level_min"] then
		result = SetXboxProperty(player, _G.XLAST.PROPERTY_GAMEATTRIB_LEVELMIN, xbox_live_settings_t["level_min"])
	end
	
	if result and xbox_live_settings_t["level_max"] then
		result = SetXboxProperty(player, _G.XLAST.PROPERTY_GAMEATTRIB_LEVELMAX, xbox_live_settings_t["level_max"])
	end
	
	if result and xbox_live_settings_t["class_max"] then
		result = SetXboxProperty(player, _G.XLAST.PROPERTY_GAMEATTRIB_CLASSMAX, xbox_live_settings_t["class_max"])
	end
	
	if result and xbox_live_settings_t["game_timer"] then
		result = SetXboxProperty(player, _G.XLAST.PROPERTY_GAMEATTRIB_TIMELIMIT, xbox_live_settings_t["game_timer"])
	end
	
	create_func(result)
end


local function SubmitStats(players_t)

	--table.pretty_print(players_t)

	local game_type = NetworkGameType.STANDARD
	
	if xbox_live_settings_t["game_type"] then
		game_type = xbox_live_settings_t["game_type"]
	end
		
	if game_type == NetworkGameType.STANDARD and xbox_live_settings_t["hosting"] ~= true then
		return -- clients in standard matches dont submit anything
	end

	local view = _G.XLAST.STATS_VIEW_LB_BATTLES_STANDARD
	
	if game_type == NetworkGameType.RANKED then
		view = _G.XLAST.STATS_VIEW_LB_BATTLES_RANKED
	end
	
	for i,t in pairs(players_t) do
		local xuid = t.xuid
		
		LOG("writing stats for " .. tostring(xuid))
		
		if game_type == NetworkGameType.RANKED or xbox_live_settings_t["hosting"] == true then
			
			local leaderboard_stats_table = {
				{
					["id"] = XboxProperty.X_PROPERTY_RELATIVE_SCORE,
					["type"] = XboxDataType.XUSER_DATA_TYPE_INT32,
					["value"] = t.score
				},
			    {
			        ["id"] = XboxProperty.X_PROPERTY_SESSION_TEAM,
			        ["type"] = XboxDataType.XUSER_DATA_TYPE_INT32,
			        ["value"] = t.team
			    }
			}
			
			--table.pretty_print(leaderboard_stats_table)
			
			WriteStats(xuid, XboxView.X_STATS_VIEW_SKILL, leaderboard_stats_table)
		end
		
		local victory = 1
		if t.score == 0 then
			victory = 0
		end
		
		local stats_table = {
		    {
				["id"] = _G.XLAST.PROPERTY_PR_BATTLES,
				["type"] = XboxDataType.XUSER_DATA_TYPE_INT64,
				["value"] = 1
			},
		    {
		        ["id"] = _G.XLAST.PROPERTY_PR_VICTORIES,
		        ["type"] = XboxDataType.XUSER_DATA_TYPE_INT64,
		        ["value"] = victory -- loser => 0, winner => 1
		    }
		}
		
		--table.pretty_print(stats_table)
		
		WriteStats(xuid, view, stats_table)
	end
	
end


return {
	["GetProperty"] = GetProperty;
	["SetProperties"] = SetProperties;
	
	["Initialize"] = Initialize;
	["SetMessageHandler"] = SetMessageHandler;
	
	["CreateGame"] = CreateGame;
	["JoinGame"] = JoinGame;
	
	["Search"] = Search;
	["StopSearch"] = StopSearch;
	
	["SubmitStats"] = SubmitStats;
}
