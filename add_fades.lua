-- this script adds fades to the selected items

-- import the utils.lua file
package.path = debug.getinfo(1, "S").source:sub(2):match("(.*/)") .. "?.lua"
local utils = require("utils")

-- ask user for values
local title = "Fade Parameters"
local captions = "Fade-in time (ms),Fade-in shape,Fade-out time (ms), Fade-out shape"
local defaults = "5,0,100,0"
local ok, values = reaper.GetUserInputs(title, 4, captions, defaults)

if ok then
	local userValues = utils.splitString(values)

	-- get the total items in the project
	local totalItems = reaper.CountMediaItems(0)

	-- fade times in seconds
	local fadeInTime = tonumber(userValues[1]) / 1000
	local fadeOutTime = tonumber(userValues[3]) / 1000

	-- fade shapes 0=linear
	local fadeInShape = tonumber(userValues[2])
	local fadeOutShape = tonumber(userValues[4])

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