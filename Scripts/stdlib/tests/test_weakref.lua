require "weakref"

TestWeakRef = {} --class

function TestWeakRef:test_weakref()
	local obj = {"hello"}
	local ref = weakref(obj)
	assert(ref() ~= nil, "couldnt get reference")
	assert(obj == ref(), "didnt get correct reference")
	
	local objref = ref()
	assert (objref[1]=="hello", "didnt get correct value back from weak reference" )
--	print(obj, objref)
	objref = nil; -- release our strong ref

	obj = nil; 
	collectgarbage();collectgarbage(); -- make sure its deallocated
	objref = ref()
--	print(obj, objref)
	assert(objref == nil, "weak ref stopped garbage collection")


	-- check that nil references cant magically point to a new object
	local tempobj = {}
	local tempref = weakref(tempobj)
	-- create our test obj and refs
	obj = {}
	ref = weakref(obj)
	local ref2 = weakref(obj)
	assert (ref() == obj and ref2() == obj);
	assert (ref == ref2, "got different weakref closures for same object")	-- this should really be a warning
	-- should all be the same
--	print ("obj: ",obj)
--	print ("ref: ",ref, " ref(): ",ref())
--	print ("ref2: ",ref2, " ref2(): ",ref2())
	-- create another object and ref.
	-- this is so the reference system will have a whole in the middle
	local tempobj2 = {}
	local tempref2 = weakref(tempobj2)
--	print("should be 3 objects");for k,v in pairs(weakrefs) do print(k,v) end
	-- reassign object
	obj = {}
	collectgarbage();collectgarbage(); -- ensure old obj is removed from system
--	print (obj,ref(),ref2())	-- refs should be nil
	assert (ref() == nil and ref2() == nil);
--	print("should be 2 objects");for k,v in pairs(weakrefs) do print(k,v) end
	-- now create a new ref and see if it overwrites the old ref
	local ref3 = weakref(obj)
--	print (obj,ref3()," oldrefs:",ref(),ref2())	-- ref and ref2 should be nil.
	assert(ref3() == obj)
	assert(ref2() == nil, "ref2 got magically reassigned");
	assert(ref() == nil, "ref got magically reassigned");
end
