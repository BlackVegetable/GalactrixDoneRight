


function Star:SetStarMapView()

	local factionStanding = _G.Hero:GetFactionStanding(_G.STARS.AllStars[self.classIDStr].faction)
	local sprite1,sprite2--front animated sprite


	sprite2 = "ZST3"
	

	if not self.hacked then	
		local view = GameObjectViewManager:Construct("Sprite",sprite2)
		self.view = view
		self:SetView(view)
		view:StartAnimation("stand")
		view:SetSortingValue(3)	
		
	else
		if factionStanding < _G.STANDING_NEUTRAL then
			sprite2 = "ZST0"
			sprite1 = "ZSTE"
		elseif factionStanding > _G.STANDING_NEUTRAL then
			sprite2 = "ZST1"
			sprite1 = "ZSTF"
		else
			sprite2 = "ZST2"
			sprite1 = "ZSTN"
		end		

		local view = GameObjectViewManager:Construct("Sprite",sprite2)
		self.view = view
		self:SetView(view)
		view:StartAnimation("stand")
		view:SetSortingValue(3)
		
		local viewanim = GameObjectViewManager:Construct("Sprite",sprite1)
		viewanim:StartAnimation("stand")
		viewanim:SetSortingValue(2)	
		self:AddOverlay("anim", viewanim, 0, 0)		
		self.viewanim = viewanim			

	end	
		
		

	--self:AddQuestOverlay()	
end

function Star:InitNode()

	-- set the stars position
	local x = self:GetAttribute("xpos")
	local y = self:GetAttribute("ypos")
	
	self:SetStarMapView()

	self:SetPos(x,y)
	
	self:AddText()

end



