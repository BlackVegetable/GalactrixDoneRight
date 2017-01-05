
-- iterator binder
-- we can bind the data to the iterator.
-- this will allow us to pass an iterator as a single argument
-- note this isnt any different to 
--	bind1st(gen,data)
-- but it may be more efficient
function iterator(gen, data)
	local d=data;
	local g=gen;
	return function(_, s)
		return gen(data,s);
	end
end


function keys(data)
	local k
	return function()
		local v
		k,v = next(data,k);
		return k;
	end
end


function values(data)
	local k
	return function()
		local v
		k,v = next(data,k);
		return v;
	end
end

