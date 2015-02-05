local TestingHelpers = {}

function TestingHelpers.Wait(timeout)
	local startTime = GetGameTime()
	while GetGameTime() - startTime < timeout do
		coroutine.yield()
	end
end

function TestingHelpers.WaitForScreen(name, timeout --[[ can be nil ]])
	local startTime = GetGameTime()
	while not SCREENS[name]:IsOpen() do 
		if timeout and GetGameTime() - startTime > timeout then
			error(string.format("timeout while waiting for screen: %s", name))
		end
		coroutine.yield()
	end
	while SCREENS[name]:IsActiveAnimation() do
		coroutine.yield()       -- dont do timeout checking here because if its animating then at least it is here
	end
end

function TestingHelpers.FakeButtonClick(screenName, widgetName)
	assert(screenName)
	assert(widgetName)
	
	local screen = SCREENS[screenName]
	local x = 0 -- widget:GetX() + widget:GetWidth() / 2
	local y = 0 -- widget:GetY() + widget:GetHeight() / 2
	
	screen:OnButton(screen:get_widget_id(widgetName), x, y)
end

return TestingHelpers
