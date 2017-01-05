
use_safeglobals()

local assert = assert
local type = type

local pow = math.pow
local sqrt = math.sqrt
local table_remove = table.remove


local function point_distance(x1, y1, x2, y2)
	assert(type(x1) == "number" and type(y1) == "number" and type(x2) == "number" and type(y2) == "number")
	
	return sqrt( pow((x2-x1), 2) + pow((y2-y1), 2) )
end

--[[
finds a path from startNode to endNode on graph. 
sets the path under obj.path. 
sets the movement type under obj.movetype. 
ensures that the object has an appropriate OnMovementFinished handler. 
starts movement on the first segment.
]]
function _G.GraphMove(obj, graph, startNode, endNode, movementType)
	assert(obj ~= nil)
	assert(graph ~= nil)
	assert(startNode ~= nil)
	assert(endNode ~= nil)
	assert(type(movementType) == "string")

	if startNode ~= endNode then
		local path = GetPath(graph, startNode, endNode)
		GraphMovePath(obj, path, movementType)
	end
end

function _G.GraphMovePath(obj, path, movementType)
	assert(obj ~= nil)
	assert(type(path) == "table")
	assert(type(movementType) == "string")

	if #path == 0 then
		return
	end
	
	obj.path_state = {
		path = {},
		start_node = nil,
		moveType = movementType
	}

	for k,v in pairs(path) do obj.path_state.path[k] = v end -- copy table
	
	if obj.OnEventMovementFinished == nil or type(obj.OnEventMovementFinished) ~= "function" then
		obj.OnEventMovementFinished = DefaultOnEventMovementFinished
	end
	
	obj.path_state.start_node = table_remove(obj.path_state.path, 1) -- pop begining location
	
	if obj.OnLeaveNode and type(obj.OnLeaveNode) == "function" then
		obj:OnLeaveNode(obj.path_state.start_node)
	end
	
	GraphMoveSeg(obj) -- begin movement
end


--[[
creates a movement controller for the object to move it to the next node in the path.
]]
function _G.GraphMoveSeg(obj)
	assert(obj ~= nil)
	assert(type(obj.path_state.moveType) == "string")
	
	if 
		obj.path_state.path == nil or 
		type(obj.path_state.path) ~= "table" or 
		#obj.path_state.path == 0 
	then
		return
	end
	
	local node = nil
	while #obj.path_state.path > 0 do
		node = obj.path_state.path[1]
		
		if 
			node ~= nil and 
			node:HasAttribute("xpos") and 
			node:HasAttribute("ypos") 
		then
			break
		end
		
		table_remove(obj.path_state.path, 1)
	end
	
	if node == nil then
		return
	end
	
	local newX = node:GetAttribute('xpos')
	local newY = node:GetAttribute('ypos')
	
	local oldX = obj:GetX()
	local oldY = obj:GetY()
	
	local speed = 1
	if obj:HasAttribute("speed") then
		speed = obj:GetAttribute("speed")
	end
	local duration = (point_distance(oldX, oldY, newX, newY) * 10) / speed
	
	if obj:HasMovementController() then
		local m = obj:GetMovementController()
		m:SetAttribute("EndX", newX)
		m:SetAttribute("EndY", newY)
	else
		local m = MovementManager:Construct(obj.path_state.moveType)
		m:SetAttribute("Duration", duration)
		m:SetAttribute("StartX", oldX)
		m:SetAttribute("StartY", oldY)
		m:SetAttribute("EndX", newX)
		m:SetAttribute("EndY", newY)
		
		obj:SetMovementController(m)
	end

	obj.path_state.dest_node = table_remove(obj.path_state.path, 1) -- pop target location
end


--[[
this is the default handler that gets assigned in GraphMove
It pops the last location off obj.path as we reach it and calls GraphMoveSeg on the object
]]
function _G.DefaultOnEventMovementFinished(obj, event)
	assert(obj ~= nil)
	assert(type(obj.path_state.path) == "table")
	
	obj.path_state.curr_node = obj.path_state.dest_node
	obj.path_state.dest_node = nil
	
	if obj.OnArriveAtNode and type(obj.OnArriveAtNode) == "function" then
		obj:OnArriveAtNode(obj.path_state.curr_node)
	end

	if #obj.path_state.path == 0 then
		local end_node = obj.path_state.curr_node
		obj.path_state = {} -- clean up
		
		if obj.OnArriveAtEndNode and type(obj.OnArriveAtEndNode) == "function" then
			obj:OnArriveAtEndNode(end_node)
		end
		
	else
		if obj.OnLeaveNode and type(obj.OnLeaveNode) == "function" then
			obj:OnLeaveNode(obj.path_state.curr_node)
		end				
		
		GraphMoveSeg(obj)
	end

end

function _G.ClearGraphMove(obj)
	assert(obj ~= nil)
	assert(type(obj.path_state.path) == "table")

	obj.path_state.path = {} -- clear table
end

