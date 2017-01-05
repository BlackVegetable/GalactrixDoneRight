-- continuous functions
-- sometimes we have simple things we want to do each frame for a short period (changing color, changing size, ...)
--	coroutines take about 1K per coroutine
--	but if its just a simple application of a function we can do it easily with simple functions

--require "import"
use_safeglobals()


local cont_funcs = {}

-- queues a continous function
--	bool f(time)
-- if f returns true it is removed.
function _G.queue_continuous(f)
	cont_funcs[#cont_funcs+1] = f
end

function _G.tick_continuous(time)
	local n = #cont_funcs
	if n == 0 then
		return false
	end

	-- note that order is not important.
	-- only that its removed when no longer in use
	local last = n;
	for i=n, 1, -1 do
		if cont_funcs[i](time) then
			-- swap it with the last and pop the last element
			cont_funcs[i] = cont_funcs[last]
			table.remove(cont_funcs)
			last=last-1
		end
	end
	return n
end



