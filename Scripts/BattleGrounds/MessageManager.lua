
-- Handles The Displaying of In-Game Messages


--function _G.ShowMessage(baseObj,msg,font,x,y,float)
--    local msgObj = GameObjectManager:Construct('GMSG')
--    baseObj:AddChild(msgObj)
--	msgObj:ShowMessage(msg,font,x,y,float)
--end

function _G.EncounterMessage(baseObj,msg,x,y)
	local msgObj = GameObjectManager:Construct('GMSG')
	baseObj:AddChild(msgObj)
	msgObj:EncounterMessage(msg,x,y)
end

function _G.BigMessage(baseObj,msg,x,y)

	_G.ShowMessage(baseObj,msg,"font_message",x,y,true)	
	
end

function _G.DamageMessage(baseObj,msg,x,y)
	_G.ShowMessage(baseObj,msg,"font_numbers_red",x,y)
end

function _G.ShieldMessage(baseObj,msg,x,y)
	_G.ShowMessage(baseObj,msg,"font_numbers_blue",x,y)

end





function _G.ShowMessage(baseObj,msg,font,x,y,float)
	local msgObj
	local val
	if type(msg)== "number" then
		val = msg
		if baseObj.messageList[x] then 
			msgObj = baseObj.messageList[x]
			val = msgObj.val + val
		end
		local sign = ""
		if val > 0 then
			sign = "+"
		end
		msg = string.format("%s%d",sign,val)
	end
	
	if msgObj then
		msgObj:UpdateMessage(msg)
	else	
		msgObj = GameObjectManager:ConstructLocal('GMSG')
		baseObj:AddChild(msgObj)
		msgObj:ShowMessage(msg,font,x,y,true,acc)
		
	end	
	if val then
		msgObj.val = val
		baseObj.messageList[x]= msgObj
	end	
	
	
end
