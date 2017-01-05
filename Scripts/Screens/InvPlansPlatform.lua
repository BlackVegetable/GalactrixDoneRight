--[[No longer used

function InvPlans:LoadGraphics()
   
end

function InvPlans:UnloadGraphics()
   
end

function InvPlans:PlatformVars()
   self.maxListValue = 9
   self.planNameWidth = 295
end

function InvPlans:HideTitle()
   -- nothing on PC, title shouldn't get hidden as cargo req'd icons are in a different location
end

function InvPlans:ActivateItem(i)
   self:set_alpha(string.format("item%d_frame", i), 1.0)
   self:set_alpha(string.format("item%d_gem_bg", i), 1.0)
   self:activate_widget(string.format("item%d_pad", i))
   self:activate_widget(string.format("item%d_name", i))
   self:activate_widget(string.format("item%d_type", i))
   --self:activate_widget(string.format("item%d_light", i))
   
   self:activate_widget(string.format("item%d_weap_bg", i))
   self:activate_widget(string.format("item%d_eng_bg", i))
   self:activate_widget(string.format("item%d_cpu_bg", i))
   self:activate_widget(string.format("item%d_weap_val", i))
   self:activate_widget(string.format("item%d_eng_val", i))
   self:activate_widget(string.format("item%d_cpu_val", i))
   
   self:activate_widget(string.format("item%d_gem_1", i))
   self:activate_widget(string.format("item%d_gem_2", i))
   self:activate_widget(string.format("item%d_gem_3", i))
   self:activate_widget(string.format("item%d_gem_4", i))
end

function InvPlans:HideItem(i)
   self:set_alpha(string.format("item%d_frame", i), 0.5)
   self:set_alpha(string.format("item%d_gem_bg", i), 0.5)
   self:deactivate_widget(string.format("item%d_pad", i))
   self:hide_widget(string.format("item%d_name", i))
   self:hide_widget(string.format("item%d_type", i))
   --self:hide_widget(string.format("item%d_light", i))
   
   self:hide_widget(string.format("item%d_weap_bg", i))
   self:hide_widget(string.format("item%d_eng_bg", i))
   self:hide_widget(string.format("item%d_cpu_bg", i))
   self:hide_widget(string.format("item%d_weap_val", i))
   self:hide_widget(string.format("item%d_eng_val", i))
   self:hide_widget(string.format("item%d_cpu_val", i))

   self:hide_widget(string.format("item%d_gem_1", i))
   self:hide_widget(string.format("item%d_gem_2", i))
   self:hide_widget(string.format("item%d_gem_3", i))
   self:hide_widget(string.format("item%d_gem_4", i))
end

--]]
