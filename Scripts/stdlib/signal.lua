
local function SignalAttach(signal, key, callback)
    if not signal.callbacks then
        rawset(signal, "callbacks", {})
    elseif signal.callbacks[key] then
        error(string.format("You shouldn't replace a signal, detach it first (using key %s)", tostring(key)))
    end
    signal.callbacks[key] = callback
end

local function SignalDetach(signal, key)
    if not signal.callbacks[key] then
        error(string.format("you cannot detach a callback that is not attached (using key %s)", tostring(key)))
    end
    signal.callbacks[key] = nil
end

function _G.ConstructSignal()
    local signal = {}
    local signalmt = {}
    
    function signalmt.__call(t, ...)
        if t.callbacks then 
            for index,fn in pairs(t.callbacks) do
                fn(...)
            end
        end
    end
    
    function signalmt.__newindex(t, key, value) -- value should be callable
        if not value then
            t:detach(key)
        else
            t:attach(key,value)
        end
    end

    setmetatable(signal, signalmt)

    rawset(signal, "attach", SignalAttach)
    rawset(signal, "detach", SignalDetach)
    
    return signal
end

