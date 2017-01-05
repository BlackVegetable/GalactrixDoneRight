

-- nil or empty strings return nil.
function _G.StringOrNil(s)
	return s ~= "" and type(s) == "string" and s or nil
end
