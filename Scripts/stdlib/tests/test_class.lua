

TestClassSystem = {}



function decl_class()
	class "TestClassSystemClass"
	function TestClassSystemClass:__init()
		self.data = 0
		self:DoSomething()
	end
	function TestClassSystemClass:DoSomething()
		self.data=self.data+1
		return self.data
	end
end


function TestClassSystem:test_classes_gcable()
	-- create a new class
	decl_class()
	-- grab a weak ref to it
	local r = weakref(TestClassSystemClass)
	-- ensure the weak ref returns the class
	assert( r() == TestClassSystemClass )
	-- lose the class ref
	TestClassSystemClass = nil
	-- gc
	collectgarbage();collectgarbage();
	-- ensure weak ref is nil
	assert( r() == nil )
end


function TestClassSystem:test_instances_hold_class_ref()
	-- create a new class
	decl_class()
	-- grab a weak ref to it
	local r = weakref(TestClassSystemClass)
	-- create an instance
	local i = TestClassSystemClass()
	-- lose the class ref
	TestClassSystemClass = nil
	-- gc
	collectgarbage();collectgarbage();

	-- ensure weak ref is NOT nil
	assert( r() ~= nil )
	-- ensure we can use the instance
	assert( type(i:DoSomething()) == "number" )
	
	-- lose instance
	i=nil
	-- gc
	collectgarbage();collectgarbage();
	-- ensure weak ref is nil
	assert( r() == nil )
end


function TestClassSystem:test_child_classes_hold_class_ref()
	-- create a new class
	decl_class()
	-- grab a weak ref to it
	local r = weakref(TestClassSystemClass)
	-- declare a child class
	class "TestClassSystemChildClass" (TestClassSystemClass)
	-- lose the class ref
	TestClassSystemClass = nil
	-- gc
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	-- ensure weak ref is NOT nil
	assert( r() ~= nil )

	-- lose the child class ref
	TestClassSystemChildClass = nil
	-- gc
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	-- ensure weak ref is nil
	assert( r() == nil )
end

-- works is loosely defined as being able to create the class.
-- 
function TestClassSystem:test_reloading_class_works()
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	for it=1,10 do
		-- create a new class
		decl_class()
		-- grab a weak ref to it
		local r = weakref(TestClassSystemClass)
		-- create an instance
		local i = TestClassSystemClass()
		-- lose the class ref
		TestClassSystemClass = nil
		-- lose instance
		i=nil
		-- gc
		collectgarbage();collectgarbage();collectgarbage();collectgarbage();
		-- ensure weak ref is nil
		assert( r() == nil )
	end
end


function TestClassSystem:test_gameobjects_hold_class_ref()
	class "TestGO" (GameObject)
	function TestGO:__init(clid) super(clid) end
	local r1 = weakref(TestGO)
	class "TestGO2" (TestGO)
	function TestGO2:__init() super("TEST") end
	local r2 = weakref(TestGO2)

	TestGO = nil
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	
	-- we should still have a weak ref to both objects as the class TestGO2 holds them both
	assert( r1(), "lua child class doesnt hold lua parent class (which is a child of gameobject) alive..." )
	assert( r2() )
	
	local i = TestGO2()
	assert(i.__ok, "Couldnt check GameObject for __ok")
	TestGO2 = nil
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();

	-- we should still have a weak ref to both objects as the instance holds them both alive
	assert( r2(), "instance of class didnt hold class" )
	assert( r1() )
	assert( ClassIDToString( i:GetClassID() ) == "TEST")
	
	i=nil
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	assert( r2() == nil, "destroying instance of class didnt release class ref" )
	assert( r1() == nil, "destroying instance of class didnt release class ref" )
end


function TestClassSystem:test_super_doest_hold_strong_ref_past_construction()
	-- create a new class
	decl_class()
	-- grab a weak ref to it
	local r = weakref(TestClassSystemClass)
	-- declare a child class
	class "TestClassSystemChildClass" (TestClassSystemClass)
	function TestClassSystemChildClass:__init()
		super()
	end
	local r2 = weakref(TestClassSystemChildClass)
	-- lose the class ref
	TestClassSystemClass = nil

	-- create an instance
	local o = TestClassSystemChildClass()
	-- ensure super is unset
	assert(super == nil, "super() not unset after creating instance")
	-- destroy instance
	o = nil
	-- lose child class ref
	TestClassSystemChildClass = nil
	-- gc
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	-- ensure weak ref is nil
	assert( r2() == nil, "after object+class lost ref something held class alive" )
	assert( r() == nil, "after object+class lost ref something held parent class alive" )
end


function TestClassSystem:test_can_access_static_members_in_child_class()
	class "TestGO" (GameObject)
	TestGO.lua_static = true;
	local TestGO = ExportClass("TestGO")
	class "TestGO2" (TestGO)
	local TestGO2 = ExportClass("TestGO2")
	
	assert(TestGO.lua_static,  "Couldnt access lua static var from the class that defined it.")
	assert(TestGO2.lua_static,  "Couldnt access lua static var from a child class.")
end


function TestClassSystem:test_mem_use_of_lua_inheritence()
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	local gcinfo2 = gcinfo2 or function() return {Total=gcinfo()*1024} end

	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	local m0 = gcinfo2().Total
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();

	-- init_mem_leak_detection()
	class "TestGO" (GameObject)
	function TestGO:__init(clid) super(clid or "TGO1") end
	local TestGO = ExportClass("TestGO")
	-- close_mem_leak_detection()

	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	local m1 = gcinfo2().Total
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	LOG("lua inheritence from large cpp class took " .. m1-m0 .. " bytes")
	
	class "TestGO2" (TestGO)
	function TestGO2:__init() super("TGO2") end
	local TestGO2 = ExportClass("TestGO2")
	local m2 = gcinfo2().Total
	LOG("lua inheritence from a lua child class of a large cpp class took " .. m2-m1 .. " bytes")
	
	TestGO2 = nil
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	local m3 = gcinfo2().Total
	LOG("collecting a lua class which inherited from a lua child class of a large cpp class reclaimed " .. m2 - m3 .. " bytes")
	
	-- TODO: put asserts in here to detect case where luabind is still copying all info to child class
end


function TestClassSystem:test_mem_use_of_lua_inheritence_instance()
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	local gcinfo2 = gcinfo2 or function() return {Total=gcinfo()*1024} end
	local m0 = gcinfo2().Total

	class "TestGO" (GameObject)
	function TestGO:__init(clid) super(clid or "TGO1") end
	local TestGO = ExportClass("TestGO")

	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	local m1 = gcinfo2().Total
	-- create instance
	local o = TestGO()
	local m2 = gcinfo2().Total
	local r = weakref(o)
	LOG("instance of lua class took ".. (m2-m1) .." bytes")

	o=nil
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	assert(r() == nil, "niling object didnt destroy it")
	assert(TestGO, "test failure. class was counted in mem total reclaimed")
	local m3 = gcinfo2().Total
	LOG("destroying instance of lua class reclaimed ".. (m2-m3) .." bytes")
end

function TestClassSystem:test_can_access_static_members_in_child_class_instance()
	class "TestGO" (GameObject)
	function TestGO:__init(clid) super(clid or "TGO1") end
	TestGO.lua_static = true;
	local TestGO = ExportClass("TestGO")

	class "TestGO2" (TestGO)
	function TestGO2:__init() super("TGO2") end
	local TestGO2 = ExportClass("TestGO2")

	-- create an instance of gameobjects
	local go1 = TestGO()
	local go2 = TestGO2()

	assert(go1.lua_static, "couldnt access static member from instance of class...");
	assert(go2.lua_static, "couldnt access static member from instance of child class...");
	
	go1=nil
	go2=nil
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	collectgarbage();collectgarbage();collectgarbage();collectgarbage();
	
end

function TestClassSystem:test_can_access_exported_member_func_in_child_class_instance()
	-- check vfunc
	-- check nonvfunc
	class "TestGO" (GameObject)
	function TestGO:__init(clid) super(clid or "TGO1") end
	local TestGO = ExportClass("TestGO")

	class "TestGO2" (TestGO)
	function TestGO2:__init() super("TGO2") end
	local TestGO2 = ExportClass("TestGO2")
	
	assert(TestGO.RemoveOverlay, "couldnt access exported function")
	assert(TestGO2.RemoveOverlay, "couldnt access exported function")
	-- create an instance of gameobjects
	local go1 = TestGO()
	local go2 = TestGO2()
	assert(go1.RemoveOverlay, "couldnt access exported function from instance")
	assert(go2.RemoveOverlay, "couldnt access exported function from instance")
end
