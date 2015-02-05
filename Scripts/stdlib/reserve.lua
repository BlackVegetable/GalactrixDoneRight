
-- functions to handle reserving sizes for tables
-- needs support from C API.


nothing		= nothing or function() end
-- reserve array part
ireserve	= ireserve or nothing
-- reserve hash part
hreserve	= hreserve or nothing
-- compact a table.
compact		= compact or nothing

-- functions to switch mem allocator




