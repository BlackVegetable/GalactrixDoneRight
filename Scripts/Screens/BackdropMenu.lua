
-- declare our menu
class "BackdropMenu" (Menu);


-- Constants
local ADD_YAW_INIT		= 0.001;
local ADD_PITCH_INIT	= 0.0005;
local ADD_ROLL_INIT		= 0.0005;

local ADD_YAW			= 0.0001;
local ADD_PITCH			= 0.0001;
local ADD_ROLL			= 0.0001;

local ADD_YAW_CHANCE	= 0.01;	
local ADD_PITCH_CHANCE	= 0.02;
local ADD_ROLL_CHANCE	= 0.02;

local ADD_YAW_MAX		= 0.001;
local ADD_PITCH_MAX		= 0.001;
local ADD_ROLL_MAX		= 0.001;


function BackdropMenu:__init()
	super()
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\BackdropMenu.xml")
	
	-- the menu has its own random number generator
	self.dice = cDice()
end


-- normally we'd put special widget setup code here but man is a splash screen ever basic!
function BackdropMenu:OnOpen()
	LOG("Backdrop screen opened");

	
	-- Set and enable skybox
	self.yaw				= 3.13;
	self.pitch				= 3.8;
	self.roll				= -3.13;
	self.add_yaw			= ADD_YAW_INIT;
	self.add_pitch			= ADD_PITCH_INIT;
	self.add_roll			= ADD_ROLL_INIT;

	local skybox = cSkyBox
	--skybox:Load( "Assets\\Models\\SkyBox"..tostring(math.random(0,3))..".x" );
	skybox:Load( "Assets\\Models\\SkyBox0.x" );
	skybox:SetView(self.yaw, self.pitch, self.roll);
	skybox:SetActive(true);
	
	return Menu.OnOpen(self)
end

function BackdropMenu:OnClose()
	LOG("Backdrop screen closed");

	-- disable skybox
	local skybox = cSkyBox --.GetInstance()
	skybox:SetActive(false);

	return Menu.OnClose(self)
end


function BackdropMenu:OnDraw(dwTime) 
--[[
	-- if 1 then return cMenu.MESSAGE_HANDLED end
	
	-- Update the additions
	-- FIXME: use dwTime to make this frame rate independant
	-- FIXME: we should be limiting the range of yaw etc to their valid ranges, wrapping as necessary
	
	if (self.dice:Fraction() <= ADD_YAW_CHANCE) then
		local delta			= -ADD_YAW + 2.0 * self.dice:Fraction() * ADD_YAW
		self.add_yaw		= self.add_yaw + delta
		self.add_yaw		= ForceRange(self.add_yaw, -ADD_YAW_MAX, ADD_YAW_MAX)
	end
	if (self.dice:Fraction() <= ADD_PITCH_CHANCE) then
		local delta			= -ADD_PITCH + 2.0 * self.dice:Fraction()*ADD_PITCH
		self.add_pitch		= self.add_pitch + delta
		self.add_pitch		= ForceRange(self.add_pitch, -ADD_PITCH_MAX, ADD_PITCH_MAX);
	end
	if (self.dice:Fraction() <= ADD_ROLL_CHANCE) then
		local delta			= -ADD_ROLL + 2.0 * self.dice:Fraction()*ADD_ROLL
		self.add_roll		= self.add_roll + delta
		self.add_roll		= ForceRange(self.add_roll, -ADD_ROLL_MAX, ADD_ROLL_MAX);
	end

	-- And change the values
--	self.yaw				= self.yaw		+ math.rad(0.02);
--	self.pitch				= self.pitch	+ math.rad(0.06);
--	self.roll				= self.roll		+ self.add_roll;

	local skybox = cSkyBox -- .GetInstance()
	--skybox:SetView(-math.rad(15), self.pitch, self.roll)	
	skybox:SetView(math.rad(-15), math.rad(0.06), 0)	

--]]	
	
 if (self.dice:Fraction() <= ADD_YAW_CHANCE) then
	local delta			= -ADD_YAW + 2.0 * self.dice:Fraction() * ADD_YAW
	self.add_yaw		= self.add_yaw + delta
	self.add_yaw		= ForceRange(self.add_yaw, -ADD_YAW_MAX, ADD_YAW_MAX)
end
if (self.dice:Fraction() <= ADD_PITCH_CHANCE) then
	local delta			= -ADD_PITCH + 2.0 * self.dice:Fraction()*ADD_PITCH
	self.add_pitch		= self.add_pitch + delta
	self.add_pitch		= ForceRange(self.add_pitch, -ADD_PITCH_MAX, ADD_PITCH_MAX);
end
if (self.dice:Fraction() <= ADD_ROLL_CHANCE) then
	local delta			= -ADD_ROLL + 2.0 * self.dice:Fraction()*ADD_ROLL
	self.add_roll		= self.add_roll + delta
	self.add_roll		= ForceRange(self.add_roll, -ADD_ROLL_MAX, ADD_ROLL_MAX);
end

-- And change the values
--self.yaw				= self.yaw		+ self.add_yaw;
--self.pitch				= self.pitch	+ self.add_pitch;
--self.roll				= self.roll		+ self.add_roll;

self.yaw				= self.yaw		+ math.rad(0.03);
self.pitch				= self.pitch	+ math.rad(0.03);
self.roll				= self.roll		- math.rad(0.03);
--LOG("yaw " .. self.yaw .. " pitch " .. self.pitch .. " roll " .. self.roll)
local skybox = cSkyBox -- .GetInstance()
skybox:SetView(self.yaw, self.pitch, self.roll)

	return Menu.OnDraw(self, dwTime);
end



-- return an instance of BackdropMenu
return ExportSingleInstance("BackdropMenu")