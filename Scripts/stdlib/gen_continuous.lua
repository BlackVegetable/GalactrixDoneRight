-- Gen Continuous
--	this is a utility function to generate functions that use the continuous lib
--	

-- Eg:	we want to set a GameObjects size over time
--	first we generate our function "morph_scale" (youd probably do this in a file thats included in startup.lua)
--	we pass it the function to apply to our object
--
--		morph_scale = gen_continuous( function(obj,size) obj:GetView():SetScale(size) end )
--
--	next whenever we want to make an object morph sizes we call it with the following params
--		morph_scale(object, startScale, endScale, startTime, duration)
--	eg if we wanted to scale obj1 from 0.5 to 1.0 over 1 second we would do this
--		morph_scale(obj1, 0.5, 1.0, GetGameTime(), 1000)

require "continuous"
require "weakref"
require "interpolation"

--require "import"
use_safeglobals()



-- helper function for generating functions of the form
--	f(obj, startParam, endParam, startTime, duration)
-- the generated function causes the object to get the applier applied to it each frame.
function _G.gen_continuous(applier, interpolation)
	local interpolation = interpolation or lerp
	
	-- the generated function proto
	local function func (object, startParam, endParam, startTime, duration)
		-- local weakobj		= weakref(object)
		local applier		= applier
		local interpolation = interpolation

		-- the continuous functions system takes funcs that take a single time argument.
		-- we bind extra arguments as upvalues
		local function ticker(t)
			-- check our object still exists
			-- local obj = weakobj()
			local obj = object
			if not obj then return true end
			
			-- continuous period hasnt started yet
			if startTime > t then
				applier(obj, startParam)
				return false
			end
			
			-- elapsed. operation is finished
			if startTime+duration < t then
				applier(obj, endParam)
				return true
			end
			
			local cursize = interpolation(t, 
				startTime, duration,
				startParam, endParam)
			
			applier(obj, cursize)
			return false;
		end
		
		-- queue our ticker into the system
		queue_continuous(ticker)
	end

	return func
end


--local function test()
-- 	local continuous_sizer = gen_continuous( function(a,b) print(a,b) end )
-- 	continuous_sizer("obj1", 32, 64, 1, 20)
-- 	for t=0,110 do
-- 		tick_continuous(t)
-- 	end
--end
-- test()
--test=nil