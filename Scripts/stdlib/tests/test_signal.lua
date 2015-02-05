TestSignal = {}

LOG("Running TestSignal")

function TestClassSystem:test_signals()
    local sig = ConstructSignal()
    local sigCalled = false
    
    local function callback()
        sigCalled = true
    end
    
    sig.attach(1, callback)
    sig()
    sig.detach(1)
    
    assert(sigCalled)
end

function TestClassSystem:test_errors()
    local sig = ConstructSignal()
    local sigCalled = false
    
    local function callback()
        sigCalled = true
    end
    
    sig.attach(1, callback)
    
    test_error("not allowed to attach twice", function ()
        sig.attach(1, callback)
    end)
    
    sig.detach(1)
    
    test_error("not allowed to detach twice", function ()
        sig.detach(1)
    end)
    
    test_error("cannot detach a key that does not exist", function ()
        sig.detact(math.pi)
    end)
    
    assert(sigCalled)
end

function TestClassSystem:test_metamethod()
    local sig = ConstructSignal()
    local sigCalled = false
    
    local function callback()
        sigCalled = true
    end
    
    sig[1] = callback
    sig()
    sig[1] = nil
    
    assert(sigCalled)
end

function TestClassSystem:test_detach()
    local sig = ConstructSignal()
    local sigCallCount = 0
    
    local function callback()
        sigCallCount = sigCallCount + 1
    end
    
    sig()
    sig[1] = callback
    sig()
    sig[1] = nil
    sig()
    
    assert(sigCallCount == 1)
end

