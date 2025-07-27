-- add fades to the selected items

-- splits a CSV string
function SplitString (s)
	local values = {}
	for match in string.gmatch(s, "([^,]*)") do
		table.insert(values, match)
	end
	return values
end

-- ask user for values
local title = "Fade Parameters"
local captions = "Fade-in (ms),Fade-out (ms)"
local defaults = "5,100"
local ok, values = reaper.GetUserInputs(title, 2, captions, defaults)

if ok then
	local userValues = SplitString(values)

	-- get the total items in the project
	local totalItems = reaper.CountMediaItems(0)

	-- fade times in seconds
	local fadeInTime = tonumber(userValues[1]) / 1000
	local fadeOutTime = tonumber(userValues[2]) / 1000

	-- fade shapes 0=linear
	local fadeInShape = 0
	local fadeOutShape = 0

	if totalItems > 0 then
		-- iterate over all the items
		for i = 0, totalItems - 1 do
			-- get the item
			local item = reaper.GetMediaItem(0, i)

			-- if the item is currently selected...
			-- this is recommended in the docs over using GetSelectedMediaItem as it's slower
			if reaper.IsMediaItemSelected(item) then
				-- fade in
				reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", fadeInTime)
				reaper.SetMediaItemInfo_Value(item, "C_FADEINSHAPE", fadeInShape)

				-- fade out
				reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", fadeOutTime)
				reaper.SetMediaItemInfo_Value(item, "C_FADEOUTSHAPE", fadeOutShape)
			end
		end
	end

	-- update the GUI so that the fades are displayed in the clips
	reaper.UpdateArrange()
end