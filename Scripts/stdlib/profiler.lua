--[[
Lua profiler - Copyright Pepperfish 2002,2003,2004

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to
do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
]]

-- Converted to Lua 5, a few improvements, and 
-- additional documentation by Tom Spilman 
-- ( tom@sickheadgames.com )
-- Additional corrections and tidying  by original author
-- Daniel Silverstone ( dsilvers@pepperfish.net )
--
-- Note that this requires os.clock(), debug.sethook(),
-- and debug.getinfo() or your equivalent replacements to
-- be available if this is an embedded application.
--
-- further modifications for 5.1 and some other minor mods
-- by Nikolas Bowe (nbowe@infinite-interactive.com)

-- Example usage:
--
--  profiler = newProfiler()
--  profiler:start()
--
--  < call some functions that take time >
--
--  profiler:stop()
--
--  local outfile = io.open( "profile.txt", "w+" )
--  profiler:report( outfile )
--  outfile:close()
--
-- to use LOG to output call profiler:log_report instead


--
--	All profiler related stuff is stored in the top level table '_profiler'
--
_profiler = {}


--
-- newProfiler() creates a new profiler object for managing 
-- the profiler and storing state.  Note that only one profiler 
-- object can be executing at one time.
--
function newProfiler()
   local newprof = {}
   for k,v in pairs(_profiler) do
      newprof[k] = v;
   end
   return newprof
end



--
-- Simple wrapper to handle the hook.  You should not
-- be calling this directly.
--
local function _profiler_hook_wrapper(action)
   if( _profiler.running == nil ) then
      debug.sethook( nil );
   end
   _profiler.running:_internal_profile(action)
end

--
-- This function starts the profiler.  It will do nothing
-- if this (or any other) profiler is already running.
--
function _profiler.start(self)
   if( _profiler.running ) then
      return
   end
   -- Start the profiler. This begins by setting up internal profiler state
   _profiler.running	= self;
   self.rawstats		= {}
   self.callstack		= {}
   debug.sethook( _profiler_hook_wrapper, "cr" )
end


--
-- This function stops the profiler.  It will do nothing 
-- if a profiler is not running, and nothing if it isn't 
-- the currently running profiler.
--
function _profiler.stop(self)
   if( _profiler.running ~= self ) then
      return
   end
   -- Stop the profiler.
   debug.sethook( nil )
   _profiler.running = nil
end


-- cache all globals that are called in a typical run of _internal_profile
local debug_getinfo = debug.getinfo
-- our c code exports getinfo_to_table which uses a table that the caller provides.
assert(getinfo_to_table)
local getinfo_to_table = getinfo_to_table or function(f,o,t) return debug_getinfo(f,o) end
local table_getn	= table.getn
local table_insert	= table.insert
local table_remove	= table.remove
local pairs			= pairs
local next			= next
local GetSystemTime = GetSystemTime
local os_clock		= GetSystemTime and function() return GetSystemTime()/1000.0 end or os.clock
local string_format	= string.format

local table_pool = {}
local function new_table()
	local t
	if table_getn(table_pool) > 0 then
		t = table_remove(table_pool)
	else
		t = {}
	end
	return t
end
local function recycle_table(t)
	-- clear the table.
	local idx = next(t)
	while idx do
		t[idx]=nil
		idx = next(t)
	end
	-- ensure that we free its memory
	t._ = nil
	-- insert into pool if pool is below some threshold
	if table.getn(table_pool)<40 then
		table_insert(table_pool, t)
	end
end

--
-- This is the main internal function of the profiler and should not be called except by the hook wrapper
-- TODO:	pause profiling while this func does its stuff.
--		some way to get caller info without allocing a new table would be good. we use some low mem devices and waiting for the gc sucks.
function _profiler._internal_profile(self,action)
	local curtime = os_clock()

	-- First entry on the stack will be the hook wrapper, ensure this...
	-- we use the function rather than the name for this. itll work with stripped function and sometimes it cant get the name (if its the hook func?)
	local direct_caller = getinfo_to_table( 2, "f", new_table() )
	if( direct_caller.func ~= _profiler_hook_wrapper ) then
		print("Profiler's internal profiler function called by: " .. tostring(debug_getinfo( 2, "n" ).name) )
		return
	end
	recycle_table(direct_caller)

	-- Since we can obtain the 'function' for the item we've had call us, we can use that...
	local caller_info = getinfo_to_table( 3, "flnS", new_table() );
	if( caller_info == nil ) then
		print "No caller_info";
		return
	end

	--SHG_LOG( "[_profiler._internal_profile] " .. ( caller_info.name or "<nil>" ) )

	-- Retrieve the most recent activation record...
	local latest_ar			= nil;
	local callstack_size	= table_getn(self.callstack)
	if( callstack_size > 0 ) then
		latest_ar = self.callstack[callstack_size];
	end

	-- Are we allowed to profile this function?
	local should_not_profile = 0

	local prevented_level = self.prevented_functions[caller_info.func]
	if (prevented_level ~= nil) then
		should_not_profile = prevented_level
	end
	-- Also check the top activation record...
	if( latest_ar ) then
		if( latest_ar.should_not_profile == 2 ) then
			should_not_profile = 2
		end
	end

   -- Now then, are we in 'call' or 'return' ?
   -- print("Profile:", caller_info.name, "SNP:", should_not_profile, "Action:", action );
   if( action == "call" ) then
		-- Making a call...
		local this_ar 				= new_table()
		this_ar.should_not_profile	= should_not_profile;
		this_ar.parent_ar			= latest_ar
		this_ar.anon_child			= 0
		this_ar.name_child			= 0
		this_ar.children			= new_table()
		this_ar.children_time		= new_table()
		this_ar.clock_start			= curtime
		-- Last thing to do on a call is to insert this onto the ar stack...
		table_insert( self.callstack, this_ar );
		-- we dont need the caller info anymore
		recycle_table(caller_info)
	else
		local this_ar = latest_ar;
		if( this_ar == nil ) then
			return; -- No point in doing anything if there's no upper activation record
		end

		-- Right, calculate the time in this function...
		this_ar.clock_end = curtime
		this_ar.this_time = this_ar.clock_end - this_ar.clock_start

		local f = caller_info.func

		-- Now, if we have a parent, update its call info...
		if( this_ar.parent_ar ) then
			local parent_ar = this_ar.parent_ar
			parent_ar.children[f]		= (parent_ar.children[f] or 0) + 1;
			parent_ar.children_time[f]	= (parent_ar.children_time[f] or 0 ) + this_ar.this_time;
			if( caller_info.name == nil ) then
				parent_ar.anon_child	= parent_ar.anon_child + this_ar.this_time
			else
				parent_ar.name_child	= parent_ar.name_child + this_ar.this_time
			end
		end
		-- Now if we're meant to record information about ourselves, do so...
		if( this_ar.should_not_profile == 0 ) then
			local inforec			= self:_get_func_rec(f, 1);
			inforec.count			= inforec.count + 1;
			inforec.time			= inforec.time + this_ar.this_time
			inforec.anon_child_time	= inforec.anon_child_time + this_ar.anon_child
			inforec.name_child_time	= inforec.name_child_time + this_ar.name_child
			if (not inforec.func_info) then
				inforec.func_info	= caller_info
			else
				recycle_table(caller_info)
			end
			for k,v in pairs(this_ar.children) do
				inforec.children[k]			= (inforec.children[k] or 0) + v;
				inforec.children_time[k]	= (inforec.children_time[k] or 0) + this_ar.children_time[k];
			end
		end
		
		-- Last thing to do on return is to drop the last activation record...
		recycle_table(this_ar.children)
		recycle_table(this_ar.children_time)
		recycle_table(this_ar)
		table_remove( self.callstack, table_getn( self.callstack ) );
	end
end


--
-- This returns a (possibly empty) function record for 
-- the specified function. It is for internal profiler use.
--
function _profiler._get_func_rec(self,func,force)
   -- Find the function ref for the 'func' (if force and not present, create one)
   local ret = self.rawstats[func];
   if( ret == nil and force ~= 1 ) then
      return nil
   end
   if( ret == nil ) then
      -- Build a new function statistics table
      ret					= new_table()
      ret.func				= func;
      ret.count				= 0;
      ret.time				= 0;
      ret.anon_child_time	= 0;
      ret.name_child_time	= 0;
      ret.children			= new_table()
      ret.children_time		= new_table()
      self.rawstats[func]	= ret;
   end
   return ret
end


--
-- This writes a profile report to the output file object.  If
-- sort_by_total_time is nil or false the output is sorted by
-- the function time minus the time in it's children.
--
function _profiler.report( self, outfile, sort_by_total_time )

   outfile:write( [[Lua Profile output created by profiler.lua. Copyright Pepperfish 2002+

]] )

   local total_time = 0;
   local ordering = {}
   for func,record in pairs(self.rawstats) do
      table.insert(ordering, func);
   end

	if ( sort_by_total_time ) then

	   table.sort( ordering, 
			function(a,b)
				return self.rawstats[a] > self.rawstats[b]
			end
		)
	
	else
		
		table.sort( ordering, 
			function(a,b)
				local arec = self.rawstats[a] 
				local brec = self.rawstats[b]
				local atime = arec.time - ( arec.anon_child_time + arec.name_child_time )
				local btime = brec.time - ( brec.anon_child_time + brec.name_child_time )
				return atime > btime
			end
		)

	end

	for i=1,table.getn(ordering) do
		local func = ordering[i]
		local record = self.rawstats[func]


		local thisfuncname = string.format("%s %s %s", 
				string.rep("-", 25),
				self:_pretty_name(func),
				string.rep("-", 25)
			)
		--local thisfuncname = string.format(" %s ", self:_pretty_name(func));
		--if( string.len( thisfuncname ) < 42 ) then
		--	thisfuncname = string.rep( "-", (42 - string.len(thisfuncname))/2 ) .. thisfuncname;
		--	thisfuncname = thisfuncname .. string.rep( "-", 42 - string.len(thisfuncname) );
		--end

		total_time = total_time + ( record.time - ( record.anon_child_time + record.name_child_time ) )
		outfile:write( thisfuncname )
		outfile:write( string.format("                 Call count: %4d\n", record.count) )
		outfile:write( string.format("                 Total time: %4.3fs\n", record.time ) )
		outfile:write( string.format("     Time spent in children: %4.3fs\n", record.anon_child_time + record.name_child_time )  )
		outfile:write( string.format("         Time spent in self: %4.3fs\n", record.time - ( record.anon_child_time + record.name_child_time ) ) )
		outfile:write( string.format("        Time spent per call: %4.5fs/call\n", record.time/record.count ) )
		outfile:write( string.format("Time spent in self per call: %4.5fs/call\n", (record.time - ( record.anon_child_time + record.name_child_time ))/record.count ) )

		-- Report on each child in the form
		-- Child  <funcname> called n times and took a.bs
		local added_blank = 0
		for k,v in pairs(record.children) do
			if( self.prevented_functions[k] == nil or self.prevented_functions[k] == 0 ) then
				if( added_blank == 0 ) then
					outfile:write( "\n" ); -- extra separation line
					added_blank = 1;
				end
				
				outfile:write( 
					string.format(
						"Child %s%s called %06d times. Took %04.2fs\n",
						self:_pretty_name(k),
						string.rep(" ", 80 - string.len(self:_pretty_name(k))),
						v,record.children_time[k]
					)
				)
			end
		end

		outfile:write( "\n" ); -- extra separation line
		outfile:flush()
	end
	outfile:write( "\n\n" )
	outfile:write( string.format("Total time spent in profiled functions: %5.3gs\n",total_time) )
	outfile:write( "\n\n\nEND\n" )
	outfile:flush()
end

-- a version of report that uses LOG(). so we can use it on ds.
-- note that we might lack some info on ds (line numbers etc). youll need to change the build process so it doesnt strip.
function _profiler.log_report(self)
	-- our fake file
	local o = {
		write = function(s, msg)
				LOG(msg)
			end;
		flush = function(s)
			end;
	}
	self:report(o)
end

--
-- This writes the profile to the output file object as 
-- loadable Lua source.
--
function _profiler.lua_report(self,outfile)
   -- Purpose: Write out the entire raw state in a cross-referenceable form.
   local ordering = {}
   local functonum = {}
   for func,record in pairs(self.rawstats) do
      table.insert(ordering, func);
      functonum[func] = table.getn(ordering);
   end

   outfile:write( "-- Profile generated by profiler.lua Copyright Pepperfish 2002+\n\n" );
   outfile:write( "-- Function names\nfuncnames = {}\n" );
   for i=1,table.getn(ordering) do
      local thisfunc = ordering[i];
      outfile:write( "funcnames[" .. i .. "] = " .. string.format("%q", self:_pretty_name(thisfunc)) .. "\n" );
   end
   outfile:write( "\n" );
   outfile:write( "-- Function times\nfunctimes = {}\n" );
   for i=1,table.getn(ordering) do
      local thisfunc = ordering[i];
      local record = self.rawstats[thisfunc];
      outfile:write( "functimes[" .. i .. "] = { " );
      outfile:write( "tot=" .. record.time .. ", " );
      outfile:write( "achild=" .. record.anon_child_time .. ", " );
      outfile:write( "nchild=" .. record.name_child_time .. ", " );
      outfile:write( "count=" .. record.count .. " }\n" );
   end
   outfile:write( "\n" );
   outfile:write( "-- Child links\nchildren = {}\n" );
   for i=1,table.getn(ordering) do
      local thisfunc = ordering[i];
      local record = self.rawstats[thisfunc];
      outfile:write( "children[" .. i .. "] = { " );
      for k,v in pairs(record.children) do
	 if( functonum[k] ) then -- non-recorded functions will be ignored now
	    outfile:write( functonum[k] .. ", " );
	 end
      end
      outfile:write( "}\n" );
   end
   outfile:write( "\n" );
   outfile:write( "-- Child call counts\nchildcounts = {}\n" );
   for i=1,table.getn(ordering) do
      local thisfunc = ordering[i];
      local record = self.rawstats[thisfunc];
      outfile:write( "children[" .. i .. "] = { " );
      for k,v in pairs(record.children) do
	 if( functonum[k] ) then -- non-recorded functions will be ignored now
	    outfile:write( v .. ", " );
	 end
      end
      outfile:write( "}\n" );
   end
   outfile:write( "\n" );
   outfile:write( "-- Child call time\nchildtimes = {}\n" );
   for i=1,table.getn(ordering) do
      local thisfunc = ordering[i];
      local record = self.rawstats[thisfunc];
      outfile:write( "children[" .. i .. "] = { " );
      for k,v in pairs(record.children) do
	 if( functonum[k] ) then -- non-recorded functions will be ignored now
	    outfile:write( record.children_time[k] .. ", " );
	 end
      end
      outfile:write( "}\n" );
   end
   outfile:write( "\n\n-- That is all.\n\n" );
   outfile:flush();
end

-- Internal function to calculate a pretty name for the profile output
function _profiler._pretty_name(self,func)

   -- Only the data collected during the actual
   -- run seems to be correct.... why?
   local info = self.rawstats[ func ].func_info
   -- local info = debug.getinfo( func )

   local name = "";
   if( info.what == "Lua" ) then
      name = "L:"
   end
   if( info.what == "C" ) then
      name = "C:"
   end
   if( info.what == "main" ) then
      name = " :"
   end
   
   if( info.name == nil ) then
      name = name .. "<"..tostring(func) .. ">"
   else
      name = name .. info.name
   end

   if( info.source ) then
      name = name .. "@" .. info.source
   else
      if( info.what == "C" ) then
	 name = name .. "@?"
      else
	 name = name .. "@<string>"
      end
   end
   name = name .. ":"
   if( info.what == "C" ) then
      name = name .. "?"
   else
      name = name .. info.linedefined
   end

   return name
end


--
-- This allows you to specify functions which you do
-- not want profiled.  Setting level to 1 keeps the
-- function from being profiled.  Setting level to 2
-- keeps both the function and its children from
-- being profiled.
--
function _profiler.prevent(self, func, level)
   self.prevented_functions[func] = (level or 1)
end


_profiler.prevented_functions = {
   [ _profiler.start             ] = 2,
   [ _profiler.stop              ] = 2,
   [ _profiler._internal_profile ] = 2,
   [ _profiler_hook_wrapper      ] = 2,
   [ _profiler.prevent           ] = 2,
   [ _profiler._get_func_rec     ] = 2,
   [ _profiler.report            ] = 2,
   [ _profiler.lua_report        ] = 2,
   [ _profiler._pretty_name      ] = 2
}
