
-------------------------------------------------------------------------------
--    UpdateTimer  -- only used for hacking mini game
-------------------------------------------------------------------------------
function UpdateTimer()
	local menu = SCREENS.GameMenu
	local world = menu.world
	if not world then
		return
	end
	
	if world:GetAttribute("timer") ~= 0 then

		local counter = world:GetAttribute("counter")		
		menu:set_text_raw("str_counter",tostring(counter))
		
		if world.last_counter == counter or ClassIDToString(world:GetClassID())~= "B002" then
			return
		end
		world.last_counter = counter
		if counter == 60 then
			PlaySound("snd_timesixty")
		elseif counter == 30 then
			PlaySound("snd_timethirty")
		elseif counter == 10 then
			PlaySound("snd_timeten")
		elseif counter < 6 then
			if counter == 5 then
				PlaySound("snd_timefive")
			elseif counter == 4 then
				PlaySound("snd_timefour")
			elseif counter == 3 then
				PlaySound("snd_timethree")
			elseif counter == 2 then
				PlaySound("snd_timetwo")
			elseif counter == 1 then
				PlaySound("snd_timeone")
			end
		end
	end
	
		
	
	return true
end


return UpdateTimer