function QuestRewardsMenu:PlatformVars()
	self.icon_height = 35
	self.icon_gem_width = 39
	self.icon_width = 35
	
	self.icon_filter = ""
	
	self.invClose = "QuestRewardsMenu"
end

function QuestRewardsMenu:LoadGraphics()
   
end

function QuestRewardsMenu:UnloadGraphics()
   
end

function QuestRewardsMenu:AdjustRewardText(i, j)
   local rewardStringTag = string.format("str_reward%d", j)
   local rewardStringX = self:get_widget_x(rewardStringTag)
   
   -- Nothing to do on PC or XBox
   
   return rewardStringX
end

function QuestRewardsMenu:OpenLevelUp(callback)
	SCREENS.LevelUpMenu:Open(callback,nil,self.invTab)
end