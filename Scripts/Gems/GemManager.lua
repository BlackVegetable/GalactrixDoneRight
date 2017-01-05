

function LoadGem(gem,o)	
	if not o then--if no object
		o = GameObjectManager:Construct("Gems")
	end
	
	--LOG(string.format("Loading %s",gem))
	
	o:SetAttribute("sound",GEMS[gem].sound)
	o:SetAttribute("particle",GEMS[gem].particle)
	o:SetAttribute("effect",GEMS[gem].effect)
	o:SetAttribute("amount",GEMS[gem].amount)
	o:SetAttribute("font",GEMS[gem].font)
	o:SetAttribute("matchable",GEMS[gem].matchable)
	o:SetAttribute("swapable",GEMS[gem].swapable)
	
	
	if GEMS[gem].beam then
		o:SetAttribute("beam",GEMS[gem].beam)
	end
	
	o.classIDStr = gem
	o.id = GEMS[gem].id
	if GEMS[gem].matchable == 1 then
		o.GemMatch = GEMS[gem].GemMatch
		o.GemMatch[o.id]=o.classIDStr
	else
		o.GemMatch = {}
	end
	
	local view = GameObjectViewManager:Construct("Sprite",GEMS[gem].sprite)
	o:SetView(view)
	view:StartAnimation("stand")
	--[[	
	if GEMS[gem].cargoview then
		local cargoview = GameObjectViewManager:Construct("Sprite",GEMS[gem].cargoview)
		cargoview:StartAnimation("stand")
		cargoview:SetSortingValue(-1)
		if GEMS[gem].scaleview then		
			cargoview:SetScale(GEMS[gem].scaleview)
		end
		o:AddOverlay("cargo", cargoview,0,0)		
	end
	
	if GEMS[o.classIDStr].CustMatch then
		o.CustMatch = GEMS[o.classIDStr].CustMatch
	end
	
	if GEMS[o.classIDStr].Transform then
		o.Transform = GEMS[o.classIDStr].Transform
	end
	]]--
	return o	
end

--No longer used
function ClearGem(gem)
	assert(gem,"No Gem")

	GameObjectManager:Destroy(gem)
end
