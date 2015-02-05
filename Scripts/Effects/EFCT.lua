-- EFCT
--	this class defines the basic behaviour of the EFCT objects
--	there is one instance of

use_safeglobals()



class "EFCT" (GameObject)

-- BEGIN ATTRIBUTE DESCRIPTIONS
EFCT.AttributeDescriptions = AttributeDescriptionList()
EFCT.AttributeDescriptions:AddAttribute('int',			'counter',			{default=1} )
EFCT.AttributeDescriptions:AddAttribute('string',     'name',           {default=""} )
EFCT.AttributeDescriptions:AddAttribute('string',     'desc',           {default=""} )
EFCT.AttributeDescriptions:AddAttribute('GameObject',	'player',			{} )
EFCT.AttributeDescriptions:AddAttribute('string',		'icon',				{default=""} )
EFCT.AttributeDescriptions:AddAttribute('string',		'sound',				{default="snd_shields"} )
EFCT.AttributeDescriptions:AddAttribute('string', 		'item',				{})


--dofile("Assets/Scripts/Effects/EFCTPlatform.lua")

function EFCT:__init()
	super("EFCT")

	-- we have to init the attributes if we want to set them in the ctor
	self:InitAttributes()

	--dont count down counter on casting turn.
	--self.skip_counter = true
	self.casting_turn = SCREENS.GameMenu.world.turn_count
end


function EFCT:InitEffect()

end



function EFCT:ShowInfo(x,y,counter)
	LoadAssetGroup("AssetsItems")
	local item = ITEMS[self:GetAttribute("item")]
	--self:GetAttribute("counter")
	local colors = "121/192/255"
	local playerID = self:GetAttribute("player"):GetAttribute("player_id")
	if playerID == 2 then
		colors = "255/121/121"--red = p2
	end
	--BEGIN_STRIP_DS
	local function ShowInfo()

		open_custompopup_menu_raw( string.format("//TITLE/2/font_system//ICON/0/30/64/64//TEXT/70/51/font_info_white//HELP/8/100/font_info_gray//BACKGROUND/img_black//BORDER/0/%s//",colors),
			string.format("//%s//%s//%s//%s//", translate_text(self:GetAttribute("name")),item.icon,substitute(translate_text("[X_TURNS]"),self:GetAttribute("counter")),translate_text(self:GetAttribute("desc"))),
				x,y,0,200)
	end
	_G.NotDS(ShowInfo)
	--END_STRIP_DS

	local function ShowInfoDS()
		 local icon = string.format("%s_L", item.icon)

		 open_custompopup_menu_raw( string.format("//TITLE/8/font_heading//ICON/8/30/64/64//TEXT/111/52/font_info_red//TEXTBLOCK/8/96/238/92/font_info_gray/left/top//BACKGROUND/img_black//BORDER/0/%s//",colors),
			 string.format("//%s//%s//%s//%s//", translate_text(self:GetAttribute("name")),icon,substitute(translate_text("[X_TURNS]"),self:GetAttribute("counter")),translate_text(self:GetAttribute("desc"))),
				 x,y,0,200)
	end
	_G.DSOnly(ShowInfoDS)
end



function EFCT:Counter()
	local counter = self:GetAttribute("counter")
	local myHero = self:GetAttribute("player")
	local myHero_id = myHero:GetAttribute("player_id")
	local eName = self:GetAttribute("name")
	local isStunned = false
	if myHero_id == 1 then
		if _G.PLAYER_1_STUN == true then
			isStunned = true
		end
	elseif myHero_id == 2 then
		if _G.PLAYER_2_STUN == true then
			isStunned = true
		end
	end

	if SCREENS.GameMenu.world.turn_count == self.casting_turn then
		--self.skip_counter = nil
		return counter
	end
	if 	isStunned == true then
		if eName == "[FT03_NAME]" then -- Shield Drain
			counter =  counter + 1
		elseif eName == "[FD07_NAME]" then -- Mass Driver
			counter = counter + 1
		elseif eName == "[FD02_NAME]" then -- Cloaking
			counter = counter + 1
		elseif eName == "[FD08_NAME]" then -- Targeting
			counter = counter + 1
		elseif eName == "[FE01_NAME]" then -- Auxiliary Plating
			counter = counter + 1
		elseif eName == "[FE02_NAME]" then -- Boost
			counter = counter + 1
		elseif eName == "[FE03_NAME]" then -- Disruptor
			counter = counter + 1
		elseif eName == "[FE04_NAME]" then -- Overclocking
			counter = counter + 1
		elseif eName == "[FE05_NAME]" then -- Solar Flare
			counter = counter + 1
		elseif eName == "[FE06_NAME]" then -- Sub-Light
			counter = counter + 1
		elseif eName == "[FE07_NAME]" then -- Weapon Overload
			counter = counter + 1
		elseif eName == "[FG04_NAME]" then -- Linear Grav-Flux
			counter = counter + 1
		elseif eName == "[FS01_NAME]" then -- Confusion
			counter = counter + 1
		elseif eName == "[FS02_NAME]" then -- Nova
			counter = counter + 1
		elseif eName == "[FT02_NAME]" then -- CPU Drain
			counter = counter + 1
		elseif eName == "[FT05_NAME]" then -- Time Loop
			counter = counter + 1
		elseif eName == "[FT07_NAME]" then -- Weapon Drain
			counter = counter + 1
		elseif eName == "[FC02_NAME]" then -- Booby-Trapped
			counter = counter + 1
		elseif eName == "[FC03_NAME]" then -- R.E. Probe
			coutner = counter + 1
		elseif eName == "[FC05_NAME]" then -- Overheated
			counter = counter + 1
		elseif eName == "[FC07_NAME]" then -- Manual Control
			counter = counter + 1
		elseif eName == "[FC10_NAME]" then -- Critical Trajectory
			counter = counter + 1
		end
	elseif eName == "[FC05_NAME]" then
		if myHero:GetAttribute("player_id") == 1 then
			_G.PLAYER_1_COOLANT = _G.PLAYER_1_COOLANT + 1
		elseif myHero:GetAttribute("player_id") == 2 then
			_G.PLAYER_2_COOLANT = _G.PLAYER_2_COOLANT + 1
		end
	end
	counter = counter-1

	-- Set Invincibility Shield Reduction --
	if eName == "[FC13_NAME]" then -- Invincibility
		if counter == 0 then
			myHero:SetAttribute("shield", 0)
		end
	end

	self:SetAttribute("counter",counter)
	return counter
end


function EFCT:PreDestroy()
	local parent = self:GetParent()
	parent:EraseAttribute("Effects",self)
end

function EFCT:GetGravity(battleGround,gravity)

	return gravity
end


function EFCT:MutateEventReceiveEnergy(event)
end

function EFCT:MutateEventShipDamage(event)
end

function EFCT:MutateEventNewTurn(event)
end


function EFCT:DeductEnergy(player,effect,amt)

	if _G.ALLY_STUNNED == false then
		self:AwardEnergy(player,effect,-amt)
	end
end

function EFCT:AwardEnergy(player, effect, amt,no_beam)
	local world = SCREENS.GameMenu.world
	local e

	if amt == 0 then
		--return
	end

	if amt > 0 then
		if player:HasAttribute(string.format("%s_max", effect)) then
			amt = math.min(amt, player:GetAttribute(string.format("%s_max", effect)) - player:GetAttribute(effect))
		end
		e = GameEventManager:Construct("ReceiveEnergy")
		e:SetAttribute("effect", effect)
		e:SetAttribute("mutate", 0)
		e:SetAttribute("amount", amt)
		player:OnEventReceiveEnergy(e)
	elseif amt < 0 then--negative amount
		e = GameEventManager:Construct("LoseEnergy")
		e:SetAttribute("effect", effect)
		e:SetAttribute("mutate", 0)
		e:SetAttribute("amount", math.min(-amt, player:GetAttribute(effect)))
		player:OnEventLoseEnergy(e)
	end
	PlaySound(self:GetAttribute("sound"))
	if not no_beam then
		local player_id = player:GetAttribute("player_id")
		world:DrainEffect("Effect",player_id,effect,player_id)
	end
	--GameEventManager:Send(e, player)--Changed to function call for speed.
end

return ExportClass("EFCT")
