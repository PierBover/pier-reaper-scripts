module = {}

-- splits a CSV string
function module.splitString (s)
	local values = {}
	for match in string.gmatch(s, "([^,]*)") do
		table.insert(values, match)
	end
	return values
end

return module