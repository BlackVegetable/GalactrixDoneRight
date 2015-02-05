
TestAttributes = {}


local function decl_object()
	class "TestObject" (GameObject)

	TestObject.AttributeDescriptions = AttributeDescriptionList()
	TestObject.AttributeDescriptions:AddAttribute('string', 'stringAttr', {} )
	TestObject.AttributeDescriptions:AddAttribute('int', 'intAttr', {} )
	TestObject.AttributeDescriptions:AddAttribute('GameObject', 'goAttr', {} )

	function TestObject:__init()
		super("Test")
		self:InitAttributes()
		self.data = 0
		self:DoSomething()
	end
	function TestObject:DoSomething()
		self.data=self.data+1
		return self.data
	end
	
	local o = TestObject
	TestObject = nil
	return o
end




-- Performance tests
-- arbitrary results on my machine. (with debug checks in, but optimizations on)
-- Lua :  Integer GetAttributes per second:       156957.04295704
-- Lua :  Integer GetAttributeByIndex per second: 650119.88011988
-- Lua :  Integer SetAttributes per second:              133390.60939061
-- Lua :  Integer SetAttributeByIndex  index per second: 516907.09290709

-- test 1
-- performance test
-- test the rate at which we can set attributes
function TestAttributes:test_attribute_set_rate()
	local test_class = decl_object()
	local o = test_class()
	
	local t1 = GetSystemTime()
	local t2=t1
	local c = 0
	repeat
		c = c + 1
		o:SetAttribute("intAttr", c)
		t2 = GetSystemTime();
	until (t2 > t1+1000)
	
	local delta = t2-t1
	local persec = c*1000/delta
	LOG(" Integer SetAttributes per second: "..persec)
end

function TestAttributes:test_attribute_set_rate_by_index()
	local test_class = decl_object()
	local o = test_class()
	
	local t1 = GetSystemTime()
	local t2=t1
	local c = 0
	local idx = o:GetAttributeIndex("intAttr")
	repeat
		c = c + 1
		o:SetAttributeByIndex(idx, c)
		t2 = GetSystemTime();
	until (t2 > t1+1000)
	
	local delta = t2-t1
	local persec = c*1000/delta
	LOG(" Integer SetAttributes by index per second: "..persec)
end

-- performance test
-- test the rate at which we can get attributes
function TestAttributes:test_attribute_get_rate()
	local test_class = decl_object()
	local o = test_class()
	
	local t1 = GetSystemTime()
	local t2=t1
	local c = 0
	repeat
		c = c + 1
		local r = o:GetAttribute("intAttr")
		t2 = GetSystemTime();
	until (t2 > t1+1000)
	
	local delta = t2-t1
	local persec = c*1000/delta
	LOG(" Integer GetAttributes per second: "..persec)
end
function TestAttributes:test_attribute_get_rate_by_index()
	local test_class = decl_object()
	local o = test_class()
	
	local t1 = GetSystemTime()
	local t2=t1
	local c = 0
	local idx = o:GetAttributeIndex("intAttr")
	repeat
		c = c + 1
		local r = o:GetAttributeByIndex(idx)
		t2 = GetSystemTime();
	until (t2 > t1+1000)
	
	local delta = t2-t1
	local persec = c*1000/delta
	LOG(" Integer GetAttributes by index per second: "..persec)
end
