
-- _G.ScreenManager Stub

use_safeglobals()


local function stub(...)
	LOG("do nothing")
end


return {
	 ["init"] = stub;
	 ["close_all"] = stub;
	 ["push_back"] = stub;
	 ["pop_back"] = stub;
	 ["print"] = stub;
}

