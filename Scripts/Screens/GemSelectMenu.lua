use_safeglobals()


-- declare our menu
class "GemSelectMenu" (cGameMenu);

function GemSelectMenu:__init()
    super()
    
    -- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
    self:Initialize("Assets\\Screens\\GemSelectMenu.xml")

    -- set the world object
    
    
    
end

function GemSelectMenu:Open(grid,gemList)
	LOG("GemSelectMenu:Open("..tostring(grid))
	self.grid = grid
	
	self.gemList = nil
	if gemList and type(gemList)=="table" then
		self.gemList = gemList
	end

	return Menu.Open(self)	
end



function GemSelectMenu:OnOpen()
        
    local world = GameObjectManager:ConstructLocal('GSEL')
    
    
    self:SetWorld(world)
    
    local width = 80
    local height = 80
    local maxRow = 5
    
    local startX = 120
    local startY = 400
    
    local x = startX
    local y = startY
    local rowCount=1
	
    if not self.gemList then
    	self.gemList = {["GENG"]=1,["GCPU"]=1,["GINT"]=1,["GPSI"]=1,["GSHD"]=1,["GWEA"]=1,["GDMG"]=1,["GDM3"]=1,["GDM5"]=1,["GDMX"]=1,["GNIL"]=1,["GBLA"]=1}
    end
    for i,v in pairs(self.gemList) do
        LOG(i)
		local gem = GameObjectManager:ConstructLocal("Gems")
        gem = LoadGem(i,gem)
        --self.gemList[i] = gem
        world:AddChild(gem)
        gem:SetPos(x,y)
        x = x + width
        
        if rowCount >= maxRow then
            x=startX
            y = y - height
            rowCount = 1
        end
        rowCount = rowCount + 1
    end    
        
        
        
    return cGameMenu.OnOpen(self)
end

function GemSelectMenu:OnClose()
    
    local world = self:GetWorld()
    GameObjectManager:Destroy(world)
    
    
    return cGameMenu.OnClose(self)

end

function GemSelectMenu:OnButton(id, x, y)
    LOG("Closed")
    self:Close()
    
    return cGameMenu.MESSAGE_HANDLED
end

--function GemSelectMenu:OnClose()
--  LOG("Close GemSelectMenu")
--  return Menu.OnClose(self)
--end

-- return an instance of GemSelectMenu
return ExportSingleInstance("GemSelectMenu")
