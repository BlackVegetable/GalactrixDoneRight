--[[
Deque
--]]

use_safeglobals()

local deque = {}
local deque_mt = {__index = deque}

function deque.new()
	local d = setmetatable({}, deque_mt)
	
	d.deque_t = {}
	d.first = 0
	d.last = -1

	return d
end


function deque:push_front(v)
	self.first = self.first - 1
	self.deque_t[self.first] = v
end	


function deque:push_back(v)
	self.last = self.last + 1
	self.deque_t[self.last] = v
end


function deque:pop_front()
	if self.deque_t[self.first] then
		self.deque_t[self.first] = nil
		self.first = self.first + 1
	end
end


function deque:pop_back()
	if self.deque_t[self.last] then
		self.deque_t[self.last] = nil
		self.last = self.last - 1
	end
end


function deque:back()
	return self.deque_t[self.last]
end


function deque_mt.__tostring(obj)
	local s = ""
	for i=obj.first,obj.last do
		s = s .. "deque " .. tostring(i) .. " -> " .. tostring(obj.deque_t[i]) .. "\n"
	end
	return s
end

return deque
