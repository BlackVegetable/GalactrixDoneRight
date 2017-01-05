
use_safeglobals()

--[[
Lua text substitution
]]

local string_gsub = string.gsub

function _G.substitute(base, ...)
    local n = #arg
    local s = base
    for i=1, n do
       local pat = "{" .. i .. "}"
       s = string_gsub(s, pat, tostring(arg[i]))
    end
    return s
end
