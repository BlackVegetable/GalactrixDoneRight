TestDeque = {}

local deque = require "deque"


function TestDeque:test1()

	local q = deque.new()
	
	q:push_back(1)
	q:push_back(2)
	q:push_back(3)
	q:push_back(4)

	assert(q.last == 3)
end


function TestDeque:test2()
	local q = deque.new()
	
	local last = q.last
	local first = q.first
	
	q:pop_back()
	q:pop_back()
	
	q:pop_front()

	assert(q.last == last)
	assert(q.first == first)
end


function TestDeque:test3()

	local q = deque.new()
	
	q:push_back(1)
	q:push_back(2)
	q:push_back(3)
	q:push_back(4)
	
	LOG(tostring(q))

	q:pop_back()
	q:pop_back()
	q:pop_back()
	
	assert(q.last == 0)
end

