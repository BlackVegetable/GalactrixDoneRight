
function TableSort(tbl, callback)
	assert(callback, "No sorting function")
	table.sort(tbl, callback)
	return tbl
end


return TableSort