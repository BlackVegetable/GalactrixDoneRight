--------------------------------------------------------------------------------
--  ________   __ _____             _         _                     _             
-- |  ____\ \ / // ____|           | |       (_)                   | |            
-- | |__   \ V /| |      ___  _ __ | |_  __ _ _ _ __   ___ _ __    | |_   _  __ _ 
-- |  __|   > < | |     / _ \| '_ \| __|/ _` | | '_ \ / _ \ '__|   | | | | |/ _` |
-- | |     / . \| |____| (_) | | | | |_| (_| | | | | |  __/ |    _ | | |_| | (_| |
-- |_|    /_/ \_\\_____|\___/|_| |_|\__|\__,_|_|_| |_|\___|_|   (_)|_|\__,_|\__,_|
--                                                                                
--                                                                                
--
--------------------------------------------------------------------------------
-- Originally created on 05/21/2008 by Steve Fawkner
--
-- Copyright 2008, Infinite Interactive Pty. Ltd., all rights reserved.
--------------------------------------------------------------------------------

use_safeglobals()

local KEY_X   	= 0
local KEY_Y 	= 1
local KEY_XY 	= 2
local KEY_SCALE = 3
local KEY_ROT 	= 6
local KEY_ALPHA = 7
local KEY_VIS 	= 8
local KEY_ALL 	= 9
local KEY_COLOR = 10
local KEY_DISTORT_BOUND_WIDTH = 11
local KEY_DISTORT_BOUND_HEIGHT = 12
local KEY_DISTORT_RING_RADIUS = 13
local KEY_DISTORT_RING_WIDTH = 14
local KEY_DISTORT_STRENGTH = 15

local DISCRETE  = 0
local LINEAR 	= 1
local BOUNCE 	= 2
local SMOOTH 	= 3
local PUNCH_IN 	= 4
local PUNCH_OUT	= 5



---------------------------------------------------------------------------------
--
--   CreateContainer(duration, event_id, img_background, background_fade_time)
--
--      Creates a container to which you can add objects, keyframes, pfx & sfx
--
local function CreateContainer(duration, event_id, img_background, background_fade_time)
	return fxc_create_container(duration, event_id)
end

---------------------------------------------------------------------------------
--
--   DuplicateContainer(container)
--
--      Makes a complete copy of a container
--
local function DuplicateContainer(container)
	return fxc_duplicate_container(container)
end

---------------------------------------------------------------------------------
--
--   Stop(container,sendEvents)
--
--      Stops an effect from playing
--
local function  Stop(container,sendEvents)
	fxc_stop(container, sendEvents)
end

---------------------------------------------------------------------------------
--
--   StopAll(sendEvents)
--
--      Stops all effects from playing
--
local function  StopAll()
	fxc_stop_all()
end

	
---------------------------------------------------------------------------------
--
--   Start(world, container,x,y)
--
--      Start an effect playing
--
local function  Start(world, container,x,y)
	fxc_start(world, container,x,y)
end

---------------------------------------------------------------------------------
--
--   AddRumble(container,time,user,amount,duration)
--
--      Add a rumble to the gamepad
--
local function  AddRumble(container,time,user,amount,duration)
	fxc_add_rumble(container,time,user,amount,duration)
end

---------------------------------------------------------------------------------
--
--   AddKey(container,element,time,key_type,data1,data2,data3,data4,data5,data6,data7,data8)
--
--      Add a key to an element in a container
--
local function  AddKey(container,element,time,key_type,data1,data2,data3,data4,data5,data6,data7,data8)

	if (key_type == KEY_X) then
		if not data1 then data1 = 0 end
		if not data2 then data2 = LINEAR end
		fxc_add_key(container,element,time,key_type, data1, 0, 0, 0, 0, data2)				
	elseif (key_type == KEY_Y) then
		if not data1 then data1 = 0 end
		if not data2 then data2 = LINEAR end
		fxc_add_key(container,element,time,key_type, 0, data1, 0, 0, 0, data2)			
	elseif (key_type == KEY_XY) then
		if not data1 then data1 = 0 end
		if not data2 then data2 = 0 end
		if not data3 then data3 = LINEAR end
		fxc_add_key(container,element,time,key_type, data1, data2, 0, 0, 0, data3)	
	elseif (key_type == KEY_SCALE) then
		if not data1 then data1 = 0 end
		if not data2 then data2 = LINEAR end
		fxc_add_key(container,element,time,key_type, 0, 0, data1, 0, 0, data2)	
	elseif (key_type == KEY_HSCALE) then
		if not data1 then data1 = 0 end
		if not data2 then data2 = LINEAR end
		fxc_add_key(container,element,time,key_type, 0, 0, data1, 0, 0, data2)	
	elseif (key_type == KEY_VSCALE) then
		if not data1 then data1 = 0 end
		if not data2 then data2 = LINEAR end
		fxc_add_key(container,element,time,key_type, 0, 0, data1, 0, 0, data2)	
	elseif (key_type == KEY_ROT) then
		if not data1 then data1 = 0 end
		if not data2 then data2 = LINEAR end
		fxc_add_key(container,element,time,key_type, 0, 0, 0, data1, 0, data2)	
	elseif (key_type == KEY_ALPHA) then
		if not data1 then data1 = 0 end
		if not data2 then data2 = LINEAR end
		fxc_add_key(container,element,time,key_type, 0, 0, 0,0,  data1, data2)	
	elseif (key_type == KEY_VIS) then
		if not data1 then data1 = 1 end
		fxc_add_key_vis(container,element,time, data1)
		
	elseif (key_type == KEY_ALL) then
		if not data1 then data1 = 0 end
		if not data2 then data2 = 0 end
		if not data3 then data3 = 0 end
		if not data5 then data5 = 0 end
		if not data6 then data6 = 0 end
		if not data7 then data7 = 1 end
		if not data8 then data8 = LINEAR end
		fxc_add_key(container,element,time,key_type, data1, data2, data3, data5, data6, data8)
		fxc_add_key_vis(container,element,time, data7)
	end
	
end

local function AddSpecificKey(container, element, time, key_type, key_value, interp_type)
	if( key_type == KEY_VIS ) then
		fxc_add_key_vis(container,element,time, key_value)
	elseif( key_type == KEY_X
		or key_type == KEY_Y
	) then
		fxc_add_integer_key(container, element, time, key_type, key_value, interp_type)
	elseif( key_type == KEY_SCALE
		or key_type == KEY_ROT
		or key_type == KEY_ALPHA
		or key_type == KEY_DISTORT_BOUND_WIDTH
		or key_type == KEY_DISTORT_BOUND_HEIGHT
		or key_type == KEY_DISTORT_RING_RADIUS
		or key_type == KEY_DISTORT_RING_WIDTH
		or key_type == KEY_DISTORT_STRENGTH
	) then
		fxc_add_float_key(container, element, time, key_type, key_value, interp_type)
	else
		LOG("FX.Error: cannot create specific key of type " .. tostring(key_type))
	end
end

---------------------------------------------------------------------------------
--
--   AddText(container,string,x,y,hsc,vsc,rot,alpha,vis, sort,flip)
--
--      Add text to a container
--
local function  AddText(container,font_tag,string,x,y,hsc,vsc,rot,alpha,vis, sort,flip)
	if not sort then sort = 0 end
	if not flip then flip = 0 else flip = 1 end
	return fxc_add_text(container,font_tag,string, x, y, hsc, rot, alpha, sort, flip)
end

---------------------------------------------------------------------------------
--
--   AddImage(container,img_tag,x,y,hsc,vsc,rot,alpha,vis, sort,flip)
--
--      Add an image to a container
--
local function  AddImage(container,img_tag,x,y,hsc,vsc,rot,alpha,vis, sort,flip)
	if not sort then sort = 0 end
	if not flip then flip = 0 else flip = 1 end
	return fxc_add_image(container,img_tag, x, y, hsc, rot, alpha, sort, flip)
end

---------------------------------------------------------------------------------
--
--   AddSprite(container,sprite_tag,x,y,hsc,vsc,rot,alpha,vis, sort,flip)
--
--      Add a sprite to a container
--
local function  AddSprite(container,sprite_tag,anim_tag,x,y,hsc,vsc,rot,alpha,vis, sort,flip)
	if not sort then sort = 0 end
	if not flip then flip = 0 else flip = 1 end
	return fxc_add_sprite(container,sprite_tag,anim_tag, x, y, hsc, rot, alpha, sort, flip)
end

---------------------------------------------------------------------------------
--
--   AddDistortion(container,x,y,scale)
--
--      Add a distortion effect to  a container
--
local function  AddDistortion(container,x,y,scale)
	return fxc_add_distortion(container,x,y,scale)
end

local function  AddRingDistortion(container, x, y, scale, bound_width, bound_height, ring_radius, ring_width, strength)
	return fxc_add_ring_distortion(container, x, y, scale, bound_width, bound_height, ring_radius, ring_width, strength)
end

---------------------------------------------------------------------------------
--
--   AddSound(container,time,sound_tag)
--
--      Add a timed sound to a container
--
local function  AddSound(container,time,sound_tag)
	fxc_add_sound(container,time,sound_tag)
end

---------------------------------------------------------------------------------
--
--   AddParticles(container,time,pfx_tag,x,y
--
--      Add a timed particle effect to a container
--
local function  AddParticles(container,element,time,pfx_tag,x,y)
	fxc_add_particles(container,element,time,pfx_tag,x,y)
end

---------------------------------------------------------------------------------
--
--   ChangeText(container,elem_idx, str)
--   ChangeFont(container,elem_idx, fnt)
--   ChangeImage(container,elem_idx, img)
--   ChangeSprite(container,elem_idx, spr)
--   ChangeAnimation(container,elem_idx, anm)
--   ChangeSound(container,snd_idx, snd, time)
--   ChangeParticles(container,pfx_idx, pfx, time, x, y, element)
--
--      Change data in an element
--		Unfortunately, you must know the index of the element you are about to change
-- 		In pfx & sfx functions you may pass in "nil" for things you do not wish to change
--
local function  ChangeText(container,elem_idx, str)
	fxc_change_text(container,elem_idx, translate_text(str))
end
local function  ChangeFont(container,elem_idx, fnt)
	fxc_change_font(container,elem_idx, fnt)
end
local function  ChangeImage(container,elem_idx, img)
	fxc_change_image(container,elem_idx, img)
end
local function  ChangeSprite(container,elem_idx, spr)
	fxc_change_sprite(container,elem_idx, spr)
end
local function  ChangeAnimation(container,elem_idx, anm)
	fxc_change_animation(container,elem_idx, anm)
end
local function  ChangeDistortion(container,elem_idx)
	fxc_change_distortion(container,elem_idx)
end
local function  ChangeSound(container,snd_idx, snd, time)
	fxc_change_sounds(container,snd_idx, snd, time)
end
local function  ChangeParticles(container,pfx_idx, pfx, time, x, y, element)
	fxc_change_particles(container,pfx_idx, pfx, time, x, y, element)
end

---------------------------------------------------------------------------------
--
--   RemoveKeys(element)
--
--      Remove keys from a container
--
local function  RemoveKeys(element)
	-- Needs to be restructured to pass container
	-- fxc_remove_keys(container, element)
end

---------------------------------------------------------------------------------
--
--   IsActive(container)
--
--      Is a container active??
--
local function  IsActive(container)
	return fxc_is_active(container)
end



-----------------------------------------------------------------------------------

local FXContainer = 
{
	KEY_X   	= KEY_X,
	KEY_Y 		= KEY_Y,
	KEY_XY 		= KEY_XY,
	KEY_SCALE 	= KEY_SCALE,
	KEY_HSCALE 	= KEY_HSCALE,
	KEY_VSCALE 	= KEY_VSCALE,
	KEY_ROT 	= KEY_ROT,
	KEY_ALPHA 	= KEY_ALPHA,
	KEY_VIS 	= KEY_VIS,
	KEY_ALL 	= KEY_ALL,
	KEY_COLOR 	= KEY_COLOR,
	KEY_DISTORT_BOUND_WIDTH = KEY_DISTORT_BOUND_WIDTH,
	KEY_DISTORT_BOUND_HEIGHT = KEY_DISTORT_BOUND_HEIGHT,
	KEY_DISTORT_RING_RADIUS = KEY_DISTORT_RING_RADIUS,
	KEY_DISTORT_RING_WIDTH = KEY_DISTORT_RING_WIDTH,
	KEY_DISTORT_STRENGTH = KEY_DISTORT_STRENGTH,
	
	DISCRETE   	= DISCRETE,
	LINEAR 		= LINEAR,
	BOUNCE 		= BOUNCE,
	SMOOTH 		= SMOOTH,
	PUNCH_IN 	= PUNCH_IN,
	PUNCH_OUT	= PUNCH_OUT,
	
	CreateContainer 	= CreateContainer,
	DuplicateContainer  = DuplicateContainer,
	
	Stop 				= Stop,
	StopAll  			= StopAll,
	Start 				= Start,
	AddText 			= AddText,
	AddImage 			= AddImage,
	AddSprite 			= AddSprite,
	AddDistortion		= AddDistortion,
	AddRingDistortion	= AddRingDistortion,
	AddKey 				= AddKey,
	AddSpecificKey		= AddSpecificKey,
	AddSound 			= AddSound,
	AddParticles 		= AddParticles,
	AddRumble			= AddRumble,
	
	ChangeText 			= ChangeText,
	ChangeFont 			= ChangeFont,
	ChangeImage 		= ChangeImage,
	ChangeSprite 		= ChangeSprite,
	ChangeAnimation	    = ChangeAnimation,
	ChangeDistortion	= ChangeDistortion,
	ChangeSound		    = ChangeSound,
	ChangeParticles	    = ChangeParticles,
	RemoveKeys			= RemoveKeys,
	
	IsActive			= IsActive,
	
}

return FXContainer

--------------------------------------------------------------------------------
-- FXContainer.lua - End of file
--------------------------------------------------------------------------------
