


-- returns an object that when gc'd causes func to be executed
-- func is a nullary function. use bind if you need to pass the owning object in

function on_gc(func)
	assert(type(func)=="function")
	local p = newproxy(true)
	local meta = getmetatable(p)
	meta.__gc = func
	return p;
end


function purge_garbage()
	local m0 = gcinfo()
	local m1 = m0
	local m2 = m0
	local i=0
	local t0 = GetSystemTime()
	repeat
		m1 = m2 -- last gc level
		i=i+1
		collectgarbage();collectgarbage();
		m2 = gcinfo()
	until(m1 == m2)
	local t1 = GetSystemTime()
	--assert(m2 <= m0)
	--LOG(debug.traceback())
	LOG(string.format(" purge_garbage purged %d kb in %d iterations (took %d ms)", (m0-m2), i, (t1-t0) ))
end

