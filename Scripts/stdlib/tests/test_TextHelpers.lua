--[[
		test_TextHelpers.lua

Description: Tests for TextHelpers

--]]

require('TextHelpers')

TestTextHelpers = {} --class

function TestTextHelpers:test_substitute()
	local str = substitute("hello {1}, how are {3}", "bob", "me", "you")
	assertEquals(str, "hello bob, how are you")
end
