

TestAutoload = {}


-- test 1
--	create a table that loads from the test dir
--  ensure it can load a known file on access
function TestAutoload:test_loads()
	local t = autoload("tests/")
	assert( t.autoload_data )
end


-- test 2 - ensure returns same instance if no gc
--  create a table that loads from the test dir
--	load a file using the autoload table
--	hold the result in a local
--	nil it out from the table
--	run the gc twice.
--	access the entry again
--	assert that the local and the table entry are the same still
function TestAutoload:test_weakref()
	local t = autoload("tests/")
	local d = t.autoload_data
	t.autoload_data = nil
	collectgarbage();collectgarbage();collectgarbage();
	assert(t.autoload_data == d)
	assert(tostring(t.autoload_data) == tostring(d))
end

-- test 3 - ensure niling it lets it be gced
--  create a table that loads from the test dir
--	load a file using the autoload table
--	get the string name of it
--	nil it out from the table
--	run the gc twice.
--	access the entry again
--	assert the string names are different
function TestAutoload:test_weakref_release()
	local t			= autoload("tests/")
	local name		= tostring(t.autoload_data)
	t.autoload_data	= nil
	collectgarbage();collectgarbage();collectgarbage();
	assert(tostring(t.autoload_data) ~= tostring(d))
end
