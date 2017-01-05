-- LuaUnit Test Runner
require "luaunit"

-- test LuaUnit itself
require "tests/test_luaunit"

--[[
================================
REQUIRE UNIT TEST FILES BELOW
================================
--]]

-- example: including a set of tests found in tests/use_luaunit.lua
--require "tests/use_luaunit"











--[[
================================
ALL TEST FILES ABOVE THIS LINE
================================
--]]

print("LuaTests Running...")
LuaUnit:run()
print("LuaTests Finished")
