use_safeglobals()
require "gen_continuous"


-- mutate an event by every object in a collection
function _G.MutateWithCollection(event, object, collectionName)
	local colIndex
	if type(collectionName) == "string" then
		colIndex = object:GetAttributeCollectionIndex(collectionName)
	else
		colIndex = collectionName
	end

	for i=1,object:NumAttributesByIndex(colIndex) do
		local element = object:GetAttributeAtByIndex(colIndex, i)
		if element ~= nil then
			element:MutateEvent(event)
		end
	end
end


-- continuous_scale(objView, startScale, endScale, startTime, duration)
--	scales an object over time
local continuous_scale_view = gen_continuous( 
	function(v, scale)
		if v then v:SetScale(scale) end
	end)

function _G.continuous_scale(objOrView, startScale, endScale, startTime, duration)
	if objOrView.GetView then
		-- its an object
		LOG("THIS IS BAD!!!! use of continuous_scale on objects is deprecated. it now takes a view. THIS IS BAD!!!! ")
		return continuous_scale_view(objOrView:GetView(), startScale, endScale, startTime, duration)
	else
		-- its a view
		return continuous_scale_view(objOrView, startScale, endScale, startTime, duration)
	end
end


-- continuous_blend(objView, startAlpha, endAlpha, startTime, duration)
--	changes alpha of an object over time
local continuous_blend_view = gen_continuous( 
	function(v, alpha)
		--LOG("alpha ".. alpha)
		if v then v:SetAlpha(alpha) end
	end)
	
function _G.continuous_blend(objOrView, startAlpha, endAlpha, startTime, duration)
	if objOrView.GetView then
		-- its an object
		LOG("THIS IS BAD!!!! use of continuous_blend on objects is deprecated. it now takes a view. THIS IS BAD!!!! ")
		return continuous_blend_view(objOrView:GetView(), startAlpha, endAlpha, startTime, duration)
	else
		-- its a view
		return continuous_blend_view(objOrView, startAlpha, endAlpha, startTime, duration)
	end
end


-- Used to iterator over objects in an attribute collection.  For example:
--   for index, object in IterateCollection(object, "my_attribute") do
--   end
function _G.IterateCollection(object, name) 
    local idx = 1

	local colIndex
	if type(name) == "string" then
		colIndex = object:GetAttributeCollectionIndex(name)
	else
		colIndex = name
	end
	
	local last = object:NumAttributesByIndex(colIndex)

    return function ()
        if idx > last then
            return
        end
        local previousIndex = idx
        idx = idx + 1
        return previousIndex, object:GetAttributeAtByIndex(colIndex, previousIndex)
    end
end


function _G.CollectionFindIf(object, collection, f)
	--for i=1,object:NumAttributes(collection) do
	for i,a in IterateCollection(object, collection) do
		--local a = object:GetAttributeAt(collection, i)
		if f(a) then
			return a
		end
	end
	return nil
end


function _G.CollectionCountIf(object, collection, f)
	local c = 0
	--for i=1,object:NumAttributes(collection) do
	for i,a in IterateCollection(object, collection) do
		--local a = object:GetAttributeAt(collection, i)
		if f(a) then
			c = c + 1
		end
	end
	return c
end

-- returns true if attr is in collection
-- warning: O(N)
function _G.CollectionContainsAttribute(object, collection, attr)

	if CollectionFindIf(object,collection,
		function(a)
			return a == attr
		end)
	then
		return true
	end
	return false
end


-- returns a table containing the all the items in a collection or only those that satisfy the predicate

local function true_p(a)
	return true
end

function _G.CollectionToTable(object, name, f)
	f = f or true_p
	
	local t = {}
	for i,a in IterateCollection(object, name) do
		if f(a) then
			t[#t+1] = a -- append
		end
	end
	return t
end

