
-- world object - cursor for navigating star and system maps

class "SSEL" (GameObject)

SSEL.AttributeDescriptions = AttributeDescriptionList()

SSEL.AttributeDescriptions:AddAttribute('int', "x_vel", {default=0})
SSEL.AttributeDescriptions:AddAttribute('int', "y_vel", {default=0})
SSEL.AttributeDescriptions:AddAttribute('int', "max_x", {default=0})
SSEL.AttributeDescriptions:AddAttribute('int', "max_y", {default=0})

function SSEL:__init()
	super("SSEL")
	self:InitAttributes()
end

function SSEL:InitCursor(x,y, starmap)
	local view = GameObjectViewManager:Construct("Sprite", "ZGPC")
	self:SetView(view)
	view:StartAnimation("stand")
	view:SetSortingValue(-200)
	if x and y then
		self:SetPos(x, y)
	else
		self:SetPos(512, 384)
	end
	if starmap then
		self:SetAttribute("max_x", 2048)
		self:SetAttribute("max_y", 2048)
	else
		local maxx = GetScreenWidth() + (1366-GetScreenWidth())/2
		self:SetAttribute("max_x", maxx)
		self:SetAttribute("max_y", 768)
	end
	self:SetAttribute("x_vel", 0)
	self:SetAttribute("y_vel", 0)
	self:SetCursorInteract(false)
end

function SSEL:AccelerateCursor(x,y)
	
	self:SetAttribute("x_vel", x)
	self:SetAttribute("y_vel", y)
end

function SSEL:MoveCursor()
	local x_vel = self:GetAttribute("x_vel")
	local y_vel = self:GetAttribute("y_vel")
	
	
	local x = math.max(0, math.min(self:GetX() + x_vel, self:GetAttribute("max_x")))
	local y = math.max(0, math.min(self:GetY() + y_vel, self:GetAttribute("max_y")))

	if x_vel > -5 and x_vel < 5 then
		self:SetAttribute("x_vel", 0)
	end

	if y_vel > -5 and y_vel < 5 then
		self:SetAttribute("y_vel", 0)
	end
	
	self:SetPos(x, y)
end

return ExportClass("SSEL")