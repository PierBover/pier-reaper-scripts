-- edits adds fades from the selected items
-- if no values are provided then the particular setting is ignored

-- import the utils.lua file
package.path = debug.getinfo(1, "S").source:sub(2):match("(.*/)") .. "?.lua"
local utils = require("utils")

-- ask user for values
local title = "Fade Parameters"
local captions = "Fade-in time (ms),Fade-in shape,Fade-out time (ms),Fade-out shape"
local defaults = "5,0,100,0"
local ok, values = reaper.GetUserInputs(title, 4, captions, defaults)

if ok then
	local userValues = utils.splitString(values)

	-- FADE IN
	local fadeInTime = nil
	if userValues[1] ~= '' then fadeInTime = tonumber(userValues[1]) / 1000 end

	local fadeInShape = nil
	if userValues[2] ~= '' then fadeInShape = tonumber(userValues[2]) end

	-- FADE OUT
	local fadeOutTime = nil
	if userValues[3] ~= '' then fadeOutTime = tonumber(userValues[3]) / 1000 end

	local fadeOutShape = nil
	if userValues[4] ~= '' then fadeOutShape = tonumber(userValues[4]) end

	-- get the total items in the project
	local totalItems = reaper.CountMediaItems(0)

	if totalItems > 0 then
		-- iterate over all the items
		for i = 0, totalItems - 1 do
			-- get the item
			local item = reaper.GetMediaItem(0, i)

			-- if the item is currently selected...
			-- this is recommended in the docs over using GetSelectedMediaItem as it's slower
			if reaper.IsMediaItemSelected(item) then
				-- fade in
				if fadeInTime ~= nil then reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", fadeInTime) end
				if fadeInShape ~= nil then reaper.SetMediaItemInfo_Value(item, "C_FADEINSHAPE", fadeInShape) end

				-- fade out
				if fadeOutTime ~= nil then reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", fadeOutTime) end
				if fadeOutShape ~= nil then reaper.SetMediaItemInfo_Value(item, "C_FADEOUTSHAPE", fadeOutShape) end
			end
		end
	end

	-- update the GUI so that the fades are displayed in the clips
	reaper.UpdateArrange()
end