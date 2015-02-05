
_G.GAME_VERSION = "BV Balance V1.0.2"
if _G.GLOBAL_FUNCTIONS.DemoMode() then
	_G.GAME_VERSION = "Demo"
end


function _G.DSOnly()
	return nil
end

function _G.WiiOnly()
	return nil
end

function _G.XBoxOnly()
	return nil
end

function _G.PCOnly(func, ...)
	return func(...)
end

function _G.NotDS(func, ...)
	return func(...)
end

function _G.SoundFunction(s, i)
	PlaySound(s)
end

--[[
--TEMP TEST FUNCTIONS to test XBOX stuff on PC
function _G.XBoxOnly(func, ...)
	return func(...)
end

function _G.HasAchievement()
	return false
end


function _G.AwardXAchievement(player_id,achievement_id)
	open_message_menu("Achievement Awarded",tostring(achievement_id))
	if not HasAchievement(player_id,achievement_id) then
		--AwardAchievement(player_id, achievement_id)
	end
end
--]]


_G.SAFE_VERTICAL = 50 --MIN 39
_G.SAFE_HORIZONTAL = 40 --MIN 52
_G.MAX_WIDESCREEN = 1366
_G.SCREENHEIGHT = 768
_G.COLLISION_DISTANCE = 50 -- this is the distance that 2 ships are away from each other before they collide
_G.WAIT_FOR_ARRIVAL = 1
_G.MIN_ENC_DIST = 150

_G.BEAMS_ON = true
_G.DEBUGS_ON = false
_G.CONNECTION_TYPE = NetworkConnectionType.TCPIPLAN

SetScreenSequencing(false)

local endedConversationCounter = 0;

function _G.RunQuestConversation(player, conversationID, callback)
	LOG("RunQuestConv: PC " .. conversationID)
	PlaySound("snd_comms")
	--local location = GameObjectManager:Construct(player:GetAttribute("curr_loc"))
	local location = player:GetAttribute("curr_loc_obj")
	local srcMenu
	if SCREENS.SolarSystemMenu:IsOpen() then
		srcMenu = SCREENS.SolarSystemMenu
		srcMenu.state = _G.STATE_MENU
		--SCREENS.SolarSystemMenu:GetWorld():StopMovement()
		--LOG("rconv StopMovement")
	else
		srcMenu = SCREENS.MapMenu
	end



	local function CallbackWrapper()
		--srcMenu:Open()
		--LOG("restart Movement")
		if callback ~= nil then
			callback()
		end
		LOG("End Conv")
		endedConversationCounter = endedConversationCounter + 1
		LOG("Number of Ended Conversations: "..endedConversationCounter)
		--Tutorialisation
		if (endedConversationCounter == 2) then
			_G.ShowTutorialFirstTime(2,_G.Hero)
		end

		-- TODO: Sent event to refresh the mapmenu
	end

	local conv_gender = "male"
	if _G.Hero:GetAttribute("male") == 0 then
		conv_gender = "female"
	end
	-- ** HACK **
	-- Japanese switches genders
	--[[
	if get_language() == 7 then
		if  conv_gender == "female" then
			conv_gender = "male"
		else
			conv_gender = "female"
		end
	end
	--]]
	-- ** END HACK **

	local myLocation = ""
	if location then
		if location.gateName then
			myLocation = location.gateName
		else
			myLocation = string.format("[%s_NAME]",location.classIDStr)
		end
	end


	LOG("Start Conv")
	open_conversation_menu(	"Assets\\Conversations\\" .. conversationID .. ".xml",
				player:GetAttribute("name"),
				player:GetAttribute("portrait").."_L",
				conv_gender,
				myLocation,
				"",
				"",
				CallbackWrapper,
				_G.Hero:GetX(),
				_G.Hero:GetY())

	--srcMenu:Close()
	--assert(location,"No Loc")
	--GameObjectManager:Destroy(location)
end

