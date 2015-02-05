-- SpawnGems
--	this event is sent from the battleground to itself
--	it causes the gems to be spawned

use_safeglobals()

class "UpdateMPResults" (GameEvent)

UpdateMPResults.AttributeDescriptions = AttributeDescriptionList()
UpdateMPResults.AttributeDescriptions:AddAttribute('int', 'rematch', {default=0,serialize= 1})
UpdateMPResults.AttributeDescriptions:AddAttribute('int', 'rematch_ready', {default=0,serialize= 1})
UpdateMPResults.AttributeDescriptions:AddAttribute('int', 'quit', {default=0,serialize= 1})


function UpdateMPResults:__init()
	super("UpdateMPResults")
	self:SetSendToSelf(false)			  
end


function UpdateMPResults:do_OnReceive()

	if _G.is_open("MPResultsMenu") then
		local world = _G.SCREENS.GameMenu.world		
		if SCREENS.MPResultsMenu.clicked == false then--No option already selected.
			if self:GetAttribute("quit")==1 then
				if _G.is_open("MPResultsMenu") then
					SCREENS.MPResultsMenu:set_text("str_message","[OPPONENT_LEFT]")
					--SCREENS.MPResultsMenu:hide_widget("butt_rematch")
					--SCREENS.MPResultsMenu:hide_widget("check_rematch")
					--SCREENS.MPResultsMenu:activate_widget("butt_return")
					SCREENS.MPResultsMenu:DisableRematch()
				end
			elseif self:GetAttribute("rematch") == 1 then--host ready - check client
				if not _G.SCREENS.MPResultsMenu.rematch then
					return
				end
				--if client ready - send to everyone.
				self:SetSendToSelf(true)
				self:SetAttribute("rematch",2)
				GameEventManager:Send(self)--send to all
				SCREENS.MPResultsMenu:deactivate_widget("check_rematch")				
			
			elseif self:GetAttribute("rematch") == 2 then	
				LOG("rematch 2 "..tostring(mp_is_host()))
				SCREENS.MPResultsMenu.clicked = true
				--SCREENS.MPResultsMenu:deactivate_widget("check_rematch")		
				--Show loading menu while restarting
				SCREENS.CustomLoadingMenu:Open(nil, _G.DoNothing, nil, "GameMenu", nil, 40000, true)-- 0->40000 loading screen closed by CreateGemsEvent									
				SCREENS.MPResultsMenu:Close()
				Sound.StopMusic();
				SCREENS.GameMenu:ShowWidgets()
				_G.XBoxOnly(_G.XBOXLive.SetMessageHandler, _G.battle_handler)
				SCREENS.GameMenu.world:RestartBattle()
				mp_start_game(_G.DoNothing)			
			elseif self:GetAttribute("rematch_ready") == 0 then
				SCREENS.MPResultsMenu.rematch = false
				SCREENS.MPResultsMenu:deactivate_widget("butt_rematch")
				SCREENS.MPResultsMenu:activate_widget("butt_return")
			else
				SCREENS.MPResultsMenu.rematch = true
				SCREENS.MPResultsMenu:activate_widget("butt_rematch")
				SCREENS.MPResultsMenu:activate_widget("butt_return")
			end
		end
	end

end

return ExportClass("UpdateMPResults")
